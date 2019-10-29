# Install single node Kubernetes cluster

for fedora / Centos

## steps

Ansible playbooks:
```bash
$ ./prerequisites.yaml
$ ./install-k8s.yaml
$ ./install-helm.yaml
``` 
## kubectl aliasses

Add to .bashrc:

```bash
alias kc='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgc='kubectl get componentstatuses'
alias kccc='kubectl config current-context'
alias kcuc='kubectl config use-context'
alias kcgc='kubectl config get-contexts'
```

## 

```bash
$ kubectl run --generator=\"run-pod/v1\" 
``
