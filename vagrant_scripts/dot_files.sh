#!/usr/bin/env bash

echo -e "[dot_files] installing...\n";

sudo rm -rf /home/vagrant/.bash_profile
ln -s /vagrant/config/dot_files/bash_profile /home/vagrant/.bash_profile
sudo rm -rf /home/vagrant/.bashrc
ln -s /vagrant/config/dot_files/bashrc /home/vagrant/.bashrc
sudo rm -rf /home/vagrant/.bashrc.d
ln -s /vagrant/config/dot_files/bashrc.d /home/vagrant/.bashrc.d
sudo rm -rf /home/vagrant/.gitignore_global
ln -s /vagrant/config/dot_files/gitignore_global /home/vagrant/.gitignore_global
sudo rm -rf /home/vagrant/.profile
ln -s /vagrant/config/dot_files/profile /home/vagrant/.profile
sudo rm -rf /home/vagrant/.tmux.conf
ln -s /vagrant/config/dot_files/tmux.conf /home/vagrant/.tmux.conf
sudo rm -rf /home/vagrant/.vim
ln -s /vagrant/config/dot_files/vim /home/vagrant/.vim
sudo rm -rf /home/vagrant/.vimrc
ln -s /vagrant/config/dot_files/vimrc /home/vagrant/.vimrc
sudo rm -rf /home/vagrant/.bin
ln -s /vagrant/config/dot_files/bin /home/vagrant/.bin

echo -e "[dot_files] completed ;) \n";
