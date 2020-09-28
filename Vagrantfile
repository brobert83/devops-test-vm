Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder ".", "/vagrant"

  # without this some problems appear (don't remember what, forgot to document at the time)
  config.vbguest.auto_update = false

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.verbose = "vvv"
    ansible.extra_vars = {
        GCP_PROJECT_NAME: "buildit-devops-test"
    }
  end

  config.vm.provider "virtualbox" do |vb|
    vb.destroy_unused_network_interfaces = true
    vb.memory = "2048"
    vb.cpus = 1
  end

  config.vm.network "public_network", ip: "192.168.0.10"

  config.vm.synced_folder "e:/source/devops-test", "/home/vagrant/devops-test", create: true
end
