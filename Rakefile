# Dictionary containing the list of vagrant plugins to install locally
vagrant_plugins = { 'ansible' => '0.2.0' ,
                    'vagrant-hostmanager' => '1.5.0',
                    'vagrant-triggers' => '0.4.3',
                    'vagrant-cachier' => '1.1.0',
                    'vagrant-lxc' => '1.0.1',
                    'vagrant-aws' => '0.6.0',
                    'vagrant-proxyconf' => '1.5.0',
                    'vagrant-linode' => '0.2.0',
                    'vagrant-hostsupdater' => '0.0.11'}

# List of ansible roles to download from Galaxy
# any local. roles are stored locally with the repository
ansible_roles = [
  'Azulinho.azulinho-google-dns',
  'local.Azulinho.azulinho-jenkins-plugins',
  'Azulinho.azulinho-yum-repo-epel',
  'Azulinho.azulinho-java-openjdk-jdk',
  'Azulinho.azulinho-yum-repo-jenkins',
  'Azulinho.azulinho-yum-plugin-versionlock',
  'Azulinho.azulinho-jenkins-reconfigure-jobs-using-jinja2',
  'local.Azulinho.azulinho-jenkins-reconfigure-jobs-using-job-dsl',
  'local.Azulinho.azulinho-jenkins-server',
  'bennojoy.ntp',
  'Azulinho.azulinho-python27',
  'Azulinho.azulinho-ssh-keys',
]

# execute 'rake', and all pre-requirements should be installed and the VM
# provisioned in one go.
task :default => ['setup', 'vagrant_up'] do
# do nothing here
end

# install all the vagrant plugins and Ansible roles from Galaxy
desc "let me sort out all the goodies you may need"
task :setup do
  plugins_installed = `vagrant plugin list`
  vagrant_plugins.each_pair do |name, version|
    # don't bother re-installing already installed plugins
    unless plugins_installed =~ /.*#{ name }.*#{version}.*/
      system("vagrant plugin install #{ name } --plugin-version #{ version }")
    end
  end
  ansible_roles.each do |role|
    # don't download already downloaded ansible roles
    unless Dir.exists?("roles/#{role}")
      system("ansible-galaxy install #{ role } -p ./roles --force ")
    end
  end
end

desc "download all the ansible roles"
task :galaxy_install do
  ansible_roles.each do |role|
    # don't download already downloaded ansible roles
    unless Dir.exists?("roles/#{role}")
      system("ansible-galaxy install #{ role } -p ./roles --force ")
    end
  end
end

# Boot the VMs, we support multiple cloud proviers here by having multiple
# Vagrantfiles, one for each provider and symlinking them just-in-time
desc "power up the vagrant boxes"
task :vagrant_up do
  ['jenkins'].each do |box|
    if File.exists?("Vagrantfile")
      File.unlink("Vagrantfile")
    end
    if ARGV.empty?
      File.symlink("Vagrantfile.vbox", "Vagrantfile")
      system("vagrant up #{ box } --no-provision")
    else
      case ARGV[1]
        when "vbox"
          File.symlink("Vagrantfile.vbox", "Vagrantfile")
          system("vagrant up #{ box } --no-provision")
        when "lxc"
          File.symlink("Vagrantfile.lxc", "Vagrantfile")
          system("vagrant up #{ box } --provider=lxc --no-provision")
        when "linode"
          File.symlink("Vagrantfile.linode", "Vagrantfile")
          system("vagrant up #{ box } --provider=linode --no-provision")
        when "aws"
          File.symlink("Vagrantfile.aws", "Vagrantfile")
          system("vagrant up #{ box } --provider=aws --no-provision")
        else
          File.symlink("Vagrantfile.vbox", "Vagrantfile")
          system("vagrant up #{ box } --no-provision")
      end
    end
  end
  system("vagrant provision jenkins")
end

