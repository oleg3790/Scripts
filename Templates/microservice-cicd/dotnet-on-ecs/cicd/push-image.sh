#!/bin/bash

while getopts t:n:p: option; do
  case "$option" in
    # Image tag
    t) TAG=$OPTARG;;
    # Image name
    n) NAME=$OPTARG;;
    p) AWS_PROFILE=$OPTARG;;
    h) printf "Usage: %s: -t TAG -n NAME [ -p AWS_PROFILE ]" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

for var in TAG NAME; do
  if [[ -z "${!var:-}" ]]; then
    echo "Error: Missing required argument $var";
    exit 1;
  fi
done

echo "Image tagged as $TAG"

profile=""

# Keeping support for pushing from local machine
if [ ! -z "$AWS_PROFILE" ]; then
  profile="--profile $AWS_PROFILE"
fi

accountId=$(aws sts get-caller-identity --query Account $profile | sed -e "s/\"//g")

echo "Account set to $([ -z $ENV ] && echo $accountId || echo $ENV)"

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $accountId.dkr.ecr.us-east-1.amazonaws.com

# Check if an image like the one built already exists, if so then no reason to push duplicate.
digests=$(docker inspect --format='{{ index .RepoDigests}}' $NAME:$TAG)

echo "Repo Digests: $digests"

if [ "$digests" == "[]" ]; then
  docker tag $NAME:$TAG $accountId.dkr.ecr.us-east-1.amazonaws.com/$NAME:$TAG
  docker tag $NAME:$TAG $accountId.dkr.ecr.us-east-1.amazonaws.com/$NAME:latest
  docker push $accountId.dkr.ecr.us-east-1.amazonaws.com/$NAME:$TAG
  docker push $accountId.dkr.ecr.us-east-1.amazonaws.com/$NAME:latest

  # Clean up all images on the build server's host. There might be a better way, but for now we do this here
  # so not to use up disk space since the build server is used for multiple projects and the EC2 instance will fill up
  # with docker images pretty quickly as deployments are triggered.
  printf "\nCleaning up host $NAME images..."
  docker images -a |  grep "$NAME" | awk '{print $3}' | xargs docker rmi --force
else
  echo "An image with this SHA already exists in the repo"
  exit 1
fi

