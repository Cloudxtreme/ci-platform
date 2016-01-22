This repository contains the code required to bootstrap a local Jenkins instance using either AWS.
It is a subset of the existing Ansible code from [ansible-jenkins-showcase](https://github.com/Azulinho/ansible-jenkins-showcase)

To use it:

0. Install vagrant, rake, mkmf

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

5. for aws, you need to export your aws environment variables (the same ones
   used by the CI-slave-images project):

    * AWS_KEY_PAIR (the KEY_PAIR to use)
    * AWS_KEY_FILENAME (the full path to your .pem file)
    * AWS_SECRET_ACCESS_KEY
    * AWS_ACCESS_KEY_ID

Note that your ssh key referred to by AWS_KEY_FILENAME can't have a passphrase set.

6. Then simply run:

        rake default

    The first run, takes around 40 minutes, following runs around 9 minutes

and connect to [http://jenkins:8080](http://jenkins:8080)

you should see a fully deployed, configured jenkins ready to bootstrap EC2 slaves.

