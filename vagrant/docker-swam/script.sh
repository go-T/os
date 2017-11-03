#!/bin/bash -e

echo =========
echo "$@"
echo =========

NODE_ID=$1
NODE_IP=$2

# sudo usermod -aG docker $(id -nu)

sudo sed -i -E -e 's#([a-z]+\.)?archive.ubuntu.com#cn.archive.ubuntu.com#' /etc/apt/sources.list
sudo apt-get update -y
sudo apt-get install -y wget curl libltdl7

# install docker 
wget -q -O /tmp/docker-ce_17.09.0~ce-0~ubuntu_amd64.deb https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce_17.09.0~ce-0~ubuntu_amd64.deb
sudo dpkg -i /tmp/docker-ce_17.09.0~ce-0~ubuntu_amd64.deb 
rm -f /tmp/docker-ce_17.09.0~ce-0~ubuntu_amd64.deb 
sudo sed -i -E -e 's#^ExecStart=.*$#ExecStart=/usr/bin/dockerd -H 0.0.0.0:2375 -H unix:///var/run/docker.sock#' /lib/systemd/system/docker.service
sudo apt-get install -f -y
sudo systemctl daemon-reload
sudo systemctl restart docker

if [ "$NODE_ID" = "1" ] ; then
	sudo docker swarm init --listen-addr 0.0.0.0 --advertise-addr ${NODE_IP} | grep 'SWMTKN' > /vagrant/join.sh
	sudo docker node ls
else
	sudo bash /vagrant/join.sh	
fi