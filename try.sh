#!/bin/bash
#http://pastebin.com/raw/zuumkaS6
IPdatabase="http://pastebin.com/raw/zuumkaS6"
#IPA=$(echo "$(IPaddr)" | cut -d'<delimeter>' -f <N>)  N is the index of the value in the splitted array starting from 1

IP_update() { # Updates IPs from the web database in 'IPdatabase' variable
	 content=$(wget $IPdatabase -q -O -)  # get raw content from IPdatabase
	 a=1; #loop iteration variable
	 IPi=$(echo "$content" | cut -d';' -f $a) # Split IPs into individual IP using delimeter";" and iterate using a var 'a'
	 
	 while [[ ! -z "${IPi// }" ]] # while loop: checks if the IPi var is not empty or not only whitespace
	 do
		IPlist+=($IPi) # apppends IPi to IPlist
		((a=a+1))
		IPi=$(echo "$content" | cut -d';' -f $a) # Move to next IP in content
	 done
	 
	 #PRINTS IP LIST
	 #for i in "${IPlist[@]}" 
	 #do
		#printf "$i\t" 
	 #done
}
IP_update
