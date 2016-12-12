require 'spec_helper'
require 'byebug'
require 'rye'

ssh_port = 2022
salt_user = 'remotesalt'
salt_pass = '59r{Y3*912'

docker_container_name = 'salt-master-default'

describe 'The container' do
  describe docker_container(docker_container_name) do
    it { should be_running }

  end

end

describe 'Salt Master' do
  describe port(4505)  do
    it {should be_listening}
  end

  describe port(4506) do
    it { should be_listening }
  end
  describe command('sudo docker exec salt-master-default ls /usr/bin/salt-key') do
    its(:stdout) { should match /\/usr\/bin\/salt-key/ }
  end
  describe command('sudo docker exec salt-master-default ls /usr/bin/salt-run') do
    its(:stdout) { should match /\/usr\/bin\/salt-run/ }
  end
  describe command('sudo docker exec salt-master-default ls /usr/bin/salt') do
    its(:stdout) { should match /\/usr\/bin\/salt/ }
  end
end

describe 'Salt API' do
  describe port(8000) do
    it { should be_listening }
  end
end

describe 'Salt User' do
  Rye::Cmd.add_command :salt_key, '/usr/local/bin/salt-key'
  ssh_client = Rye::Box.new(
      'localhost',
        user: salt_user, password: salt_pass, password_prompt: false,
        port: ssh_port, sudo: false
      )

  it 'should be able to run a Salt command-line command' do
    ssh_client.salt_key
  end
end

describe 'SSH Server' do
  describe port(ssh_port) do
    it { should be_listening }
  end
end
