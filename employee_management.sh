#!/bin/bash
# Project 1 - Subject 2 - Name: Nikolaos Gazis / AM: 2121231.

ans=-1 # Initiliazing to enter the until loop.
until [ $ans -eq 5 ]
do
	# Menu.
	echo "----------------------------------------------------------------
	1. Creation of a file with a company's employers information.
	2. Addition of an employer.
	3. Search of an employer based on their ID.
	4. Show Highest and Lowest wage employee.
	5. Exit"

	echo "•Choose the action you want."
	read ans

	# Check if input is right
	while [[ $ans != 1 && $ans != 2 && $ans != 3 && $ans != 4 && $ans != 5 ]]
	do

		echo "Invalid input, only valid ones are 1 to 5."
		read ans

	done
	# Question 1 - Create File.
	if [ $ans -eq 1 ];
	then
		echo "You have chosen to create a new file, give it a name."
		read name_of_file
		while [[ -f "$name_of_file".txt ]];
		do
			echo "File already exists, you will need an alternate name."
			read name_of_file
		done
		
		touch "$name_of_file".txt
		cfile="$name_of_file".txt # C(reated)file.
		
		echo "-File created successfully.-"
	fi
	# Question 2 - Addition of new employee in the current file.
	if [ $ans -eq 2 ];
	then
		echo "•You have chosen to add a new employee."
		
		echo "•Give the pass:"
		read pass
		echo "•Give Surname:"
		read surname
		echo "•Give Name:"
		read name
		# Input that needs checking.
		echo "•Give ID:"
		read id
		
		# Counting how many letters and numbers the given ID contains, must be Char==1 or Char==2 and have exactly 6 numbers.
		char=$(echo -n "$id" | grep -o "[A-Z]" | wc -l)
		numbers=$(echo -n "$id" | grep -o "[0-9]" | wc -l)
		
		while [[ $char < 1 ]] || [[ $char > 2 ]] || [[ $numbers -ne 6 ]];
		do
			echo "Invalid ID number you have given. Try again with 2 Capital letters and exactly 6 numbers."
			read id
			char=$(echo -n "$id" | grep -o "[A-Z]" | wc -l)
			numbers=$(echo -n "$id" | grep -o "[0-9]" | wc -l)
		done
		
		echo "•Give wage:"
		read wage
		echo "•Give number of children:"
		read children
		
		echo "$pass $surname $name $id $wage $children" >> $cfile
		
		echo "•File has been updated•"
	fi
	
	# Question 3 - Search employee based on ID.
	if [ $ans -eq 3 ];
	then
		echo "•You have chosen to search an employee based on their ID, give the ID:"
		read search_id
		# Have to check if given ID is in the valid format to continue.
		char=$(echo -n "$search_id" | grep -o "[A-Z]" | wc -l)
		numbers=$(echo -n "$search_id" | grep -o "[0-9]" | wc -l)
		
		while [[ $char < 1 ]] || [[ $char > 2 ]] || [[ $numbers -ne 6 ]];
		do
			echo "Invalid ID number you have given. Try again with 2 Capital letters and exactly 6 numbers:"
			read search_id
			char=$(echo -n "$search_id" | grep -o "[A-Z]" | wc -l)
			numbers=$(echo -n "$search_id" | grep -o "[0-9]" | wc -l)
		done
		
		# Using -v to pass a shell variable to awk.
		awk -v search_id="$search_id" '$4 == search_id' $cfile
	fi
	
	# Question 4 - Show employees from highest to lowest wage.
	if [ $ans -eq 4 ];
	then
		# Max - Min (Wage)
		# Saving the respective line's info to temp variables to be able to print it at the end.
		awk 'BEGIN{max=-1; min=10000} 
		$5 > max { max=$5; max_p=$1; max_sur=$2; max_name=$3; max_id=$4; max_chi=$6 } 
		$5 < min { min=$5; min_p=$1; min_sur=$2; min_name=$3; min_id=$4; min_chi=$6 }
		END{ print "The employee with the highest wage is:", max_p,max_name,max_sur,max_id,max,max_chi, "\nThe employee with the lowest wage is:", min_p,min_name,min_sur,min_id,min,min_chi}' $cfile
			
	fi
	
	# Question 5 - Exit.
	if [ $ans -eq 5 ]; 
	then
		echo "You have chosen to exit the program. EXITING!"
		exit 0
	fi
done
