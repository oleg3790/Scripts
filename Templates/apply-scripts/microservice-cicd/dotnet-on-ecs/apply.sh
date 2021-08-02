#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --azp_app_pool_prod)
      azp_app_pool_prod="$2"
      ;;
    --azp_app_pool_non_prod)
      azp_app_pool_non_prod="$2"
      ;;
    --ecr_name)
      ecr_name="$3"
      ;;
    --terraform_directories)
      terraform_directories="$4"
      ;;
    --tfvars_name_np)
      tfvars_name_np="$5"
      ;;
    --tfvars_name_prod)
      tfvars_name_prod="$6"
      ;;
    --out_dir)
      out_dir="$2"
      ;;
    *)
      printf "Invalid argument"
      exit 1
  esac
  shift
  shift
done

cd ../../../microservice-cicd/dotnet-on-ecs

mkdir "$out_dir/cicd"

## Variables
azp_app_pool_non_prod_token=":{azp-app-pool-np}:"
azp_app_pool_prod_token= ":{azp-app-pool-prod}:"
ecr_name_token=":{ecr-name}:"
terraform_directories_token=":{terraform-directories}:"
tfvars_name_np_token=":{tfvars-name-np}:"
tfvars_name_prod_token=":{tfvars-name-prod}:"

## Apply
files="azurepipelines.yml cicd/build-image.sh cicd/ecs-refresh.sh cicd/generate-tag.sh cicd/infrastrucutre-apply.sh cicd/push-image.sh deployment/revert.sh"

for file in $files
do
  sed "s/$azp_app_pool_non_prod_token/$azp_app_pool_non_prod/" $file > "$out_dir/$file"
  sed -i "s/$azp_app_pool_prod_token/$azp_app_pool_prod/" "$out_dir/$file"
  sed -i "s/$ecr_name_token/$ecr_name/" "$out_dir/$file"
  sed -i "s/$terraform_directories_token/$terraform_directories/" "$out_dir/$file"
  sed -i "s/$tfvars_name_np_token/$tfvars_name_np/" "$out_dir/$file"
  sed -i "s/$tfvars_name_prod_token/$tfvars_name_prod/" "$out_dir/$file"

  # Add git file permissions (will fail if the files were not added to a git dir location)
  if [[ "$file" == "cicd/build-image.sh"
        || "$file" == "cicd/ecs-refresh.sh"
        || "$file" == "cicd/generate-tag.sh "
        || "$file" == "cicd/infrastrucutre-apply.sh"
        || "$file" == "cicd/push-image.sh"
     ]]; then
    echo "Updating git file permissions for $file"
    cd $out_dir
    git add $file
    git update-index --chmod=+x $file
  fi
done

echo "Done!"
