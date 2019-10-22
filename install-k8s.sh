kubeadm init --pod-network-cidr=192.168.0.0/16 

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

kubectl taint nodes --all node-role.kubernetes.io/master-

export KUBECONFIG=/etc/kubernetes/admin.conf

#git clone https://github.com/kubernetes-incubator/metrics-server.git

kubectl create -f metrics-server/deploy/1.8+

#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config


