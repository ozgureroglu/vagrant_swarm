#! /bin/bash

echo -e "\nProvisioning SWA RM Manager"


if [ "$(docker info | grep Swarm | sed 's/Swarm: //g')" == "inactive" ]; then
    docker swarm init --advertise-addr $1

    echo -e "Creating the docker registry"
    docker service create --name registry --publish published=5000,target=5000 registry:2

else
    echo true;
    echo "This node is already part of a swarm"
fi



docker swarm join-token -q worker > /vagrant/token.txt
