#! /bin/bash

#We got the information to run the command ping and save this information in ping.tmp, 
#$1 should be how many pings the command is gonna send, $2 IP address to PING
ping -c $1 $2 > ping.tmp

#If condition which evaluate how many columns the ping has, there are some cases when ping add an extra column with the host
awk -f ms.awk ./ping.tmp > ms_ping.tmp

#Filtering the lines which have icmp in its string and save only the 8th column in icmp_ping.tmp
awk '/time=/ {print $1}' ./ms_ping.tmp > icmp_ping.tmp

#substitution of <time=> with nothing to get only time values and work easily with them, save these values in time_ping.tmp
awk 'gsub(/time=/,"")' ./icmp_ping.tmp > values_ping.tmp

#Transpose the results to do an easier process
awk '{printf "%s" (NR==0?RS:FS),$1}' ./values_ping.tmp > time_ping.tmp

#Print the header
echo -e '\n'
echo -e Ping statistics for $2 '\n' 

#Executed the file time_ping.awk to compute the statistics of the ping
awk -f ./time_ping.awk ./time_ping.tmp

#Remove all temporal files created before
rm icmp_ping.tmp time_ping.tmp ms_ping.tmp values_ping.tmp
