#!/usr/bin/env bash

echo -e "[dot_files] installing...\n";

vagrant_user=ubuntu

sudo rm -rf /home/$vagrant_user/.bash_profile
ln -s /vagrant/config/dot_files/bash_profile /home/$vagrant_user/.bash_profile
sudo rm -rf /home/$vagrant_user/.bashrc
ln -s /vagrant/config/dot_files/bashrc /home/$vagrant_user/.bashrc
sudo rm -rf /home/$vagrant_user/.bashrc.d
ln -s /vagrant/config/dot_files/bashrc.d /home/$vagrant_user/.bashrc.d
sudo rm -rf /home/$vagrant_user/.gitignore_global
ln -s /vagrant/config/dot_files/gitignore_global /home/$vagrant_user/.gitignore_global
sudo rm -rf /home/$vagrant_user/.profile
ln -s /vagrant/config/dot_files/profile /home/$vagrant_user/.profile
sudo rm -rf /home/$vagrant_user/.tmux.conf
ln -s /vagrant/config/dot_files/tmux.conf /home/$vagrant_user/.tmux.conf
sudo rm -rf /home/$vagrant_user/.vim
ln -s /vagrant/config/dot_files/vim /home/$vagrant_user/.vim
sudo rm -rf /home/$vagrant_user/.vimrc
ln -s /vagrant/config/dot_files/vimrc /home/$vagrant_user/.vimrc
sudo rm -rf /home/$vagrant_user/.bin
ln -s /vagrant/config/dot_files/bin /home/$vagrant_user/.bin

echo -e "[dot_files] completed ;) \n";
