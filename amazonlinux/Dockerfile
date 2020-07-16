FROM amazonlinux:2

LABEL maintainer "GLOBIS"

RUN yum update -y && \
    yum install -y systemd procps curl tar zip unzip sudo mariadb vim screen less iputils && \
    # ssm-agent
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm && \
    # AWS CLI
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -r awscliv2.zip ./aws && \
    # jq
    curl https://stedolan.github.io/jq/download/linux64/jq > /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    # redis
    amazon-linux-extras install redis4.0

COPY ssm-agent.sh /usr/local/bin/ssm-agent.sh
RUN chmod +x /usr/local/bin/ssm-agent.sh

ENV AWS_DEFAULT_REGION ap-northeast-1

WORKDIR /opt/amazon/ssm/
CMD ["/usr/local/bin/ssm-agent.sh"]
