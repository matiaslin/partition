#!/bin/bash
total=$(ls | wc -l)

redo=1
while [ $redo -eq 1 ]
do
  # User customizable percentage
  echo
  echo -ne Percentage of train data points: 
  read -r percentage 
  redo=0
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
done

# Calculating percentages
train=$(($total*$percentage/100))
validation=$((total-train))

# Partitioning
mkdir train
mkdir validation

# Move all into a file
echo Moving to train.
i=0
FILES=./*
for file in $FILES
do
  if [ $i -lt $train ]; then
    echo $file
    mv $file train/
    i=$((i+1))
  fi
done

echo Moving to Validation.
mv *.jpg validation/

echo
echo Done!
echo -------------------------------------
echo Total: $total
echo "  ||------- Train: $train"
echo "  ||------- Validation: $validation"
echo

echo Done!
