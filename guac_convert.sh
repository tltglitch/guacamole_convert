#!/bin/bash

clear

#declare static variables
log=convert.log
now=$(date)
bold=$(tput bold)
normal=$(tput sgr0)
recordings=/mnt/recordings/  #replace this directory with your recordings directory. e.g /example/recordings/

#Welcome message
echo -e "${bold}WELCOME TO GUAC VIDEO CONVERTER SCRIPT ${normal}\n"

echo -e "${bold}You are currently logged in as "$USER" ${normal}\n"

echo -e "Available files to convert: \n"

#list available files to convert except for already converted files 
ls -I "*.m4v" $recordings

#loop if input is NULL
echo
echo "Enter the file name to convert: "
read -e INPUT
echo
while [ -z $INPUT ]; do
        clear
        echo
        echo -e "${bold}Warning: You cannot leave file name as NULL ${normal}\n"
	echo -e "Available files to convert: \n"
	ls -I "*.m4v" $recordings  
	echo
        echo "Enter Choice:"
        read -e INPUT
        echo
        let COUNTER++
        #echo "Counter =$COUNTER"
done


find $recordings -type f -name "$INPUT" | grep . > /dev/null 2>&1
status=$?

if [ $status -eq 0 ]
then
        echo -e "The file '$INPUT' was found! Converting : '$INPUT'\n"
	echo -e "Working on it ....\n"
        guacenc -s 1280x720 -r 20000000 -f $recordings$INPUT 
        sleep 2

        echo -e "Progress: ................................................. (80%)\n"
		echo -e "Convertion completed succesfully\n "
		sleep 1

	    echo -e "Deleting Old Converted RAW file \n"
		echo -e "Progress: .......................................................... (90%)\n"
		echo "Success Log: Converted '$INPUT' to '$INPUT.mv4' by user '$USER' - $now" >> $log
		rm $recordings$INPUT 

		sleep 2

		echo -e "Deletion completed succesfully \n"
		echo -e "Progress: ................................................................. (100%)\n"

		echo -e "All tasks completed succesfully \n"
		echo -e "Thank you $USER \n"
else
        echo -e "Sorry, the file '$INPUT' you entered was not found.\n"
	echo "Error Log: Failed to find file '$INPUT' entered by '$USER' - $now" >> $log
        echo -e "Exiting now. \n"
fi
