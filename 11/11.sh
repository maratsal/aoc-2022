#!/usr/local/bin/bash
# using bash ver >4

INPUT=${1:-input}

MONKEYS=$(grep ^Monkey $INPUT | sed 's/.$//' | awk '{print $2}')

declare -A monkey

read() {
    MDATA=$(grep -A5 "Monkey $1" $INPUT)
    monkey[$1,0]=$(echo "$MDATA" | grep Starting | awk -F: '{print $2}' | sed 's/,//g')
    monkey[$1,1]=$(echo "$MDATA" | grep Operation | awk '{print $(NF-1)$NF}')
    monkey[$1,2]=$(echo "$MDATA" | grep Test | tr -dc '0-9')
    monkey[$1,3]=$(echo "$MDATA" | grep "If true" | tr -dc '0-9')
    monkey[$1,4]=$(echo "$MDATA" | grep "If false" | tr -dc '0-9')
    monkey[$1,5]=0
}

inspect() {
    if ! [[ ${monkey[$1,0]} =~ [0-9] ]]
    then
        return 0
    fi
    for ITEM in ${monkey[$1,0]}
    do
        monkey[$1,5]=$((${monkey[$1,5]}+1))
        old=$ITEM
        NEW=$((ITEM${monkey[$1,1]}))
        NEW=$((NEW/3))
        if (( $(expr $NEW % ${monkey[$1,2]}) == 0 ))
        then
            monkey[${monkey[$1,3]},0]="${monkey[${monkey[$1,3]},0]} $NEW"
        else
            monkey[${monkey[$1,4]},0]="${monkey[${monkey[$1,4]},0]} $NEW"
        fi
    done
    monkey[$1,0]=""
}

inspectnw() {
    if ! [[ ${monkey[$1,0]} =~ [0-9] ]]
    then
        return 0
    fi
    for ITEM in ${monkey[$1,0]}
    do
        monkey[$1,5]=$((${monkey[$1,5]}+1))
        old=$ITEM
        NEW=$((ITEM${monkey[$1,1]}))
        NEW=$( expr $NEW % $2 )
        if (( $(expr $NEW % ${monkey[$1,2]}) == 0 ))
        then
            monkey[${monkey[$1,3]},0]="${monkey[${monkey[$1,3]},0]} $NEW"
        else
            monkey[${monkey[$1,4]},0]="${monkey[${monkey[$1,4]},0]} $NEW"
        fi
    done
    monkey[$1,0]=""
}

for MONKEY in $MONKEYS
do
    read $MONKEY
done

for ROUND in $(seq 1 20)
do
    printf "$ROUND "
    for MONKEY in $MONKEYS
    do
        inspect $MONKEY
    done
done

echo
INSPECTIONS=""
for MONKEY in $MONKEYS
do
    printf "${monkey[$MONKEY,5]} "
    INSPECTIONS="$INSPECTIONS ${monkey[$MONKEY,5]}"
done

echo
echo $INSPECTIONS | xargs -n1 | sort -g | tail -n 2 | xargs | sed 's/ /*/' | bc

for MONKEY in $MONKEYS
do
    read $MONKEY
done

CD="1"
for MONKEY in $MONKEYS
do
    CD=$((CD*${monkey[$MONKEY,2]}))
done

echo $CD

for ROUND in $(seq 1 10000)
do
    printf "$ROUND "
    (( $(expr $ROUND % 1000) == 0 )) && echo ""
    for MONKEY in $MONKEYS
    do
        inspectnw $MONKEY $CD
        (( $(expr $ROUND % 1000) == 0 )) && printf "${monkey[$MONKEY,5]} "
    done
    (( $(expr $ROUND % 1000) == 0 )) && echo ""
done

echo
INSPECTIONS=""
for MONKEY in $MONKEYS
do
    printf "${monkey[$MONKEY,5]} "
    INSPECTIONS="$INSPECTIONS ${monkey[$MONKEY,5]}"
done
echo
echo $INSPECTIONS | xargs -n1 | sort -g | tail -n 2 | xargs | sed 's/ /*/' | bc