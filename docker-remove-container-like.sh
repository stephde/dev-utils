#!/bin/bash

if [ $# -ne 1 ]; then
    echo $0: usage: pass name selector as argument
    exit 1
fi

name=$1

echo "removing all container with name like $name"

docker rm $(docker ps -a | grep $name | awk '{print $1}')
