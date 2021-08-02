#!/bin/bash

while getopts n:d:p: option; do
  case "${option}" in
    # Repo name
    n) NAME=$OPTARG;;
    # Digest of image to revert to
    d) DIGEST=$OPTARG;;
    # AWS profile (support for running locally)
    p) AWS_PROFILE=$OPTARG;;
    h) printf "Usage: %s: -n NAME -d DIGEST" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

for var in NAME DIGEST; do
  if [[ -z "${!var:-}" ]]; then
    echo "Error: Missing required argument $var";
    exit 1;
  fi
done

profile=""

if [ ! -z "$AWS_PROFILE" ]; then
  profile="--profile $AWS_PROFILE"
  echo "profile set to $AWS_PROFILE"
fi

manifest=$(aws ecr batch-get-image --repository-name $NAME --image-ids imageDigest=$DIGEST --query 'images[].imageManifest' --output text $profile)
aws ecr put-image --repository-name $NAME --image-tag latest --image-manifest "$manifest" $profile

./cicd/ecs-refresh.sh $AWS_PROFILE