#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
    --bundle_name)
      bundle_name="$2"
      ;;
    --non_prod_s3_bucket)
      non_prod_s3_bucket="$2"
      ;;
    --prod_s3_bucket)
      prod_s3_bucket="$2"
      ;;
    --s3_app_directory)
      s3_app_directory="$2"
      ;;
    --web_component_name)
      web_component_name="$2"
      ;;
    --azp_app_pool_ci)
      azp_app_pool_ci="$2"
      ;;
    --azp_app_pool_prod)
      azp_app_pool_prod="$2"
      ;;
    --azp_app_pool_non_prod)
      azp_app_pool_non_prod="$2"
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

cd ../../../micro-frontend-cicd/direflow-app

mkdir "$out_dir/cicd"

## Variables
bundle_token=":{bundle}:"
non_prod_s3_bucket_token=":{non-prod-s3-bucket}:"
prod_s3_bucket_token=":{prod-s3-bucket}:"
s3_app_directory_token=":{s3-app-directory}:"
web_component_name_token=":{web-component-name}:"
azp_app_pool_ci_token=":{azp-app-pool-ci}:"
azp_app_pool_prod_token=":{azp-app-pool-prod}:"
azp_app_pool_np_token=":{azp-app-pool-np}:"

## Apply
files="azurepipelines.yml cicd/build.sh cicd/deploy.sh"

for file in $files
do
  sed "s/$bundle_token/$bundle_name/" $file > "$out_dir/$file"
  sed -i "s/$non_prod_s3_bucket_token/$non_prod_s3_bucket/" "$out_dir/$file"
  sed -i "s/$prod_s3_bucket_token/$prod_s3_bucket/" "$out_dir/$file"
  sed -i "s/$s3_app_directory_token/$s3_app_directory/" "$out_dir/$file"
  sed -i "s/$web_component_name_token/$web_component_name/" "$out_dir/$file"
  sed -i "s/$azp_app_pool_ci_token/$azp_app_pool_ci/" "$out_dir/$file"
  sed -i "s/$azp_app_pool_prod_token/$azp_app_pool_prod/" "$out_dir/$file"
  sed -i "s/$azp_app_pool_np_token/$azp_app_pool_non_prod/" "$out_dir/$file"

  # Add git file permissions (will fail if the files were not added to a git dir location)
  if [[ "$file" == "cicd/build.sh" || "$file" == "cicd/deploy.sh" ]]; then
    echo "Updating git file permissions for $file"
    cd $out_dir
    git add $file
    git update-index --chmod=+x $file
  fi
done

echo "Done!"
