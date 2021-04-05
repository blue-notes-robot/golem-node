#!/bin/bash
while true;
do
    echo -n `date +"[%F %H:%M:%S]"`;
    echo " Nodes active: $(pgrep vmrt | wc -l)";
    sleep 60;
done
