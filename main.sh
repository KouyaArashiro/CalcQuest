#! /bin/bash
    
NUMBER_OF_QUESTIONS=10

generate_problem() {
    local level=$1
    local num1 num2

    operators=('+' '-' '*' '/')

    cp /dev/null questions.dat
    cp /dev/null answers.dat

    for i in $(seq 1 $NUMBER_OF_QUESTIONS) ; do
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

    for i in $(seq 1 "$NUMBER_OF_QUESTIONS") ; do
        echo -n "    $(head -n "$i" questions.dat | tail -n 1) = "
        read -r user_answer
		while :; do
			integer_regex='^-?[0-9]+$'
			float_regex='^-?[0-9]*\.[0-9]+$'
		   if [[ $user_answer =~ $integer_regex || $user_answer =~ $float_regex ]]; then
		       break
		    else
                echo -n "    $(head -n "$i" questions.dat | tail -n 1) = "
				read -r user_answer
			fi
		done
        echo "$user_answer" >> user_answers.dat
    done
}

scorering_user_answers() {
    score=0
	level=${1}
	answer_time=${2}

    for i in $(seq 1 "$NUMBER_OF_QUESTIONS") ; do 
        correct=$(head -n "$i" answers.dat | tail -n 1)
        user_answer=$(head -n "$i" user_answers.dat | tail -n 1)
        if [ "$correct" == "$user_answer" ]; then
            ((score+=10))
        fi
	done

	factors=(0.8 0.6 0.4)
	case $level in
		1) if [ $(echo "$answer_time < 10" | bc) ]; then
			   return
		   elif [ $(echo "$answer_time < 20" | bc) ]; then
			   ((score*=${factors[0]}))
		   elif [ $(echo "$answer_time < 30" | bc) ]; then
			   ((score*=${factors[1]}))
		   else
			   ((score*=${factors[2]}))
		   fi ;;
		2) if [ $(echo "$answer_time < 20" | bc) ]; then
			   return
		   elif [ $(echo "$answer_time < 40" | bc) ]; then
			   ((score*=${factors[0]}))
		   elif [ $(echo "$answer_time < 60" | bc) ]; then
			   ((score*=${factors[1]}))
		   else
			   ((score*=${factors[2]}))
		   fi ;;
		3) if [ $(echo "$answer_time < 30" | bc) ]; then
			   return
		   elif [ $(echo "$answer_time < 50" | bc) ]; then
			   ((score*=${factors[0]}))
		   elif [ $(echo "$answer_time < 70" | bc) ]; then
			   ((score*=${factors[1]}))
		   else
			   ((score*=${factors[2]}))
		   fi ;;
		4) if [ $(echo "$answer_time < 50" | bc) ]; then
			   return
		   elif [ $(echo "$answer_time < 70" | bc) ]; then
			   ((score*=${factors[0]}))
		   elif [ $(echo "$answer_time < 90" | bc) ]; then
			   ((score*=${factors[1]}))
		   else
			   ((score*=${factors[2]}))
		   fi ;;
		5) if [ $(echo "$answer_time < 70" | bc) ]; then
			   return
		   elif [ $(echo "$answer_time < 90" | bc) ]; then
			   ((score*=${factors[0]}))
		   elif [ $(echo "$answer_time < 110" | bc) ]; then
			   ((score*=${factors[1]}))
		   else
			   ((score*=${factors[2]}))
		   fi ;;
		esac

		if [ $score -eq 100 ]; then
		    echo " Your score: $score Congratulations!!!"
		elif [ $(echo "$score < 80" | bc) ]; then
		    echo " Your score: $score Super!!"
		elif [ $(echo "$score < 60" | bc) ]; then
		    echo " Your score: $score Good!"
		else
		    echo " Your score: $score Soso.."
		fi 
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
sort -g -k 1 history.dat > history.tmp && head -n 10 history.tmp > history.dat && rm -f history.tmp

scorering_user_answers "$level" "$answer_time"
#show_history
