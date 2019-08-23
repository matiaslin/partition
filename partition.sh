#!/bin/bash

# Welcome message
echo
echo "=========================================================="
echo "- Welcome to partition!                                  -"
echo "- This program will help you get your dataset ready for  -"
echo "- any machine learning task                              -"
echo "=========================================================="

# Prompting user
redo=1
while [ $redo -eq 1 ]
do
  # User customizable directories TODO

  # User specify the PATH
  echo
  echo -ne "PATH to the dataset ($HOME/path/to/dataset): "
  read -r path
  if [ -d "${path}" ]; then
    echo -ne "PATH is valid." 
    total=$(cd $path && ls | wc -l)
    echo "You've got a total of $total data points"
    redo=0
  else
    echo "PATH is not valid."
  fi

  if [ $redo -eq 0 ]; then
    # User customizable percentage
    echo
    echo -ne "Percentage of train data points: "
    read -r percentage 
    echo

    # User input preprocess
    if [ -z $percentage ]; then # Empty
      echo Nothing inputed. Try again.
      redo=1
    elif [[ -n ${percentage//[0-9]/} ]]; then
      echo Not an integer.
      redo=1
    elif [ "$percentage" -gt 100 ]; then # Wrong
      echo Think about it...
      redo=1
    elif [ $percentage -lt 1 ]; then
      percentage=$(($percentage * 100)) # Float
    fi
  fi

  # Displaying summary
  echo "Summary:"
  echo "  - PATH: $path"
  echo "  - TRAIN PERCENTAGE: $percentage%"
  echo "  - VALIDATION PERCENTAGE: $((100 - percentage))%"
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
    fi
  done
done

# Calculating percentages
train=$(($total*$percentage/100))
validation=$((total-train))

# Partitioning
mkdir $path/train
mkdir $path/validation

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
mv $path/*.* $path/validation/

echo
echo Done!
echo -------------------------------------
echo Total: $total
echo "  ||---$percentage%--- Train: $train"
echo "  ||---$((100 - percentage))%--- Validation: $validation"
echo

echo Done!
