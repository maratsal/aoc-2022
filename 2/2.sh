#!/bin/bash
SUM=0
ROUND=0
CHOICE=0

while read -r LINE
do
  if [[ $LINE == "A X" ]]
  then
    ROUND=3
    CHOICE=1
  elif [[ $LINE == "B Y" ]]
  then
    ROUND=3
    CHOICE=2
  elif [[ $LINE == "C Z" ]]
  then
    ROUND=3
    CHOICE=3
  elif [[ $LINE == "C X" ]]
  then
    ROUND=6
    CHOICE=1
  elif [[ $LINE == "C Y" ]]
  then
    ROUND=0
    CHOICE=2
  elif [[ $LINE == "B X" ]]
  then
    ROUND=0
    CHOICE=1
  elif [[ $LINE == "B Z" ]]
  then
    ROUND=6
    CHOICE=3
  elif [[ $LINE == "A Y" ]]
  then
    ROUND=6
    CHOICE=2
  elif [[ $LINE == "A Z" ]]
  then
    ROUND=0
    CHOICE=3
  fi
SUM=$((SUM+ROUND+CHOICE))
ROUND=0
CHOICE=0
done < input

echo $SUM


SUM=0
ROUND=0
CHOICE=0
while read -r LINE
do
  if [[ $LINE == "A X" ]]
  then
    ROUND=0
    CHOICE=3
  elif [[ $LINE == "B Y" ]]
  then
    ROUND=3
    CHOICE=2
  elif [[ $LINE == "C Z" ]]
  then
    ROUND=6
    CHOICE=1
  elif [[ $LINE == "C X" ]]
  then
    ROUND=0
    CHOICE=2
  elif [[ $LINE == "C Y" ]]
  then
    ROUND=3
    CHOICE=3
  elif [[ $LINE == "B X" ]]
  then
    ROUND=0
    CHOICE=1
  elif [[ $LINE == "B Z" ]]
  then
    ROUND=6
    CHOICE=3
  elif [[ $LINE == "A Y" ]]
  then
    ROUND=3
    CHOICE=1
  elif [[ $LINE == "A Z" ]]
  then
    ROUND=6
    CHOICE=2
  fi
SUM=$((SUM+ROUND+CHOICE))
ROUND=0
CHOICE=0
done < input

echo $SUM
