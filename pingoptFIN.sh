#!/bin/bash

IPdatabase="http://pastebin.com/raw/zuumkaS6" # IP DATABASE address

reset_delay=5
connection_delay=7
ping_cap=100    #150
ping_count=1

mean=()
final_mean=0

IP_list=()
ping_list=()

#default IPs
#singapore=(103.28.54.1 103.28.55.1 103.10.124.1 10.156.7.1 45.121.184.1 45.121.185.1)
#singapore_ip=()

##india=(180.149.41.1 10.130.205.1 116.202.224.146 45.113.191.1)
##india=(155.133.233.0 155.133.233.255 155.133.232.0 155.133.232.255 182.79.252.66)

#india=(google.com dxb.valve.net sto.valve.net vie.valve.net 146.66.158.1 208.78.164.1 192.69.96.1 103.10.124.1 152.111.192.1 203.50.6.96 gru.valve.net 182.79.252.66 162.254.194.1 162.254.199.1 45.121.184.1 155.133.240.1 45.121.187.1 155.133.244.151 197.80.4.37 155.133.247.1 155.133.249.1 190.216.121.3 155.133.232.69 155.133.232.2)
#india_ip=()

#uae=(dxb.valve.net 185.25.183.1)
#uae_ip=()

echo "                                                                     "
echo "|-------------------------------------------------------------------|"
echo "|___________________________PING OPTIMIZER__________________________|" #start
echo "|-------------------------------------------------------------------|"
echo "                                                                     "
echo "By Nilay Savant"
echo "                                                                     "


#FUNCTION DEFS--------------------------------------------------------------
timestamp() {
  date +"%d-%m-%Y,%H:%M:%S"
}

IP_update() { # Updates IPs from the web database in 'IPdatabase' variable
	 content=$(wget $IPdatabase -q -O -)  # get raw content from IPdatabase
	 a=1; #loop iteration variable
	 IPi=$(echo "$content" | cut -d';' -f $a) # Split IPs into individual IP using delimeter";" and iterate using a var 'a'
	 
	 while [[ ! -z "${IPi// }" ]] # while loop: checks if the IPi var is not empty or not only whitespace
	 do
		IP_list+=($IPi) # apppends IPi to IP_list
		((a=a+1))
		IPi=$(echo "$content" | cut -d';' -f $a) # Move to next IP in content
	 done
	 
	 #PRINTS IP LIST
	 #for i in "${IP_list[@]}" 
	 #do
		#printf "$i\t" 
	 #done
	 echo "IPs Updated !"
}

Ping (){ #ping calculate
	pingt=$(ping -n $ping_count $1 | tail -1 | awk '{print $9}' | rev | cut -c3- | rev) #ping calculate
	echo "$pingt"                                                    
}
	
Mean (){ #To calculate mean
	declare -a meanAr=("${!1}")
	a=0
	meant=0
	for i in "${meanAr[@]}"
	do
		if [[ $i -ne 0 ]]
		then
			((meant=$meant+$i))
			((a=$a+1))
		fi
	done
	if [[ $a -ne 0 ]]
	then
		((meant=$meant/$a))
		echo "$meant"
	else
		echo 0
	fi
}

