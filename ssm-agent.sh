#!/bin/bash

role_name="ssm-bastion-activation"
default_instance_name="ssm-bastion"

# get AWS API tokens through IRSA
# see: https://aws.amazon.com/jp/blogs/news/introducing-fine-grained-iam-roles-service-accounts/
function get_token(){
    aws sts assume-role-with-web-identity --role-arn $AWS_ROLE_ARN --role-session-name ssm-bastion --web-identity-token file://$AWS_WEB_IDENTITY_TOKEN_FILE --duration-seconds 43200 > /tmp/irp-cred.txt
    export AWS_ACCESS_KEY_ID="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.AccessKeyId")"
    export AWS_SECRET_ACCESS_KEY="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SecretAccessKey")"
    export AWS_SESSION_TOKEN="$(cat /tmp/irp-cred.txt | jq -r ".Credentials.SessionToken")"
    rm /tmp/irp-cred.txt
}

function activate(){
    echo "start activate process ..."
    expire=$(date -d "10 days" +%Y-%m-%d)
    aws iam get-role --role-name $role_name > /dev/null  2>&1
    if [[ $? -ne 0 ]]; then
        echo "ERROR: IAM role $role_name not found."
        exit 1
    fi
    activation=$(aws ssm create-activation --default-instance-name $default_instance_name --iam-role $role_name --expiration-date $expire --output text)
    SSM_AGENT_CODE=$(echo $activation | cut -f 1 -d ' ')
    SSM_AGENT_ID=$(echo $activation | cut -f 2 -d ' ')
    echo $SSM_AGENT_ID > /var/run/ssm-agent.id
}

function deactivate(){
    echo "start shutdown process ..."
    kill $(pgrep amazon-ssm)
    id=$(cat /var/run/ssm-agent.id)
    echo "delete activation $id"
    aws ssm delete-activation --activation-id $id
    echo "shutdown process completed."
}

function start(){
    amazon-ssm-agent -register -code "${SSM_AGENT_CODE}" -id "${SSM_AGENT_ID}" -region "ap-northeast-1"
    amazon-ssm-agent start &
    echo "activate process completed. ssm-agent has started."
}

## main process

trap deactivate TERM
get_token
activate
start

while true
do
    wait
done
