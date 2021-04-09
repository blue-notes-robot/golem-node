#!/bin/bash
for container in $(docker ps --filter "name=node" -q);
do
    docker inspect --format='{{.Name}}' $container;
    docker exec -it $container golemsp status \
    | grep "total processed";
done
