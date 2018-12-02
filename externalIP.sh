#!/bin/bash

NordVPN () {

echo -e "\033[33m=========================================================\x1B[0m"
echo -e "\033[34m*** NordVPN External IP Verification ***\x1B[0m"
echo -e "\033[33m=========================================================\x1B[0m"
echo -e "\033[36mStep 1: Requesting External IP Address\x1B[0m"
GET_ExternalIP=$(wget -qO - https://api.ipify.org)
sleep 5
	if [ -z "GET_ExternalIP" ]
		then
			GET_ExternalIP=$(curl -s https://api.ipify.org)
			sleep 5
		elif [ -z "GET_ExternalIP" ]
			then
				echo "External IP Address NOT Found"	
			exit 1
		else
			
			echo -e "\033[36mStep 2: Requesting IP Address Geolocation\x1B[0m"
			GET_Geolocation=$(geoiplookup $GET_ExternalIP | sed -e '/GeoIP City/ { N; d; }' | head -1)

			echo -e "\033[36mStep 3: Requesting Host Information\x1B[0m"
			GET_HOST=$(host $GET_ExternalIP)

			echo -e "\033[36mStep 4: Check for VPN Tunnel Connection on tun0\x1B[0m"
			ifconfig | grep -i "tun0" > /dev/null
				if [ $? -eq 0 ]; then
					GET_VPN="VPN Status: \033[42mConnected\x1B[0m"
				else
					GET_VPN="VPN Status: \033[41mNOT Connected\x1B[0m"
				fi
			
			
			echo -e "\033[36mStep 5: Requesting OpenVPN PID Status\x1B[0m"
			pgrep openvpn > /dev/null
			if [ $? -eq 0 ]; then
				GET_OpenVPN="OpenVPN Status:  \033[42mRunning\x1B[0m"
			else
				GET_OpenVPN="OpenVPN Status: \033[41mNOT Running\x1B[0m"
			fi

				echo -e "\033[33m=========================================================\x1B[0m"
				echo -e "\033[35mBy: Edson Freire\x1B[0m" 
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"
				echo -e "\033[36m*** Your IP Address ***\x1B[0m"
				echo $GET_ExternalIP
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"
				echo -e "\033[36m*** IP Address Geolocation ***\x1B[0m" 
				echo $GET_Geolocation
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"
				echo -e "\033[36m*** HOST Information ***\x1B[0m" 
				echo $GET_HOST
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"
				echo -e "\033[36m*** Is VPN Connected? ***\x1B[0m" 
				echo -e $GET_VPN
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"
				echo -e "\033[36m*** Is OpenVPN Running? ***\x1B[0m" 
				echo -e $GET_OpenVPN
				echo -e "\033[33m---------------------------------------------------------\x1B[0m"

	fi
}

#Redefine tamanho do terminal
echo -ne '\e[8;27;59t'

export -f NordVPN
watch --color --no-title -n 10 -x bash -c "NordVPN"
