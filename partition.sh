#!/bin/bash

# Welcome message
echo
echo "=========================================================="
echo "| Welcome to partition!                                  |"
echo "| This program will help you get your dataset ready for  |"
echo "| any machine learning task                              |"
echo "=========================================================="

# Prompting user
redo=1
first_question=0
second_question=0
answered=0
while [ $redo -eq 1 ]
do
  if [ $first_question -eq 0 ]; then
    # Give the user the choice of partition format
    echo
    echo "How would you like to partition your dataset?"
    echo "  1) train and validation"
    echo "  2) train, validation and testing"
    echo -ne "Please specify your choice with either '1' or '2': "
    read choice
    if [ $((choice)) -eq 1 ] || [ $((choice)) -eq 2 ]; then
      redo=0
      first_question=1
    else 
      echo "Try again. Enter '1' or '2'."
    fi
  else
    redo=0
  fi

  if [ $redo -eq 0 ]; then
    if [ $second_question -eq 0 ]; then
      # Ask the user to specify the PATH to the dataset 
      echo
      echo -ne "PATH to the dataset ($HOME/path/to/dataset): "
      read -r path
      if [ -d "${path}" ]; then
        echo -ne "PATH is valid." 
        total=$(cd $path && ls | wc -l)
        echo "You've got a total of $total data points"
        second_question=1
      else
        echo "PATH is not valid."
        redo=1
      fi
    fi

    if [ $redo -eq 0 ]; then
      # Ask the user to specify the partition percentages (train)
      echo
      if [ $answered -eq 0 ]; then 
        echo -ne "Percentage of TRAIN data points: "
        read -r train_percentage 

        # User input preprocess
        if [ -z $train_percentage ]; then # Empty
          echo Nothing inputed. Try again.
          redo=1
        elif [[ -n ${train_percentage//[0-9]/} ]]; then
          echo Not an integer.
          redo=1
        elif [ "$train_percentage" -gt 100 ]; then # Wrong
          echo Think about it...
          redo=1
        elif [ $train_percentage -lt 1 ]; then
          train_percentage=$(($train_percentage * 100)) # Float
          answered=1
        else
          answered=1
          echo $answered
        fi
      fi
      
      # Ask the user to specify the partition percentages (validation)
      if [ $((choice)) -eq 2 ] && [ $answered -eq 1 ]; then 
        echo -ne "Percentage of VALIDATION data points: "
        read -r validation_percentage 

      # User input preprocess - validation_percentage
        if [ -z $validation_percentage ]; then # Empty
          echo Nothing inputed. Try again.
          redo=1
        elif [[ -n ${validation_percentage//[0-9]/} ]]; then
          echo Not an integer.
          redo=1
        elif [ "$validation_percentage" -gt 100 ]; then # Wrong
          echo Think about it...
          redo=1
        elif [ $validation_percentage -lt 1 ]; then
          percentage=$(($validation_percentage * 100)) # Float
        fi
      fi
      echo 

      percentage=$(( train_percentage + validation_percentage))
      if [ $percentage -ge 100 ]; then
        echo "Remember you still need the percentage for the testing folder."
        redo=1
      fi

      # Displaying summary
      if [ $redo -eq 0 ]; then
        echo "Summary:"
        echo "  - PATH: $path"
        echo "  - TRAIN PERCENTAGE: $train_percentage%"
        if [ $((choice)) -eq 2 ]; then
          echo "  - VALIDATION PERCENTAGE: $validation_percentage%"
          echo "  - TESTING PERCENTAGE: $((100 - percentage))%"
        else
          echo "  - VALIDATION PERCENTAGE: $((100 - train_percentage))%"
        fi

        echo
        wrong=1
        while [ $wrong -eq 1 ]; do
          echo -ne "Is this correct? (y/n): " 
          read answer
          if [ "$answer" == "y" ]; then
            wrong=0
          elif [ "$answer" == "n" ]; then
            redo=1
            wrong=0
            first_question=0
            second_question=0
            answered=0
          fi
        done
      fi
    fi
  fi
done

# Calculating percentages
train=$(($total*$train_percentage/100))
if [ $((choice)) -eq 2 ]; then
  validation=$((total*validation_percentage/100))
  testing=$((total-train-validation))
else
  validation=$((total-train))
fi

# Partitioning
mkdir $path/train
mkdir $path/validation
if [ $((choice)) -eq 2 ]; then
  mkdir $path/testing
fi

# Move data into train/
echo Moving data points to train folder.
i=0
FILES=$path/*
for file in $FILES
do
  if [ $i -lt $train ]; then
    #echo $file
    mv $file $path/train/
    i=$((i+1))
  fi
done

# Move data into validation/ 
echo Moving data points to validation folder.
i=0
if [ $((choice)) -eq 2 ]; then
  for file in $FILES
  do
    if [ $i -lt $validation ]; then
      #echo $file
      mv $file $path/validation/
      i=$((i+1))
    fi
  done
  echo Moving data points to testing folder.
  mv $path/*.* $path/testing/
else
  mv $path/*.* $path/validation/
fi

echo
echo -------------------------------------
echo Total: $total
echo "  ||---$((train_percentage))%--- Train: $train"
if [ $((choice)) -eq 2 ]; then
  echo "  ||---$((validation_percentage))%--- Validation: $validation"
  echo "  ||---$((100 - percentage))%--- Testing: $testing"
else
  echo "  ||---$((100 - percentage))%--- Validation: $validation"
fi
echo

echo Done!
