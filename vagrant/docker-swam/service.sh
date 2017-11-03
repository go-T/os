#!/bin/bash

sudo docker node ls
sudo docker network create --subnet=172.168.0.1/24 --driver overlay overlay_1 >/vagrant/network
sudo docker network ls
sudo docker network inspect overlay_1

sudo docker service create \
	--detach=false \
	--replicas 2 \
	--network overlay_1 \
	--name nginx \
	-p 80:80 \
	nginx:alpine

sudo docker service ls
sudo docker service ps nginx
sudo docker service scale nginx=3

# 
# --constraint 'node.hostname==node02' \  只运行在node02 节点
# docker service create --name app --mode global -p 8000:8000 jevic.io/nginx:alpine
