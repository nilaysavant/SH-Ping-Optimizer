#!/bin/bash
reset_delay=5
connection_delay=7
ip="116.202.224.146"      #"sgp-1.valve.net" IND:116.202.224.146 OR 45.113.191.132:27040
ping_cap=100    #150
ping_count=3
echo "|-------------------------------------------------------------------|"
echo "|___________________________PING OPTIMIZER__________________________|" #start
echo "|-------------------------------------------------------------------|"
echo "                                                                     "
echo "By Nilay Savant"
echo "                                                                     "
echo "starting ping optimization...."
echo "calculating ping...."
ping=$(ping -n $ping_count $ip | tail -1 | awk '{print $9}' | rev | cut -c3- | rev) #stating ping calculate
echo "                                                                     "
echo "| PING = "$ping"ms ------------------------------------------------------|" #display ping
echo "                                                                     "
#for ext IP
ipext=$(wget http://ipinfo.io/ip -qO -)
echo "external IP : "$ipext #for ext IP
echo "                                                                     "
count=1 #for counting loops
if [ $ping -ge $ping_cap ] && [ -n "$ping" ]
then
	read -p "enter password for ssh: " -s pass #read pass
fi
if	[ -z "$ping" ]
then
	read -p "enter password for ssh: " -s pass #read pass
	echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
	sleep $connection_delay
	echo "calculating ping...."
	ping=$(ping -n $ping_count $ip | tail -1 | awk '{print $9}' | rev | cut -c3- | rev) #stating ping calculate
	echo "                                                                     "
	echo "| PING = "$ping"ms ------------------------------------------------------|" #display ping
	echo "                                                                     "
fi
echo "                                                                     "
while [ $ping -ge $ping_cap ] || [ -z "$ping" ]
do
	if [ -n "$ping" ]
	then
		echo "try "$count
		echo "---->"
		echo "ppp config ppp0 down" | plink -ssh  admin@192.168.1.1 -pw $pass #disconnect wan
		sleep $reset_delay
		echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
		sleep $connection_delay
		echo "calculating ping...."
		ping=$(ping -n $ping_count $ip | tail -1 | awk '{print $9}' | rev | cut -c3- | rev) #ping calc
		echo "                                                                     "
		echo "| PING = "$ping"ms ---------------------------------------------------|" #display ping
		echo "                                                                     "
		count=$(($count+1)) #update count
		sleep 2
	else
		echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
		sleep $connection_delay
		echo "calculating ping...."
		ping=$(ping -n $ping_count $ip | tail -1 | awk '{print $9}' | rev | cut -c3- | rev) #ping calc
		echo "                                                                     "
		echo "| PING = "$ping"ms ---------------------------------------------------|" #display ping
		echo "                                                                     "
	fi
done
pass="NONE" #reset pass
#for ext IP
ipext=$(wget http://ipinfo.io/ip -qO -)
echo "external IP : "$ipext #for ext IP
echo "                                                                     "
echo "                                                                     "
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"
echo "|------------------PING OPTIMIZATION COMPLETE!!---------------------|"
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"
