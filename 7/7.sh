#!/bin/bash

rm -rf tmp
mkdir tmp

ROOT="$(pwd)"
re='^[0-9]+$'

while read -r LINE
do
  FIRST=$(echo $LINE | awk '{print $1}')
  if [[ $FIRST == "\$" ]]
  then
    SECOND=$(echo $LINE | awk '{print $2}')
    if [[ $SECOND == "cd" ]]
    then
      THIRD=$(echo $LINE | awk '{print $3}')
      if [[ $THIRD == '..' ]]
      then
        cd ..
        continue
      elif [[ $THIRD == '/' ]]
      then
        cd $ROOT/tmp
        continue
      else
        cd $THIRD
      fi
    elif [[ $SECOND == "ls" ]]
    then
      continue
    fi
  elif [[ $FIRST == "dir" ]]
  then
    SECOND=$(echo $LINE | awk '{print $2}')
    mkdir $SECOND
    continue
  elif [[ $FIRST =~ $re ]]
  then
    SECOND=$(echo $LINE | awk '{print $2}')
    echo $FIRST > $SECOND
    continue
  fi
done < input

cd $ROOT

SUM=0
for DIR in $(find tmp -type d)
do
  DIRSUM=$(find $DIR -type f -exec cat {} \; | paste -sd+ - | bc)
  if [[ $DIRSUM -le 100000 ]]
  then
    SUM=$((SUM+DIRSUM))
  fi
done

echo $SUM

cd $ROOT
FSSIZE=70000000
UNUSED=30000000
USED=$(find tmp -type f -exec cat {} \; | paste -sd+ - | bc)
NEEDED=$((UNUSED-FSSIZE+USED))

>dirsizes
for DIR in $(find tmp -type d)
do
  DIRSUM=$(find $DIR -type f -exec cat {} \; | paste -sd+ - | bc)
  echo $DIRSUM >> dirsizes
done

for LINE in $(cat dirsizes | sort -n)
do
  if [[ $LINE -ge $NEEDED ]]
  then
    echo $LINE
    break
  fi
done

rm -rf tmp dirsizes