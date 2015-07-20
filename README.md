This repository contains the code required to bootstrap a local Jenkins instance using either Virtualbox, LXC, Linode, or AWS.
It is a subset of the existing Ansible code from [ansible-jenkins-showcase](https://github.com/Azulinho/ansible-jenkins-showcase)

To use it:

1. clone this repostory
2. clone the secrets repository:
    - git clone <secrets-repo> secrets
3. ln -s group_vars secrets/ci-platform
4. install ansible:
    - pip2 install ansible==1.6.2

Note: the ansible 'vault' file is not currently used, as soon it is required, it should be moved to the secrets-repo and symlinked.

The secrets-repo above contains the YAML dictionary (group_vars/all.yaml) used by Ansible to configure the instance.

Simply run:

    rake

and then connect to [http://jenkins:8080](http://jenkins:8080)

you should see a fully deployed, configured jenkins ready to bootstrap EC2 slaves.


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
