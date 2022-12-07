#!/usr/local/bin/bash
# using bash ver >4

push() {
  eval "STACK$1+=(\"$2\")"
}
peek() { 
  eval "printf %s \${STACK$1[-1]}"
  echo
}
pop() {
  eval "unset 'STACK$1[-1]'"
}

sed '/^$/q' input | grep -v ^$ > order
sed '1,/^$/d' input > movements

sed -i 's/.\{4\}/&;/g' order
sed -i 's/\[//g' order
sed -i 's/\]//g' order
sed -i 's/\ //g' order

STACKS=$(awk -F\; '{print NF; exit}' order)

# create empty stacks
for NUM in $(seq 1 $STACKS)
do
  eval "STACK$NUM=()"
done

# load stacks
for NUM in $(seq 1 $STACKS)
do
  for ITEM in $(eval "awk -F\; '{print \$$NUM}' order | sed '1!G;h;\$!d' | sed '/^\$/d' | tail -n +2")
  do
    push $NUM $ITEM
  done
done

while read -r LINE
do
  NUM=$(echo $LINE | awk '{print $2}')
  FROM=$(echo $LINE | awk '{print $4}')
  TO=$(echo $LINE | awk '{print $6}')
  for ITERATION in $(seq 1 $NUM)
  do
    MOVE=$(peek $FROM)
    pop $FROM
    push $TO $MOVE
  done
done < movements

for NUM in $(seq 1 $STACKS)
do
  printf $(peek $NUM)
done
echo

# create temp array
STACK0=()

# empty stacks
for NUM in $(seq 1 $STACKS)
do
  eval "unset STACK$NUM"
  eval "STACK$NUM=()"
done

# load stacks
for NUM in $(seq 1 $STACKS)
do
  for ITEM in $(eval "awk -F\; '{print \$$NUM}' order | sed '1!G;h;\$!d' | sed '/^\$/d' | tail -n +2")
  do
    push $NUM $ITEM
  done
done

while read -r LINE
do
  NUM=$(echo $LINE | awk '{print $2}')
  FROM=$(echo $LINE | awk '{print $4}')
  TO=$(echo $LINE | awk '{print $6}')
  for ITERATION in $(seq 1 $NUM)
  do
    MOVE=$(peek $FROM)
    pop $FROM
    push 0 $MOVE
  done
  for ITERATION in $(seq 1 $NUM)
  do
    MOVE=$(peek 0)
    pop 0
    push $TO $MOVE
  done
done < movements

for NUM in $(seq 1 $STACKS)
do
  printf $(peek $NUM)
done
echo