# Antrea-playground

Cluster Setup with Antrea CNI on Digital Ocean

- Antrea CNI [Antrea](https://github.com/vmware-tanzu/antrea)
- See also [TGIK Episode 135: Antrea CNI](https://github.com/vmware-tanzu/tgik/tree/master/episodes/135)


## Cluster Setup
	- do-cluster.sh creates droplets on Digital Ocean
	- Ansibe Playbook (from Antrea repo) creates a 3 Node Kubernetes Cluster
	- Antrea is deployed by the yaml seployments/antrea/antrea.yaml 

### Create Cluster 
```
#1. Execute bash script: 
./do-cluster.sh create 

#2. Copy the Public IP's of Master and Worker to host file  

#3. Execute bash script to run provisioning playbook: 
./run-playbook.sh

#4. Copy ./playbook/kube/config to ~/.kube
rm ~/.kube/config
cp ./playbook/kube/config ~/.kube

#5. Deploy Antrea 
kubectl create -f ./deployments/antrea/antrea.yml

```

### Destroy Cluster
```
#1. Execute bash script: ./do-cluster.sh destroy
```
##  Deploy Demo App
```
 kubectl apply -k github.com/BuoyantIO/emojivoto/kustomize/deployment
```

## Packet Tracing 
```
# Capture
export W2=<worker2>
ssh -i ~/.ssh/id_rsa root@$W2
tcpdump -i eth0 -s 65535 -w capture.pcap

# 
scp -i ~/.ssh/id_rsa root@$W2:/root/capture.pcap .
```