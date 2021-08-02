#!/bin/bash

while getopts b:c:s: option; do
  case "${option}" in
    b) BUCKET=${OPTARG};;
    c) CDN_ORIGIN=$OPTARG;;
    s) SPA_NAME=$OPTARG;;
    esac
done

# Upload build artifacts
aws s3 sync ./:{web-component-name}:/build s3://${BUCKET}/${SPA_NAME} --cache-control no-cache

# Pull CDN by Name
cdn=$(aws cloudfront list-distributions --query "DistributionList.Items[].{Id: Id, DomainName: DomainName, OriginDomainName: Origins.Items[0].DomainName}[?contains(OriginDomainName, '$CDN_ORIGIN')] | [0]" | jq -r .Id)

# Invalidate CDN for App
aws cloudfront create-invalidation --distribution-id $cdn --paths "/$SPA_NAME/*"
