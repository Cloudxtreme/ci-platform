This repository contains the code required to bootstrap a local Jenkins instance using either AWS.
It is a subset of the existing Ansible code from [ansible-jenkins-showcase](https://github.com/Azulinho/ansible-jenkins-showcase)

To use it:

1. Install vagrant (1.8), virtualbox, rake, mkmf (in ruby-dev on Debian)

1. clone this repostory

        git clone http://github.com/clusterhq/ci-platform.git
        cd ci-platform

1. clone the secrets repository:

        git clone http://github.com/clusterhq/segredos.git

1. Symlink the secrets to group_vars

        ln -s segredos/ci-platform group_vars

1. install ansible:

        pip2 install ansible==1.9.2


Note: the ansible 'vault' file is not currently used, as soon it is required, it should be moved to the secrets-repo and symlinked.

The secrets-repo above contains the YAML dictionary (group_vars/all/all.yaml) used by Ansible to configure the instance.

1. Extract the jenkins-master key pair into a .pem file. It can be found in group_vars/all/all.yaml under env.default.ssh.ssh_keys.contents. You will need to tidy it upa bit by removing the quotes and other punctuation from each line.

1. for aws, you need to export your aws environment variables (the same ones
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

