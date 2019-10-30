# Install single node Kubernetes cluster

for fedora / Centos

## Install steps

Ansible playbooks:
```bash
$ ./prerequisites.yaml
$ ./install-k8s.yaml
$ ./install-helm.yaml
``` 
Run them in this order.

## Add to .bashrc:

kubectl aliasses
```bash
alias kc='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgc='kubectl get componentstatuses'
alias kccc='kubectl config current-context'
alias kcuc='kubectl config use-context'
alias kcgc='kubectl config get-contexts'
```

Default editor, bash completion and cluster-admin credentials
```bash
source <(kubectl completion bash)
export KUBE_EDITOR="vi"
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## tmux setting

content of ~/.tmux.conf
```bash
unbind C-b
set -g prefix C-a
bind a send-prefix
set -g status-bg red
set -g status-fg white
set -g allow-rename off
set -g default-terminal "screen-256color"
```

## Useful links

* https://kubernetes.io/docs/reference/kubectl/cheatsheet
* https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands
* https://livebook.manning.com/book/kubernetes-in-action/about-this-book
* https://github.com/dgkanatsios/CKAD-exercises
* https://github.com/walidshaari/Kubernetes-Certified-Administrator

## run test pods

Create a test pod
```bash
$ kubectl run test01 -it --image=centos --generator=run-pod/v1 /bin/bash
```

or
```bash
$ kubectl run test01 -it --image=centos --restart=Never /bin/bash
```

Attach to test pod
```bash
$ kubectl attach test01  -it
```

## Logging

Shows continous log stream
```bash
$ kubeclt log coredns-5644d7b6d9-5qhnf --follow
```

Shows log previous instance
```bash
$ kubeclt log coredns-5644d7b6d9-5qhnf --previous
```

Shows log for all containers
```bash
$ kubeclt log coredns-5644d7b6d9-5qhnf --all-containers
```

Shows log deployment, specific container
```bash
$ kubeclt log deploment/nginx -c nginx-1
```


## queries

Sort on restart count
```bash
$ kubectl get pods --all-namespaces --sort-by='.status.containerStatuses[0].restartCount'
```

Sort on creation timestamp
```bash
$ kubectl get pods --all-namespaces --sort-by=.metadata.creationTimestamp
```

Get image with jsonpath or jq
```bash
$ kubectl get pods -n kube-system  coredns-5644d7b6d9-2w2zc  -o jsonpath='{.spec.containers[].image}{"\n"}'

$ kubectl get pods -n kube-system  coredns-5644d7b6d9-2w2zc  -o json | jq .spec.containers[].image
```

Check which nodes are ready
```bash
$ JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}' \
  && kubectl get nodes -o jsonpath="$JSONPATH" | grep "Ready=True"
```

Check Kubelet version
```bash
$ kubectl get nodes -o json | jq .items[].status.nodeInfo.kubeletVersion
```

## Explain object stucture

```bash
$ kubectl explain pod.metadata.creationTimestamp

$ kubectl explain deployment --recursive
```

Cluster dump
```bash
$ kubectl cluster-info dump --all-namespaces --output-directory=$PWD/cluster-state
```
