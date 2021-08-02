#!/bin/bash

APPLY=false
BYPASS_INPUT=false

while getopts e:a:b:c:s:k: option; do
  case "${option}" in
    # Environment to execute against (prod or non-prod)
    e) ENV=$OPTARG;;
    # Run apply step? (true or false)
    a) APPLY=$OPTARG;;
    # Bypass input when running in CI
    b) BYPASS_INPUT=$OPTARG;;
    h) printf "Usage: %s: -e ENV [ -a APPLY ] [ -b BYPASS_INPUT ]" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

if [[ ${ENV} != @(prod|non-prod) ]]; then
  echo "Error: Pass a valid environment (prod or non-prod)";
  exit 1;
fi

if [[ ${APPLY} != @(true|false) ]]; then
  echo "Error: Pass a valid apply flag (true or false)";
  exit 1;
fi

commentMatch="#{$ENV}"
tfVarFile=$([ ${ENV} == "prod" ] && echo ":{tfvars-name-np}:.tfvars" || echo ":{tfvars-name-prod}:.tfvars")

cd infrastructure

homeDir=$(pwd)
echo "Home directory: $homeDir"
dirs=":{terraform-directories}:"

for directory in $dirs; do
  cd "$homeDir/$directory"
  echo; echo "**************** $([ "${APPLY,,}" == "true" ] && echo "Applying" || echo "Planning") $directory ****************"

  # Remove Terraform config directory (only here for local dev purposes)
  rm -r .terraform

  # Remove comments for Terraform backend config
  sed -i "s/\(${commentMatch}\) \(.\+\)/\2 \1/" ./versions.tf

  ### Begin Terraforming
  bypass=$([ "${BYPASS_INPUT,,}" == "true" ] && echo -input=false || echo "")

  terraform init $bypass
  tfInitCode=$(echo $?)

  terraform plan -var-file=../$tfVarFile -out=tfplan -detailed-exitcode $bypass
  tfPlanCode=$(echo $?)

  tfApplyCode=0

  if [[ "${APPLY,,}" == "true" ]]; then
    terraform apply $bypass tfplan
    tfApplyCode=$(echo $?)
  fi
  ### End Terraforming

  # Restore comments for Terraform backend config
  sed -i "s/\(.\+\) \(${commentMatch}\)/\2 \1/" ./versions.tf

  # Checking for 1 explicitly because TF will return 2 if it detects changes
  if [[ $tfInitCode == 1 || $tfPlanCode == 1 || $tfApplyCode == 1 ]]; then
    exit 1;
  fi
done

echo "Done!"