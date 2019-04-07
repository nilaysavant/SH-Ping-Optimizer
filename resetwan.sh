#!/bin/bash
reset_delay=1
echo "|-------------------------------------------------------------------|"
echo "|___________________________RESET WAN__________________________|" #start
echo "|-------------------------------------------------------------------|"
echo "                                                                     "
echo "By Nilay Savant"
echo "                                                                     "
read -p "enter password for ssh: " -s pass #read pass
echo "                                                                     "
echo "ppp config ppp0 down" | plink -ssh  admin@192.168.1.1 -pw $pass #disconnect wan
sleep $reset_delay
echo "ppp config ppp0 down" | plink -ssh  admin@192.168.1.1 -pw $pass #disconnect wan
sleep $reset_delay
echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
sleep $reset_delay
echo "ppp config ppp0 up" | plink -ssh  admin@192.168.1.1 -pw $pass #reconnect wan
pass="NONE" #reset pass
echo "                                                                     "
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"
echo "|------------------WAN RESET COMPLETE !-----------------------------|"
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"


