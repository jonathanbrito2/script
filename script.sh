#!/bin/bash

cat > /etc/modules-load.d/k8s.conf <<EOF
br_netfilter
ip_vs
ip_vs_rr
ip_vs_sh
ip_vs_wrr
nf_conntrack_ipv4
EOF

apt update

apt upgrade -y

apt install apt-transport-https ca-certificates curl software-properties-common

#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add –


#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

curl -fsSL https://get.docker.com | bash

#apt update

# INSTALL DOCKER

#sudo apt install docker-ce=19.03.15~3 docker-ce-cli=19.03.15~3 containerd.io
#apt install docker-ce docker-ce-cli containerd.io

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload

systemctl restart docker

docker info | grep -i cgroup

# INSTALL K8S

apt-get update && apt-get install -y apt-transport-https gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubelet kubeadm kubectl

swapoff -a


