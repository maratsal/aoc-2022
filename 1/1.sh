#!/bin/bash

SUM=0
echo "" > output

while read -r LINE
do
  if [[ $LINE == "" ]]
  then
    echo $SUM >> output
    SUM=0 
  elif [[ $LINE != "" ]]
  then
    SUM=$((SUM + LINE))
  fi
done < input

echo "Total Calories of the Elf that carry most calories: $(cat output | sort | tail -1)"

TOP_THREE=0
for CAL in $(cat output | sort | tail -3)
do 
  TOP_THREE=$((TOP_THREE+$CAL))
done

echo "Total Calories of top three Elves: $TOP_THREE"
