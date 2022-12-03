#!/bin/bash

a=1
b=2
c=3
d=4
e=5
f=6
g=7
h=8
i=9
j=10
k=11
l=12
m=13
n=14
o=15
p=16
q=17
r=18
s=19
t=20
u=21
v=22
w=23
x=24
y=25
z=26
A=27
B=28
C=29
D=30
E=31
F=32
G=33
H=34
I=35
J=36
K=37
L=38
M=39
N=40
O=41
P=42
Q=43
R=44
S=45
T=46
U=47
V=48
W=49
X=50
Y=51
Z=52

SUM=0

while read -r LINE
do
  strlen=${#LINE}
  COMP1END=$((strlen/2))
  COMP1=${LINE:0:COMP1END}
  COMP2=${LINE#$COMP1}
  INBOTH=$(tr -dc $COMP1 <<< $COMP2 | uniq)
  INBOTH=${INBOTH::1}
  SUM=$((SUM+$INBOTH))
done < input

echo $SUM

SUM=0
LINES=$(cat input | wc -l)

for LINE in $(seq 3 3 $LINES)
do
  L1=$(sed "${LINE}q;d" input)
  L2=$(sed "$((LINE-1))q;d" input)
  L3=$(sed "$((LINE-2))q;d" input)
  INTWO=$(tr -dc $L2 <<< $L3 | uniq)
  INTHREE=$(tr -dc $L1 <<< $INTWO | uniq)
  INTHREE=${INTHREE::1}
  SUM=$((SUM+$INTHREE))
done

echo $SUM
