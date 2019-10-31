#! /bin/bash

echo -e "\nProvisioning SWARM worker"

TOKEN=`cat /vagrant/token.txt`

echo $TOKEN

if [ "$(docker info | grep Swarm | sed 's/Swarm: //g')" == "inactive" ]; then
    echo false;
    docker swarm join --token $TOKEN swarm-manager:2377
else
    echo true;
    echo "This node is already part of a swarm"
fi


