Templates and apply scripts used to generate various project resources (CI/CD pipelines, etc)

## Templates

### Direflow (Web Component) app with Azure DevOps CI/CD pipeline
This will generate build/deploy scripts that are wired up to a `yaml` file for a CI/CD pipeline in Azure DevOps

To generate the resources, your target project needs to be on your local machine as you will need to pass the target directory to the apply script.

#### Required Arguments

- `--bundle_name`: Name of the bundle file generate by the Direflow webpack config
- `--non_prod_s3_bucket`: Non production AWS S3 bucket to deploy to
- `--prod_s3_bucket`: Production AWS S3 bucket to deploy to
- `--s3_app_directory`: S3 directory where the bundle will be deployed to
- `--web_component_name`: Name of the Direflow web component
- `--azp_app_pool_ci`: Azure DevOps pool where continuous integration will execute
- `--azp_app_pool_prod`: Azure DevOps production pool
- `--azp_app_pool_non_prod`: Azure DevOps non production pool
- `--out_dir`: Absolute path to the target directory where to generate resources

#### Apply Sample
```bash
cd apply-scripts/micro-frontend-cicd/direflow-app

./apply.sh \
--bundle_name mybundle.js \
--non_prod_s3_bucket ui-myawsaccount \
--prod_s3_bucket ui-myawsaccount-np \
--s3_app_directory app-dir \
--web_component_name mycoolapp-component \
--azp_app_pool_ci default \
--azp_app_pool_prod default \
--azp_app_pool_non_prod default \
--out_dir '/c/my-dev-projects/mycoolapp'
```

### Direflow (Web Component) app with Azure DevOps CI/CD pipeline
This will generate all scripts necessary to build and deploy a micro-service hosted via AWS ECS. CI/CD pipeline uses Azure DevOps

To generate the resources, your target project needs to be on your local machine as you will need to pass the target directory to the apply script.

#### Required Arguments

- `--azp_app_pool_prod`: Azure DevOps production pool
- `--azp_app_pool_non_prod`: Azure DevOps non production pool
- `--ecr_name`: Name of the Elastic Container Registry where you publish the container image
- `--terraform_directories`: All directories to for which Terraform should be ran against
- `--tfvars_name_np`: Non prod tfvars file to use
- `--tfvars_name_prod`: Prod tfvars file to use
- `--out_dir`: Absolute path to the target directory where to generate resources

#### Apply Sample
```bash
cd apply-scripts/micro-frontend-cicd/direflow-app

./apply.sh \
--azp_app_pool_prod default \
--azp_app_pool_non_prod default \
--ecr_name mycoolapp \
--terraform_directories 'database ecr common instance' \
--tfvars_name_np production \
--tfvars_name_prod nonproduction \
--out_dir '/c/my-dev-projects/mycoolapp'
```

## Gotchas

#### Granting script execute permissions
The apply script already does this for you but if you run any of the scripts found here and get a `Permission denied` error, you might need to add execute permissions to the files in git:

```bash
git update-index chmod=+x <file>
```

 You can verify the executable bit for a file using
 ```bash
git ls-files -s
 ```