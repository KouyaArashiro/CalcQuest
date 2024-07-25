#! /bin/bash

generate_problem() {
    local level=$1
    local number_of_questions=10
    local num1 num2

    operators=('+' '-' '*' '/')

    cp /dev/null questions.dat
    cp /dev/null answers.dat

    for i in $(seq 1 $number_of_questions) ; do
        case $level in
           1) num1=$((RANDOM % 10)); num2=$((RANDOM % 10));;
           2) num1=$((RANDOM % 10)); num2=$((RANDOM % 90 + 10));;
           3) num1=$((RANDOM % 90 + 10)); num2=$((RANDOM % 90 + 10)) ;;
           4) num1=$((RANDOM % 90 + 10)); num2=$((RANDOM % 900 + 100)) ;;
           5) num1=$((RANDOM % 900 + 100)); num2=$((RANDOM % 900 + 100)) ;;
        esac

        operators_index=$((RANDOM % 4))
        operator=${operators[$operators_index]}
        
        if [ "$operator" = "/" ] && [ $((num2)) -eq 0 ]; then
            num2=$((RANDOM % 10 + 1))
        fi


        if [ "$operator" = "*" ]; then
            echo $num1 '*' $num2 >> questions.dat
            result=$((num1 * num2))
            echo $result >> answers.dat
            continue
        fi
        echo "$num1 $operator $num2" >> questions.dat
        echo "$num1 $operator $num2" | bc >> answers.dat

    done
}

get_answer() {
    cp /dev/null user_answers.dat
    number_of_questions=$(wc -l < questions.dat | awk '{print $1}')
    echo "$number_of_questions"

    for i in $(seq 1 "$number_of_questions") ; do
        echo -n "    $(head -n "$i" questions.dat | tail -n 1) = "
        read -r user_answer
        echo "$user_answer" >> user_answers.dat
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

generate_problem "$level"

echo  -n " Are you ready? (Enter) "
read -r REPLY

### debug mode
#seconds=3
#while [ $seconds -gt 0 ]; do
#   echo -ne "          $seconds\r"
#   sleep 1
#   ((seconds--))
#done

start_time=$(date +%s.%N)
get_answer
end_time=$(date +%s.%N)

answer_time=$(echo "$end_time - $start_time" | bc -l | xargs printf "%.2f\n")
echo " $answer_time seconds"
echo "$answer_time $(date +'%Y/%m/%d %H:%M:%S')" >> history.dat
sort -g -k 1 history.dat > history.tmp && cat history.tmp > history.dat && rm -f history.tmp

#scoreing user_answers
#show_history
