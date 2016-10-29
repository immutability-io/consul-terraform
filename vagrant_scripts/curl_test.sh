echo "Press [CTRL+C] to stop.."
while :
do
	echo "curl `echo $1`/hello"
  curl $1/hello
	sleep 1
done
