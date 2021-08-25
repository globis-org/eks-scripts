#!/bin/bash

if [ -z "${BASTION_ROLE_NAME}" ] || [ -z "${BASTION_INSTANCE_NAME}" ]; then
    echo "ERROR: Some variables are not found. Please set BASTION_ROLE_NAME and BASTION_INSTANCE_NAME." >&2
    exit 1
fi

function activate(){
    echo "start activate process ..."
    activation=$(aws ssm create-activation --default-instance-name "${BASTION_INSTANCE_NAME}" --iam-role "${BASTION_ROLE_NAME}" --output text)
    SSM_AGENT_CODE=$(echo $activation | cut -f 1 -d ' ')
    SSM_AGENT_ID=$(echo $activation | cut -f 2 -d ' ')
}

function shutdown(){
    echo "start shutdown process ..."
    instance_id=$(cat /var/lib/amazon/ssm/registration | jq -r .ManagedInstanceID)
    aws ssm deregister-managed-instance --instance-id $instance_id
    kill $(pgrep amazon-ssm)
    echo "shutdown process completed."
}

function start(){
    amazon-ssm-agent -register -code "${SSM_AGENT_CODE}" -id "${SSM_AGENT_ID}" -region "ap-northeast-1"
    aws ssm delete-activation --activation-id "${SSM_AGENT_ID}"
    amazon-ssm-agent start &
    echo "activate process completed. ssm-agent has started."
}

## main process

trap shutdown TERM
activate
start

while true
do
    wait
done
