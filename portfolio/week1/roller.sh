#! /bin/bash
#Roll a dice depending on your choice
#Created by Llewellyn Crossley 23 February 2018


#Read the dice types from the arguments
die=$@
dietypeoverall=$(echo $@ | grep -o -E '[0-9]+$')
modifier=(0)

case $@ in 
	*d2|*d4|*d6|*d8|*d10|*d12|*d20)
	for roll in $die #for each die value set by $@, $roll is equal $die
	do
		dietype=$(echo $roll | grep -o -E '[0-9]+$')
		if [[ $roll =~ ^[0-9]+[d][0-9]+$ ]]; then 
			dienum=$(echo $roll | grep -o -E '[0-9]+' |head -1) 
			##echo '1st if'
		elif [[ $roll =~ ^[0-9]+[a-zA-Z_]+[0-9][d][0-9]+$ ]]; then 
			multiplier=$(echo $roll | grep -o -E '[0-9]+' |head -1) 
			prepcount=$(echo $roll | grep -o -E '[a-zA-Z_][0-9]+' | grep -o -E '[0-9]+' | head -1) 
			dienum=$(($multiplier*$prepcount))	
		elif [[ $roll =~ ^[a-zA-Z_]+[0-9]+[d][0-9]+$ ]]; then
			dienum=$(echo $roll | grep -o -E '[0-9]+' |head -1) 
			##echo 'elif 2'
		elif [[ $roll == [d][0-9]* ]]; then
			dienum='1' 
			##echo 'elif 2'
		else 
			echo 'invalid die'
			exit
		fi

	#Outputs Dice details
		read -p 'Enter modifier for '$dienum'd'$dietype': ' modifier
		modcalc=0
		modcalc=$modifier
		echo '--------------Results--------------' 	
	#Outputs Dice Results
		max=${ar[0]} #sets an array for max values and 0s it
		TOTAL=0 #sets Total to 0 for next calculation
			for ((i=1; i<=$dienum; i++));
			do
				result=$(($RANDOM % $dietype + 1)) 
				echo '	#'$i 'd'$dietype':	'$result		
				TOTAL=`expr $TOTAL + $result + $modifier`
					ar=$result
					for n in "${ar[@]}" ; do
					    ((n > max)) && max=$n
					
					done	
					ar=(0)
					modifier=(0)
			done
		echo ""
		echo '	Modifier: '$modcalc
		echo '	Highest:'$max
##		highmod=$(($modifier+$max))
		highmod=`expr $max + $modcalc`
		echo '	Highest+Mod:'$highmod
		echo '	Total(mod):'$TOTAL
		echo "--------------------------------------------------------------" 
	done ;;

	*) 
		echo 'DM: What''s this? a d'$dietypeoverall'?'
		echo 'I''ve never seen a '$dietypeoverall' sided dice before. Re-Roll this one'
		echo "---------------------------------------------------------------"
esac | tee -a rollhistory.txt

