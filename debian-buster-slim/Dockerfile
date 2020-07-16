FROM debian:10.3-slim

LABEL maintainer "GLOBIS"

RUN mkdir /tmp/ssm

WORKDIR /tmp/ssm

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps curl wget tar zip unzip sudo mariadb-client vim screen less iputils-ping redis-tools && \
    # AWS CLI v2
    wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O awscliv2.zip --no-check-certificate && \
    unzip awscliv2.zip && \
    ./aws/install && \
    # ssm-agent
    wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb --no-check-certificate && \
    dpkg -i amazon-ssm-agent.deb && \
    rm -r awscliv2.zip ./aws amazon-ssm-agent.deb && \
    # jq
    wget https://stedolan.github.io/jq/download/linux64/jq -O /usr/bin/jq --no-check-certificate && \
    chmod +x /usr/bin/jq

COPY ssm-agent.sh /usr/local/bin/ssm-agent.sh
RUN chmod +x /usr/local/bin/ssm-agent.sh

ENV AWS_DEFAULT_REGION ap-northeast-1

WORKDIR /opt/amazon/ssm/
CMD ["/usr/local/bin/ssm-agent.sh"]
