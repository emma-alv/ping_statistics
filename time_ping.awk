#AWK code to compute statistics of ping command

#! /usr/bin/awk -f

#We declarate <min> with a random value just for easy working prouposse 
BEGIN{min=10000}

#Loop to comparate  values and  determinate the minimun time of the ping
{for (i=1; i<=NF; i++){
	if ($i>max) max=$i}}

#Loop to comparate  values and  determinate the maximun time of the ping
{for (i=1; i<=NF; i++){
	if ($i<min) min=$i}}

#Loop to compute the mean time of the ping
{for (i=1; i<=NF; i++){
	{sum+=$i}}}
	{avg=sum/NF}
#Loop to compute standar deviation basis on the range of times during the ping
{for (i=1; i<=NF; i++){
	{dif_sum[i] = ($i - avg)}
	{sq_dif[i] = dif_sum[i]^2}
	{variance_sum = sq_dif[i] + variance_sum}
	{variance = variance_sum/NF}
	}}

{std_dev=sqrt(variance)}


END {
	print "Minimun time of ping " min "\n"
	print "Average time of ping " avg "\n"
	print "Maximun time of ping " max "\n"
	print "Standar deviation "  std_dev "\n"
	}
