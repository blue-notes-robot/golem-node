#!/bin/bash
sum=0
for container in `docker ps --filter "name=node" -q`;
do
    # FYI not breaking the long  after python, as I had issues with my shell after that..
    number=$(docker exec -it $container yagna activity status --json \
    | python -c \
    'import json,sys; obj=json.load(sys.stdin); last = obj.get("last1h",{}).get("Terminated"); print(last) if last is not None else print(0);')
    sum=$((sum + number))
done
echo -n $sum
