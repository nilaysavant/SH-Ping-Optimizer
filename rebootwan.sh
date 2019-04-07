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
sleep $reset_delay
echo "reboot" | plink -ssh  admin@192.168.1.1 -pw $pass #disconnect wan

echo "                                                                     "
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"
echo "|------------------WAN RESET COMPLETE !-----------------------------|"
echo "|+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++|"


