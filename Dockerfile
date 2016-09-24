FROM ubuntu:16.04

RUN apt-get update; \
    apt-get install -y --no-install-recommends curl unzip openssh-client python-pip python-setuptools python-wheel python-paramiko; \
    rm -rf /var/lib/apt/lists/*

RUN curl https://releases.hashicorp.com/terraform/0.7.4/terraform_0.7.4_linux_amd64.zip -o /tmp/terraform.zip \
 && unzip /tmp/terraform.zip -d /usr/local/bin/ \
 && rm /tmp/terraform.zip

RUN pip install ansible
