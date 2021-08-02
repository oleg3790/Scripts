#!/bin/bash

BRANCH=${1-$(git rev-parse --abbrev-ref HEAD)}
COMMIT_HASH=${2-$(git rev-parse --short HEAD)}

while getopts b:c: option; do
  case "${option}" in
    # Branch name (optional)
    b) BRANCH=$OPTARG;;
    # Commit hash (optional)
    c) COMMIT_HASH=$OPTARG;;
    h) printf "Usage: %s: [ -b BRANCH -c COMMIT_HASH ]" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

echo "${BRANCH}-${COMMIT_HASH}"