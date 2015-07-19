require_relative 'spec_helper'

describe user('jenkins') do
    it { should exist }
    it { should have_home_directory '/var/lib/jenkins' }
    it { should have_login_shell '/bin/bash' }
end

describe file('/var/lib/jenkins/.ssh') do
    it { should be_directory }
    it { should be_mode 700 }
    it { should be_owned_by 'jenkins' }
    it { should be_grouped_into 'jenkins' }
end

describe file('/etc/yum/pluginconf.d/versionlock.list') do
    it { should contain 'jenkins' }
end

describe package('jenkins') do
  it { should be_installed }
end

describe file('/etc/default/jenkins') do
    it { should contain '8080' }
end

describe file('/var/lib/jenkins/config.xml') do
    it { should be_owned_by 'jenkins' }
    it { should be_grouped_into 'jenkins' }
end

describe service('jenkins') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/opt/jenkins/jenkins-cli.jar') do
    it { should be_file }
end
