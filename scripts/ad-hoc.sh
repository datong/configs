sudo ifconfig wlan0 down
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -X
sudo iwconfig wlan0 mode Ad-Hoc essid ap
sudo ifconfig wlan0 192.168.2.1 netmask 255.255.255.0 up 
sudo iwconfig wlan0 mode Ad-Hoc essid ap                
sudo iptables-restore < ~/scripts/wifi-adhoc.iptables
