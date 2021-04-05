#!/bin/bash
for container in `docker ps --filter "name=node"  -q`;
do
    docker inspect --format='{{.Name}}' $container;
    docker exec -it $container top -bn 2 -d 0.5 \
    | sed -nE '/(yagna|ya-provider|vmrt)/ p' \
    | awk '{ print $9 }' \
    | awk '{ for(i=0; i<NF; i++) j+=$i; } END {print j/2}';
done
