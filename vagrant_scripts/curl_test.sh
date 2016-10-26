echo "Press [CTRL+C] to stop.."
while :
do
	echo "curl api.immutability.org:9999/hello"
  curl api.immutability.org:9999/hello
	sleep 1
done
