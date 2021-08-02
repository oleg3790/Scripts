#!/bin/bash

while getopts n:t: option; do
  case "${option}" in
    # Image name
    n) NAME=$OPTARG;;
    # Image tag
    t) TAG=$OPTARG;;
    h) printf "Usage: %s: -n NAME -t TAG" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

for var in NAME TAG; do
  if [[ -z "${!var:-}" ]]; then
    echo "Error: Missing required argument $var";
    exit 1;
  fi
done

docker build -t $NAME:$TAG ./src