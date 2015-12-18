This repository contains the code required to bootstrap a local Jenkins instance using either AWS.
It is a subset of the existing Ansible code from [ansible-jenkins-showcase](https://github.com/Azulinho/ansible-jenkins-showcase)

To use it:

1. clone this repostory

        git clone http://github.com/clusterhq/ci-platform.git
        cd ci-platform

2. clone the secrets repository:

        git clone http://github.com/clusterhq/segredos.git

3. Symlink the secrets to group_vars

        ln -s segredos/ci-platform group_vars

4. install ansible:

        pip2 install ansible==1.9.2


Note: the ansible 'vault' file is not currently used, as soon it is required, it should be moved to the secrets-repo and symlinked.

The secrets-repo above contains the YAML dictionary (group_vars/all.yaml) used by Ansible to configure the instance.

5. Then simply run:

        rake default aws

    The first run, takes around 40 minutes, following runs around 9 minutes

and connect to [http://jenkins:8080](http://jenkins:8080)

you should see a fully deployed, configured jenkins ready to bootstrap EC2 slaves.

for aws, you need to export your aws environment variables.

    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_KEY
    export AWS_KEYPAIR_NAME
    export AWS_KEYPAIR_FILEPATH


Updating the master jenkins box
================================

1. Download the latest vagrant state files from S3
    aws s3 sync --delete s3://clusterhq-fabric-instance-state/ci-live/.vagrant .vagrant

2. vagrant provision
