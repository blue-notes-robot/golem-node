#!/bin/bash
script_full_path=$(dirname "$0")
sum=0
for container in `docker ps --filter "name=node" -q`;
do
    # FYI not breaking the long  after python, as I had issues with my shell after that..
    number=$(docker exec -it $container yagna activity status --json \
    | python "$script_full_path"/get_processed_last_hr.py)
    sum=$((sum + number))
done
echo -n $sum
