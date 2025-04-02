#!/bin/bash

ans=-1 # Initiliazing varible for the 'until' loop.

# Main Loop - Display Menu #
until [ $ans -eq 5 ]; do
	# Menu Options #
	echo "----------------------------------------------------------------"
	echo "1. Creation of a file with a company's employers information."
	echo "2. Addition of an employer."
	echo "3. Search of an employer based on their ID."
	echo "4. Show Highest and Lowest wage employee."
	echo "5. Exit"
	echo "[SYSTEM] Choose the action you want:"
	read ans

	# Validate user Input #
	while [[ $ans != 1 && $ans != 2 && $ans != 3 && $ans != 4 && $ans != 5 ]]; do
		echo "Invalid input. Enter a number from 1 to 5."
		read ans
	done
 
	# Option 1 - Create File #
	if [ $ans -eq 1 ]; then
		echo "You have chosen to create a new file! How you wish to name it:"
		read name_of_file

  		# Check if the file already exists #
		while [[ -f "$name_of_file.txt" ]]; do
			echo "File already exists. Enter an alternate name:"
			read name_of_file
		done
		
		touch "$name_of_file.txt"
		cfile="$name_of_file.txt" # Created file variable.
		echo "[SYSTEM] File created successfully."

	# Option 2 - Add a new Employee #
	elif [ $ans -eq 2 ]; then
		echo "[SYSTEM] You have chosen to add a new employee!"
		echo "[SYSTEM] Enter the password:"
		read pass
		echo "[SYSTEM] Enter Surname:"
		read surname
		echo "[SYSTEM] Enter Name:"
		read name
  
		# Input Validation #
		echo "[SYSTEM] Enter ID:"
		read id
	
		char=$(echo -n "$id" | grep -o "[A-Z]" | wc -l)
		numbers=$(echo -n "$id" | grep -o "[0-9]" | wc -l)
		
		while [[ $char < 1 ]] || [[ $char > 2 ]] || [[ $numbers -ne 6 ]]; do
			echo "Invalid ID format. Try again with 2 upper case letters followed by exactly 6 numbers."
			read id
			char=$(echo -n "$id" | grep -o "[A-Z]" | wc -l)
			numbers=$(echo -n "$id" | grep -o "[0-9]" | wc -l)
		done
		
		echo "[SYSTEM] Enter wage:"
		read wage
		echo "[SYSTEM] Enter number of children:"
		read children
		
		echo "$pass $surname $name $id $wage $children" >> $cfile
		
		echo "[SYSTEM] File has been updated with new employee's data!"
	
	# Option 3 - Search Employee by ID #
	elif [ $ans -eq 3 ]; then
		echo "[SYSTEM] You have chosen to search an employee based by ID! Enter their ID:"
		read search_id
  
		# Validate ID Format #
		char=$(echo -n "$search_id" | grep -o "[A-Z]" | wc -l)
		numbers=$(echo -n "$search_id" | grep -o "[0-9]" | wc -l)
		
		while [[ $char < 1 ]] || [[ $char > 2 ]] || [[ $numbers -ne 6 ]]; do
			echo "Invalid ID format. Try again with 2 upper case letters followed by exactly 6 numbers."
			read search_id
			char=$(echo -n "$search_id" | grep -o "[A-Z]" | wc -l)
			numbers=$(echo -n "$search_id" | grep -o "[0-9]" | wc -l)
		done
		
		# Search for the employee in the file #
		awk -v search_id="$search_id" '$4 == search_id' $cfile
	
	# Option 4 - Show Employees from highest to lowest wage #
	elif [ $ans -eq 4 ]; then
		# Saving the respective line's info to temp variables to be able to print it at the end #
		awk 'BEGIN{max=-1; min=10000} 
		$5 > max { max=$5; max_p=$1; max_sur=$2; max_name=$3; max_id=$4; max_chi=$6 } 
		$5 < min { min=$5; min_p=$1; min_sur=$2; min_name=$3; min_id=$4; min_chi=$6 }
		END{ print "The employee with the highest wage is:", max_p,max_name,max_sur,max_id,max,max_chi, "\nThe employee with the lowest wage is:", min_p,min_name,min_sur,min_id,min,min_chi}' $cfile
	
	# Option 5 - Exit #
	elif [ $ans -eq 5 ]; then
		echo "You have chosen to exit the program. EXITING!"
		exit 0
	fi
done
