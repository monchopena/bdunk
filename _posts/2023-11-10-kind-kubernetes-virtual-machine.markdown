---
layout: post
title:  "Testing Kind Kubernetes cluster in your virtual machine"
date:   2023-11-10 00:00:00 +0200
categories: kubernetes kind testing virtual machine
summary: This is a configuration for a Kind Kubernetes cluster in your virtual machine
---

I created a VPS with 16GB of RAM and 6 CPU to test my applications in a Kubernetes cluster.

First you need to install [Docker][docker] and [Kind][kind].

For docker you can use this useful script:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
Add your user to docker group:

```bash
sudo usermod -aG docker $USER
```

Now create a file with Kind configuration:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30167
    hostPort: 80
  - containerPort: 30794
    hostPort: 443
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
name: kindly
networking:
  ipFamily: ipv4
  apiServerAddress: 192.168.1.88
```

Install Kind

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

And create the cluster:

```bash
kind create cluster --config kind.yaml
```

Install Kubectl:

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

Install Krew and some good plugins:

```bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
```

The plugins (you can install more [here][krew-plugins]):

```bash
k krew install ns
k krew install ctx
k krew install tree
k krew install view-secret
k krew install modify-secret
...
```

Install helm:

```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```

MetalLB instalation for LoadBalancer:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
```

You have to wait for the pods to be ready:

```bash
kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-789c75c689-x8rd9   1/1     Running   0          100s
speaker-cxw6j                 1/1     Running   0          100s

```

Traefik installation:

```bash
k create ns traefik && k ns traefik
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik
```

If the load balancer is not ready, you need to check the ports:

```bash
k get svc -n traefik
NAME      TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
traefik   LoadBalancer   10.96.145.19   <pending>     80:32699/TCP,443:30199/TCP   3m32s
```

And now you will need to change the ports in the Traefik configuration:

You need to put the ports 80 and 443 in the ports 30167 and 30794:

```bash
k edit svc traefik -n traefik
```

Finally we only need to adjust the metallb configuration:

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
```

Let's publish a simple web to check if everything is working:

First we are going to allow traefik to across the namespace:

```bash
kubectl edit deploy traefik -n traefik
```

Add this line to args

```yaml
...
- --providers.kubernetescrd.allowCrossNamespace=true
...
```

Create a namespace:

```bash
kubectl create ns tests && kubectl ns tests
```

A deployment:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
spec:
  selector:
    matchLabels:
      app: apache2
  replicas: 1 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: apache2
    spec:
      containers:
      - name: apache2
        image: httpd
        ports:
        - containerPort: 80
```

The service:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/instance: traefik
  name: apache2
spec:
  type: ClusterIP
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - port: 80
  selector:
    app: apache2
```

And the ingress:

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  labels:
    app.kubernetes.io/instance: traefik
  name: 213.136.89.166
  namespace: traefik
spec:
  entryPoints:
  - web
  routes:
  - kind: Rule
    match: Host(`213.136.89.166`)
    services:
    - kind: Service
      name: apache2
      namespace: tests
      port: 80
```

Beautiful screen when you go to the IP:

[![it-works]][it-works]

[krew-plugins]: https://krew.sigs.k8s.io/plugins/
[kubernetes]: https://kubernetes.io/
[kind]: https://kind.sigs.k8s.io/
[docker]: https://www.docker.com/
[it-works]: /attachments/it_works.png