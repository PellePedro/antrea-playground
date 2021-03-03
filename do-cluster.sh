#!/bin/bash

set -e

# --------------------------------------------------------------------
# doctl commands 
#
# doctl compute droplet list --format "PrivateIPv4"
# doctl compute droplet list --no-header --format 
#
# --------------------------------------------------------------------

# SSH key name on Digital Ocean
SSH_KEY_NAME=DO_KEY
key="$(doctl compute ssh-key list --no-header | grep $SSH_KEY_NAME)"
key=($key)
key="${key[2]}"
# Image size, OS and region
DROPLET_SIZE="s-2vcpu-4gb"
DROPLET_IMAGE="ubuntu-20-04-x64"
REGION="tor1"

# Nodes in the cluster 1 master and 2 workers
NODES=(master worker1 worker2)

# Create Droplets as specified by NODES
function create_cluster() {
	for node in "${NODES[@]}"; do
		echo "Creating Droplet ${node}"
		doctl compute droplet create ${node} \
			--region   "${REGION}" \
			--image    "${DROPLET_IMAGE}" \
			--size     "${DROPLET_SIZE}" \
			--ssh-keys "${key}" \
			--wait
	done
}

# Destroy Droplets as specified by NODES
function destroy_cluster() {
	for node in "${NODES[@]}"; do
		echo "Destroying Droplet ${node}"
		doctl compute droplet delete -f ${node}
	done
}

case $1 in
	create)
		echo "Creating Cluster"
        create_cluster
		;;
    destroy)
		echo "Destroy Cluster"
		destroy_cluster
		;;
	*)
		echo "Usage: ./do-cluster.sh create|destroy"
		;;
esac
