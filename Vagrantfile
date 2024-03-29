# vi: set ft=ruby :
#

VAGRANTFILE_API_VERSION = '2'

def exit_with_message(message)
  puts(message)
  exit 1
end

# Check that all the required environment variables have been set
ENV['AWS_ACCESS_KEY_ID'] ? true : exit_with_message('AWS_ACCESS_KEY_ID not set')
ENV['AWS_SECRET_ACCESS_KEY'] ? true : exit_with_message('AWS_SECRET_ACCESS_KEY not set')
ENV['AWS_KEY_PAIR'] ? true : exit_with_message('AWS_KEY_PAIR not set')
ENV['AWS_KEY_FILENAME'] ? true : exit_with_message('AWS_KEY_FILENAME not set')

boxes = [
  {
    :name => :jenkins,
    :book => 'jenkins',
  },
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.hostmanager.enabled      = true
  config.hostmanager.include_offline  = true
  config.hostmanager.manage_host   = true
  config.hostmanager.ignore_private_ip = true
  config.vm.provision :hostmanager
  config.ssh.insert_key = false
  config.ssh.pty = true

   # tho use this install polipo on your laptop
   if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.enabled = false
    end

  #config.ssh.insert_key = false
  #
  boxes.each do |opts|
    config.vm.define opts[:name] do |machine|

      machine.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
        aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        aws.keypair_name = ENV['AWS_KEY_PAIR']
        aws.security_groups = ['ssh', 'http', 'jenkins-master', 'high-ports']
        aws.ami = "ami-1255b321"
        aws.region = "us-west-2"
        aws.instance_type = "t2.large"
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1',
                                      'Ebs.VolumeSize' => 32,
                                      'Ebs.DeleteOnTermination' => true}]
        aws.tags = {
          'name' => 'jenkins-master-vagrant',
          'owner' => ENV['USER']
        }

        override.ssh.private_key_path = ENV['AWS_KEY_FILENAME']
        machine.vm.box = "#{opts[:name].to_s}-aws"
        override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
        override.ssh.username = 'centos'
        machine.ssh.username = 'centos'
        machine.ssh.private_key_path = ENV['AWS_KEY_FILENAME']
      end

      config.vm.synced_folder ".", "/vagrant", disabled: true

      config.vm.provision "shell",
        inline: "yum install -y libselinux-python"

      config.vm.provision "shell",
        inline: "sed -i s/^Defaults.*requiretty/#Defaultrequiretty/ /etc/sudoers"

      config.vm.provision :ansible do |ansible|
        if defined? ENV['TAGS']
          ansible.tags = ENV['TAGS']
        end
        if defined? ENV['START_AT_TASK']
          ansible.start_at_task = ENV['START_AT_TASK']
        end

        #ansible.verbose = 'vvv'
        ansible.sudo = true
        ansible.playbook = "vagrant-#{opts[:book]}.yml"
        ansible.inventory_path= 'vagrant'
        ansible.vault_password_file = 'vagrant-vault'
        ansible.limit = opts[:name].to_s

        ansible.extra_vars = {
          'deploy_environment'    => 'vagrant',
        }
      end

      config.vm.provision "shell",
        inline: "echo \"VM IP ADDRESS: $(curl http://169.254.169.254/latest/meta-data/public-ipv4)\""
    end
  end
end
# -*- mode: ruby -*-
