This repository contains the code required to bootstrap a local Jenkins instance using either Virtualbox, LXC, Linode, or AWS.
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

        rake

and connect to [http://jenkins:8080](http://jenkins:8080)

you should see a fully deployed, configured jenkins ready to bootstrap EC2 slaves.


The upstream mirrors for Jenkins are not very fast, and tend to timeout quite often,
we try to reduce that issue a bit by deploying a local caching proxy polipo VM which jenkins will consume.


Some limited support available for linode, LXC and AWS, simply use:

    rake default [linode|lxc|aws]

My lxc conf looks like:

    \>cat /etc/lxc/default.conf
    lxc.network.type = veth
    lxc.network.link = lxcbr0
    lxc.network.flags = up
    lxc.network.hwaddr = 00:16:3e:xx:xx:xx
    lxc.autodev = true

and my dnsmasq file:

    \>cat /etc/dnsmasq-lxcbr0.conf
    interface=lxcbr0
    except-interface=lo
    bind-interfaces

    domain=lxc
    dhcp-range=10.0.3.2,10.0.3.100,12h

    host-record=lxchost.lxc,10.0.3.1
    local=/lxc/

for linode, you need to export your linode key:

    export linode_key="XXXXXXXX"

for aws, you need to export your aws environment variables.

export AWS_ACCESS_KEY_ID
export AWS_SECRET_KEY
export AWS_KEYPAIR_NAME
export AWS_KEYPAIR_FILEPATH
