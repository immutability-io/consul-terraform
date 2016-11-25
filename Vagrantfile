# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  config.vm.provision "shell", path: "vagrant_scripts/install_dependencies.sh"
  config.vm.provision "shell", path: "vagrant_scripts/install_hashistack.sh", privileged: false
  config.vm.provision "shell", path: "vagrant_scripts/setup_environment.sh"
  config.vm.provision "shell", path: "vagrant_scripts/start_vault.sh"
  config.vm.provision "shell", path: "vagrant_scripts/dot_files.sh"
end
