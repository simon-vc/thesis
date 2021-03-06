#Default values
#Amount of containers
N=1
#Image name for the docker container
IMAGE="simonvancauter/vfclient"

#Read arguments
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -n|--number)
    N="$2"
	if [[ $2 -lt 1 ]]
	then
		echo "Amount of containers must be larger than 0"
		echo "Using default: 1"
		N=1
	fi
    shift
    ;;
    -i|--image)
    IMAGE="$2"
    shift
    ;;
    *)
		echo "Argument not recognized"
		# unknown option
    ;;
esac
shift
done


echo "Starting Docker containers"
echo "Amount: $N"
echo "===================================="

SECONDS=0
for ((i=1 ; i<=$N ; i++))
do
        echo "Creating container$i"
        docker create -v /etc/localtime:/etc/localtime:ro --name client$i $IMAGE /bin/bash -c "cd client/ ; export LD_LIBRARY_PATH=bin:/usr/lib ; ./client client_config.ini >/var/www/html/log_client/terminallog.txt"
	docker cp ./client_config.ini client$i:client/
done
echo "===================================="
echo "Creating containers: $SECONDS elapsed"
