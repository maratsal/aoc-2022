#!/usr/local/bin/bash
# using bash ver >4

declare -A grid

ROWS=$(cat input | wc -l)
COLUMNS=$(($(head -n 1 input | wc -c)-1))

vup() {
  # vup VALUE ROWINDEX COLINDEX
  for ROWINDEX in $(seq $(($2-1)) -1 1)
  do
    if [[ $1 -le ${grid[$ROWINDEX,$3]} ]]
    then
      return 1
    fi
  done
  return 0
}

vdown() {
  # vup VALUE ROWINDEX COLINDEX
  for ROWINDEX in $(seq $(($2+1)) $ROWS)
  do
    if [[ $1 -le ${grid[$ROWINDEX,$3]} ]]
    then
      return 1
    fi
  done
  return 0
}

vleft() {
  # vup VALUE ROWINDEX COLINDEX
  for COLINDEX in $(seq $(($3-1)) -1 1)
  do
    if [[ $1 -le ${grid[$2,$COLINDEX]} ]]
    then
      return 1
    fi
  done
  return 0
}

vright() {
  # vup VALUE ROWINDEX COLINDEX
  for COLINDEX in $(seq $(($3+1)) $COLUMNS)
  do
    if [[ $1 -le ${grid[$2,$COLINDEX]} ]]
    then
      return 1
    fi
  done
  return 0
}

ssup() {
  # vup VALUE ROWINDEX COLINDEX
  SS=0
  for ROWINDEX in $(seq $(($2-1)) -1 1)
  do
    SS=$((SS+1))
    if [[ $1 -le ${grid[$ROWINDEX,$3]} ]]
    then
      echo $SS
      return 0
    fi
  done
  echo $SS
}

ssdown() {
  # vup VALUE ROWINDEX COLINDEX
  SS=0
  for ROWINDEX in $(seq $(($2+1)) $ROWS)
  do
    SS=$((SS+1))
    if [[ $1 -le ${grid[$ROWINDEX,$3]} ]]
    then
      echo $SS
      return 0
    fi
  done
  echo $SS
}

ssleft() {
  # vup VALUE ROWINDEX COLINDEX
  SS=0
  for COLINDEX in $(seq $(($3-1)) -1 1)
  do
    SS=$((SS+1))
    if [[ $1 -le ${grid[$2,$COLINDEX]} ]]
    then
      echo $SS
      return 0
    fi
  done
  echo $SS
}

ssright() {
  # vup VALUE ROWINDEX COLINDEX
  SS=0
  for COLINDEX in $(seq $(($3+1)) $COLUMNS)
  do
    SS=$((SS+1))
    if [[ $1 -le ${grid[$2,$COLINDEX]} ]]
    then
      echo $SS
      return 0
    fi
  done
  echo $SS
}

ROW=1
while read -r LINE
do
  for COL in $(seq 1 $COLUMNS)
  do
    INDEX=$((COL-1))
    grid[$ROW,$COL]=${LINE:INDEX:1}
  done
ROW=$((ROW+1))
done < input

VISIBLE=$(((ROWS-1)*2+(COLUMNS-1)*2))

for ROW in $(seq 2 $((ROWS-1)))
do
  for COL in $(seq 2 $((COLUMNS-1)))
  do
    vleft ${grid[$ROW,$COL]} $ROW $COL || vup ${grid[$ROW,$COL]} $ROW $COL || vright ${grid[$ROW,$COL]} $ROW $COL || vdown ${grid[$ROW,$COL]} $ROW $COL && VISIBLE=$((VISIBLE+1))
    echo $ROW,$COL - $VISIBLE
  done
done

echo $VISIBLE

HSS=0
for ROW in $(seq 2 $((ROWS-1)))
do
  for COL in $(seq 2 $((COLUMNS-1)))
  do
    SSL=$(ssleft ${grid[$ROW,$COL]} $ROW $COL)
    SSU=$(ssup ${grid[$ROW,$COL]} $ROW $COL)
    SSR=$(ssright ${grid[$ROW,$COL]} $ROW $COL)
    SSD=$(ssdown ${grid[$ROW,$COL]} $ROW $COL)
    CSS=$((SSL*SSU*SSR*SSD))
    if [[ $CSS -gt $HSS ]]
    then
      HSS=$CSS
      echo $ROW,$COL - $HSS
    fi
  done
done

echo $HSS