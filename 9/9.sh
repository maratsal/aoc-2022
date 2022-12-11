#!/usr/local/bin/bash
# using bash ver >4

X=0
Y=0

XMAX=0
XMIN=0
YMAX=0
YMIN=0

while read -r LINE
do
  DIRECTION=$(echo $LINE | awk '{print $1}')
  STEPS=$(echo $LINE | awk '{print $2}')
  case $DIRECTION in

  R)
    X=$((X+$STEPS))
    if [[ $X -gt $XMAX ]]
    then
      XMAX=$X
    fi
    ;;

  L)
    X=$((X-$STEPS))
    if [[ $X -lt $XMIN ]]
    then
      XMIN=$X
    fi
    ;;

  U)
    Y=$((Y+$STEPS))
    if [[ $Y -gt $YMAX ]]
    then
      YMAX=$Y
    fi
    ;;

  D)
    Y=$((Y-$STEPS))
    if [[ $Y -lt $YMIN ]]
    then
      YMIN=$Y
    fi
    ;;
esac
done < input

echo XMIN=$XMIN, XMAX=$XMAX
echo YMIN=$YMIN, YMAX=$YMAX

XSIZE=$((XMAX-XMIN))
YSIZE=$((YMAX-YMIN))

echo XSIZE=$XSIZE, YSIZE=$YSIZE

[[ $XMIN -lt 0 ]] && HX=${XMIN#-} || HX=0
[[ $YMIN -lt 0 ]] && HY=${YMIN#-} || HY=0

TX=$HX
TY=$HY

XSTART=$HX
YSTART=$HY

echo TX=$TX, TY=$TY

declare -A grid
declare -A grid9

for X in $(seq 0 $XSIZE)
do
  for Y in $(seq 0 $YSIZE)
  do
    grid[$X,$Y]=0
  done
done

grid[$TX,$TY]=1

movet() {
  # TX TY HX HY
  XDIFF=$(($3-$1))
  YDIFF=$(($4-$2))

  if (( ${XDIFF#-} <= 1 )) && (( ${YDIFF#-} <= 1 ))
  then
    TX=$1
    TY=$2
  elif (( ${XDIFF#-} == 2 )) && (( ${YDIFF#-} <= 1 ))
  then
    TX=$(($3-XDIFF/2))
    TY=$4
  elif (( ${YDIFF#-} == 2 )) && (( ${XDIFF#-} <= 1 ))
  then
    TX=$3
    TY=$(($4-YDIFF/2))
  elif (( ${YDIFF#-} == 2 )) && (( ${XDIFF#-} == 2 ))
  then
    TX=$(($3-XDIFF/2))
    TY=$(($4-YDIFF/2))
  fi
}

movet9() {
    HEAD="$1 $2"
    for KNOT in $(seq 1 9)
    do
        movet ${xknot[$KNOT]} ${yknot[$KNOT]} $HEAD
        xknot[$KNOT]=$TX
        yknot[$KNOT]=$TY
        HEAD="$TX $TY"
    done
  grid9[${xknot[9]},${yknot[9]}]=1
}

while read -r LINE
do
  DIRECTION=$(echo $LINE | awk '{print $1}')
  STEPS=$(echo $LINE | awk '{print $2}')
  case $DIRECTION in

  R)
    for I in $(seq $((HX+1)) $((HX+STEPS)))
    do
      HX=$I
      movet $TX $TY $I $HY
      grid[$TX,$TY]=1
    done
    ;;

  L)
    for I in $(seq $((HX-1)) -1 $((HX-STEPS)))
    do
      HX=$I
      movet $TX $TY $I $HY
      grid[$TX,$TY]=1
    done
    ;;

  U)
    for I in $(seq $((HY+1)) $((HY+STEPS)))
    do
      HY=$I
      movet $TX $TY $HX $I
      grid[$TX,$TY]=1
    done
    ;;

  D)
    for I in $(seq $((HY-1)) -1 $((HY-STEPS)))
    do
      HY=$I
      movet $TX $TY $HX $I
      grid[$TX,$TY]=1
    done
    ;;
  esac
done < input

SUM=0
for X in $(seq 0 $XSIZE)
do
  for Y in $(seq 0 $YSIZE)
  do
    # printf ${grid[$X,$Y]}
    SUM=$((SUM+${grid[$X,$Y]}))
  done
  echo
done

echo $SUM

declare -A xknot
declare -A yknot


for I in $(seq 1 9)
do
  xknot[$I]=$XSTART
  yknot[$I]=$YSTART
done

for X in $(seq 0 $XSIZE)
do
  for Y in $(seq 0 $YSIZE)
  do
    grid9[$X,$Y]=0
  done
done

grid9[$XSTART,$YSTART]=1
HX=$XSTART
HY=$YSTART

while read -r LINE
do
  DIRECTION=$(echo $LINE | awk '{print $1}')
  STEPS=$(echo $LINE | awk '{print $2}')
  case $DIRECTION in

  R)
    for I in $(seq $((HX+1)) $((HX+STEPS)))
    do
      HX=$I
      movet9 $I $HY
    done
    ;;

  L)
    for I in $(seq $((HX-1)) -1 $((HX-STEPS)))
    do
      HX=$I
      movet9 $I $HY
    done
    ;;

  U)
    for I in $(seq $((HY+1)) $((HY+STEPS)))
    do
      HY=$I
      movet9 $HX $I
    done
    ;;

  D)
    for I in $(seq $((HY-1)) -1 $((HY-STEPS)))
    do
      HY=$I
      movet9 $HX $I
    done
    ;;
  esac
done < input

SUM=0
for X in $(seq 0 $XSIZE)
do
  for Y in $(seq 0 $YSIZE)
  do
    # printf ${grid9[$X,$Y]}
    SUM=$((SUM+${grid9[$X,$Y]}))
  done
  echo
done

echo $SUM