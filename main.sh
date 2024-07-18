#! /bin/bash

echo "Hello, CalcQuest!"
echo "Please select a level"

echo "1: Single-Single Digits"
echo "2: Single-Double Digits"
echo "3: Double-Double Digits"
echo "4: Double-Triple Digits"
echo "5: Triple-Triple Digits"

while :; do
   read -p "Level: " level
   if (( $level < 1 || $level > 5 )); then
      echo "Please select a level (1/2/3/4/5) "  
   else
      break
   fi
done

echo "Level: "$level
echo "Are you ready? (Enter) "
read REPLY
seconds=3
while [ $seconds -gt 0 ]; do
   echo -ne $seconds
   sleep 1
   ((seconds--))
done
