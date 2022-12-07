#!/bin/bash

INPUT=$(cat input)
LENGHT=$(echo ${#INPUT})

for POS in $(seq 0 $((LENGHT-5)))
do
  SEQ=${INPUT:POS:4}
  SEQLEN=$(echo $SEQ | grep -o . | sort | uniq | wc -l)
  if [[ $SEQLEN -eq 4 ]]
  then
    START=$((POS+4))
    echo $START
    break
  fi
done

for POS in $(seq 0 $((LENGHT-15)))
do
  SEQ=${INPUT:POS:14}
  SEQLEN=$(echo $SEQ | grep -o . | sort | uniq | wc -l)
  if [[ $SEQLEN -eq 14 ]]
  then
    START=$((POS+14))
    echo $START
    break
  fi
done