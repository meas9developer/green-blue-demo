#!/usr/bin/env bash
set -xe

lambda_name=Lambda
version=`aws lambda publish-version --function-name $lambda_name --query Version  --output text`
alias="PROD"

if [ -z "$AWS_DEFAULT_REGION" ]; then
    aws_region="us-west-2"
else
    aws_region=$AWS_DEFAULT_REGION
fi


# Update existing alias to point to the Lambda version
echo "Updating alias $alias for Lambda fn $lambda_name"
aws lambda update-alias --function-name $lambda_name --name $alias --function-version $version --region $aws_region