IPaddr (){
	#for ext IP
	ipext=$(wget http://ipinfo.io/ip -qO -)
	ipext=$(wget http://ipinfo.io/ip -qO -)
	echo "external IP : "$ipext #for ext IP
	echo "                                                                     "
}

CalculatePing (){ #Actual calculation
	
	#General
	j=0
	for i in "${IP_list[@]}" #calculates pings for each IP
	do
		#Ping $i
		ping_list[$j]=$(Ping $i)
		((j=j+1))
	done  
	mean[3]=$(Mean ping_list[@]) #finds mean of pings and stores mean in array
	printf "< ${mean[3]} >"
	printf " GENER     :\t"
	for i in "${ping_list[@]}" #prints pings for each ip
	do
		printf "$i\t" 
	done
	printf "\n\n"
	
	
	#SINGAPORE
	#j=0
	#for i in "${singapore[@]}" #calculates pings for each IP
	#do
		#Ping $i
		#singapore_ip[$j]=$(Ping $i)
		#((j=j+1))
	#done
	#mean[0]=$(Mean singapore_ip[@]) #finds mean of pings and stores mean in array
	#printf "< ${mean[0]} >"
	#printf " SINGAPORE :\t"
	#for i in "${singapore_ip[@]}" #prints pings for each ip
	#do
		#printf "$i\t" 
	#done
	#printf "\n\n"
	
	#INDIA
	#j=0
	#for i in "${india[@]}" #calculates pings for each IP
	#do
		##Ping $i
		#india_ip[$j]=$(Ping $i)
		#((j=j+1))
	#done  
	#mean[1]=$(Mean india_ip[@]) #finds mean of pings and stores mean in array
	#printf "< ${mean[1]} >"
	#printf " INDIA     :\t"
	#for i in "${india_ip[@]}" #prints pings for each ip
	#do
		#printf "$i\t" 
	#done
	#printf "\n\n"
	
	#UAE
	#j=0
	#for i in "${uae[@]}" #calculates pings for each IP
	#do
		#Ping $i
		#uae_ip[$j]=$(Ping $i)
		#((j=j+1))
	#done
	#mean[2]=$(Mean uae_ip[@])  #finds mean of pings and stores mean in array
	#printf "< ${mean[2]} >"
	#printf " UAE       :\t"
	#for i in "${uae_ip[@]}"  #prints pings for each ip
	#do
		#printf "$i\t"
	#done
	#printf "\n\n"
}


#THE EXECUTION ------------------------------------------------------------------
echo "                                                                     "
echo "updating IPS..."
IP_update
echo "                                                                     "
echo "calculating ping...."
echo "                                                                     "
CalculatePing
final_mean=$(Mean mean[@])
((ping=$final_mean))
printf "< $final_mean > : FINAL PING : < $final_mean > -------------------------------------|\n\n"
echo "                                                                     "
IPaddr

((ping=$final_mean))

echo "                                                                     "
count=1 #for counting loops

if [[ $ping -ge $ping_cap ]] && [[ $ping -ne 0 ]]
then
	read -n1 -r -p "Press space to reset connection..." key
	printf "\n\n"
	if [ "$key" = '' ]
	then
		read -p "enter password for ssh: " -s pass #read pass
	fi
fi
if	[[ $ping -eq 0 ]]
then
	read -p "enter password for ssh: " -s pass #read pass
	echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
	sleep $connection_delay
	echo "calculating ping...."
	echo "                                                                     "
	CalculatePing
	final_mean=$(Mean mean[@])
	((ping=$final_mean))
	printf "< $final_mean > : FINAL PING : < $final_mean > -------------------------------------|\n\n"
	echo "                                                                     "
fi
echo "                                                                     "
while [ $ping -ge $ping_cap ] || [ $ping -eq 0 ]
do
	read -n1 -r -p "Press space to reset connection..." key
	printf "\n\n"
	if [ "$key" = '' ]
	then
		if [ $ping -ne 0 ]
		then
			echo "try "$count
			echo "---->"
			echo "ppp config ppp0 down" | plink -ssh  admin@192.168.1.1 -pw $pass #disconnect wan
			sleep $reset_delay
			echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
			sleep $connection_delay
			echo "calculating ping...."
			echo "                                                                     "
			CalculatePing
			final_mean=$(Mean mean[@])
			((ping=$final_mean))
			printf "< $final_mean > : FINAL PING : < $final_mean > -------------------------------------|\n\n"
			echo "                                                                     "
			count=$(($count+1)) #update count
			#sleep 2
		else
			echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
			sleep $connection_delay
			echo "                                                                     "
			CalculatePing
			
			final_mean=$(Mean mean[@])
			((ping=$final_mean))
			printf "< $final_mean > : FINAL PING : < $final_mean > -------------------------------------|\n\n"
			echo "                                                                     "
		fi
	
	fi
done
pass="NONE" #reset pass

IPaddr
echo "                                                                     "
IPA=$(echo "$(IPaddr)" | cut -d' ' -f 4)

echo "logging data..."
printf "$(timestamp),$IPA,$ping"$'\r' >> PINGLOG.csv
echo "done!"
echo "                                                                     "
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"
echo "|------------------PING OPTIMIZATION COMPLETE!!---------------------|"
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"




