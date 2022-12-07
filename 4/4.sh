#!/bin/bash

contain () {
  pair1=$(echo $1 | cut -d "," -f 1)
  pair2=$(echo $1 | cut -d "," -f 2)
  pair1start=$(echo $pair1 | cut -d "-" -f 1)
  pair1end=$(echo $pair1 | cut -d "-" -f 2)
  pair2start=$(echo $pair2 | cut -d "-" -f 1)
  pair2end=$(echo $pair2 | cut -d "-" -f 2)

  if ([[ $pair1start -ge $pair2start ]] && [[ $pair1end -le $pair2end ]]) || ([[ $pair1start -le $pair2start ]] && [[ $pair1end -ge $pair2end ]])
  then
    return 0
  else
    return 1
  fi
}

overlap () {
  pair1=$(echo $1 | cut -d "," -f 1)
  pair2=$(echo $1 | cut -d "," -f 2)
  pair1start=$(echo $pair1 | cut -d "-" -f 1)
  pair1end=$(echo $pair1 | cut -d "-" -f 2)
  pair2start=$(echo $pair2 | cut -d "-" -f 1)
  pair2end=$(echo $pair2 | cut -d "-" -f 2)

  if ([[ $pair1start -ge $pair2start ]] && [[ $pair1start -le $pair2end ]]) || ([[ $pair1start -le $pair2start ]] && [[ $pair1end -ge $pair2start ]])
  then
    return 0
  else
    return 1
  fi
}

sum=0

sumoverlap=0

while read -r LINE
do
  if contain $LINE
  then
    sum=$((sum+1))
  fi
  if overlap $LINE
  then
    sumoverlap=$((sumoverlap+1))
  fi
done < input

echo $sum
echo $sumoverlap