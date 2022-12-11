#!/bin/bash

input=${1:-input}

strenght() {
    case $1 in
    20)
    echo $((20*$2))
    ;;
    60)
    echo $((60*$2))
    ;;
    100)
    echo $((100*$2))
    ;;
    140)
    echo $((140*$2))
    ;;
    180)
    echo $((180*$2))
    ;;
    220)
    echo $((220*$2))
    ;;
    *)
    echo 0
    ;;
    esac
}

X=1
CYCLE=0
SS=0
while read -r LINE
do
  INSTR=$(echo $LINE | awk '{print $1}')
  [[ $INSTR == "addx" ]] && ADDITION=$(echo $LINE | awk '{print $2}')
  case $INSTR in

  noop)
    CYCLE=$((CYCLE+1))
    SS=$((SS+$(strenght $CYCLE $X)))
    ;;

  addx)
    for i in 1 2
    do
    CYCLE=$((CYCLE+1))
    SS=$((SS+$(strenght $CYCLE $X)))
    done
    X=$((X+ADDITION))
    ;;
  esac
  if (( $CYCLE >= 220))
  then
    echo $SS
    break
  fi
done < $input

X=1
CYCLE=0
SS=0
while read -r LINE
do
  INSTR=$(echo $LINE | awk '{print $1}')
  [[ $INSTR == "addx" ]] && ADDITION=$(echo $LINE | awk '{print $2}')
  case $INSTR in

  noop)
    CYCLE=$((CYCLE+1))
    if (( $X <= $(expr $CYCLE % 40) )) && (( $(expr $CYCLE % 40) <= $((X+2)) ))
    then
      printf "#"
    else
      printf "."
    fi
    if (( $(expr $CYCLE % 40) == 0 ))
    then
      echo
    fi
    ;;

  addx)
    for i in 1 2
    do
    CYCLE=$((CYCLE+1))
    if (( $X <= $(expr $CYCLE % 40) )) && (( $(expr $CYCLE % 40) <= $((X+2)) ))
    then
      printf "#"
    else
      printf "."
    fi
    if (( $(expr $CYCLE % 40) == 0 ))
    then
      echo
    fi
    done
    X=$((X+ADDITION))
    ;;
  esac
done < $input