#!/bin/bash

while getopts e:a:b:c: option; do
  case "${option}" in
    e) EMAIL=${OPTARG};;
    a) API_KEY=$OPTARG;;
    b) BUILD_BRANCH=$OPTARG;;
    c) COMMIT_ID=$OPTARG;;
    esac
done

# Install Yarn
npm install --global yarn

# Login to Artifactory
curl -s -u $EMAIL:$API_KEY https://artifactory.coxautoinc.com/artifactory/api/npm/iss-npm-local/auth/coxkit >> ~/.npmrc
curl -s -u $EMAIL:$API_KEY https://artifactory.coxautoinc.com/artifactory/api/npm/vauto-npm-local/auth/vauto >> ~/.npmrc

# Pull Dependendencies
cd :{web-component-name}:
yarn install --production

# Build Project
yarn build

# Verify Bundle
if [ ! -s "build/:{bundle}:" ]; then
  echo "Error: Bundle was not created"
  exit 1;
fi

# Add build version
shortCommitId=$(git rev-parse --short HEAD)
version="${BUILD_BRANCH}:${shortCommitId}"
echo; echo "UI Version: $version"; echo;
sed -i "s/::build-version::/${version}/" build/:{bundle}:

# Run Tests
yarn ci-test