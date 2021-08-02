AWS_PROFILE=${1}

while getopts c:p: option; do
  case "${option}" in
    # ECS cluster name
    c) CLUSTER_NAME=$OPTARG;;
    # AWS profile (optional)
    p) AWS_PROFILE=$OPTARG;;
    h) printf "Usage: %s: -c CLUSTER_NAME [ -p AWS_PROFILE ]" $0
       exit 0;;
    ?) echo "Invalid argument, use -h for help"
       exit 2;;
    esac
done

for var in CLUSTER_NAME; do
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

SERVICE=$(aws ecs list-services --cluster $CLUSTER_NAME --max-items 1 --query serviceArns[0] --output text $profile | sed 's/^.\+\///')

echo "Service to refresh $SERVICE"

aws ecs update-service --force-new-deployment --service $SERVICE --cluster $CLUSTER_NAME $profile