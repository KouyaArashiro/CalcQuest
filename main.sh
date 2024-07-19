#! /bin/bash

generate_problem() {
    local level=$1
    local number_of_questions=10
    local num1 num2 operator_num

    operators=(+ - x /)


    for i in `seq 1 $number_of_questions` ; do
        case $level in
           1) num1=$((RANDOM % 10)); num2=$((RANDOM % 10)); operator_num=$((RANDOM % 4)) ;;
           2) num1=$((RANDOM % 10)); num2=$((RANDOM % 90 + 10)); operator_num=$((RANDOM % 4)) ;;
           3) num1=$((RANDOM % 90 + 10)); num2=$((RANDOM % 90 + 10)); operator_num=$((RANDOM % 4)) ;;
           4) num1=$((RANDOM % 90 + 10)); num2=$((RANDOM % 900 + 100)); operator_num=$((RANDOM % 4)) ;;
           5) num1=$((RANDOM % 900 + 100)); num2=$((RANDOM % 900 + 100)); operator_num=$((RANDOM % 4)) ;;

        esac
        echo $num1 ${operators[$operator_num]} $num2 >> questions.dat
    done

}

echo " Hello, CalcQuest!"
echo " Please select a level"

echo "   1: Single-Single Digits"
echo "   2: Single-Double Digits"
echo "   3: Double-Double Digits"
echo "   4: Double-Triple Digits"
echo "   5: Triple-Triple Digits"

while :; do
   read -rp " Level: " level
   if (( level < 1 || level > 5 )); then
      echo " Please select a level (1/2/3/4/5) "  
   else
      break
   fi
done

generate_problem $level

echo  -n " Are you ready? (Enter) "
read -r REPLY
seconds=3
while [ $seconds -gt 0 ]; do
   echo -ne "          $seconds\r"
   sleep 1
   ((seconds--))
done

start_time=$(date +%s)
#user_answer=get_answer problem
end_time=$(date +%s)

#scoreing user_answer
#show_history
