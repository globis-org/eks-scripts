#!/bin/bash

if [ -z "${BASTION_ROLE_NAME}" ] || [ -z "${BASTION_INSTANCE_NAME}" ]; then
    echo "[ERROR] Some variables are not found. Please set BASTION_ROLE_NAME and BASTION_INSTANCE_NAME." >&2
    exit 1
fi

function activate() {
    echo "[INFO] start activate process ..."
    local activation=$(aws ssm create-activation --default-instance-name "${BASTION_INSTANCE_NAME}" --iam-role "${BASTION_ROLE_NAME}" --output text)
    local activation_code=$(echo "$activation" | cut -f 1 -d ' ')
    local activation_id=$(echo "$activation" | cut -f 2 -d ' ')
    amazon-ssm-agent -register -code "$activation_code" -id "$activation_id" -region "ap-northeast-1"
    aws ssm delete-activation --activation-id "$activation_id"
    echo "[INFO] activate process completed."
}

function shutdown() {
    echo "[INFO] start shutdown process ..."
    instance_id=$(cat /var/lib/amazon/ssm/registration | jq -r .ManagedInstanceID)
    aws ssm deregister-managed-instance --instance-id "$instance_id"
    kill $(pgrep amazon-ssm)
    echo "[INFO] shutdown process completed."
}

function start() {
    local product=${DD_SERVICE:none}
    local env=${DD_ENV:none}
    instance_id=$(cat /var/lib/amazon/ssm/registration | jq -r .ManagedInstanceID)
    aws ssm add-tags-to-resource --resource-type "ManagedInstance" --resource-id "$instance_id" --tags "Key=Product,Value=$product" "Key=Env,Value=$env"
    amazon-ssm-agent start &
    echo "[INFO] ssm-agent has started."
}

## main process

trap shutdown TERM
activate
start

while true
do
    wait
done
