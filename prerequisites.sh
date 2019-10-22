ZONE=$(firewall-cmd --get-default-zone)
for PORT in 6443 2379-2380 10250-10252 30000-32767; do
     echo "Open port ${PORT}/tcp"
     firewall-cmd --zone=${ZONE} --add-port=${PORT}/tcp
     firewall-cmd --zone=${ZONE} --add-port=${PORT}/tcp --permanent
done;
firewall-cmd --reload

update-alternatives --set iptables /usr/sbin/iptables-legacy

dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine

dnf update && dnf install device-mapper-persistent-data lvm2 dnf-plugins-core

sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io

mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
  "metrics-addr" : "192.168.11.114:9323",
  "experimental" : true,
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker


cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

swapoff -a
sed -i 's/\(^.*swap.*$\)/\#DISABLE:\1/g' /etc/fstab

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet


