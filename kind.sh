#!/bin/bash

# Function to install Docker
install_docker() {
    if ! command -v docker &> /dev/null
    then
        echo "Docker is not installed. Installing Docker..."
        # Install Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        echo "Docker installed successfully."
    else
        echo "Docker is already installed."
    fi
}

# Function to install kubectl
install_kubectl() {
    if ! command -v kubectl &> /dev/null
    then
        echo "kubectl is not installed. Installing kubectl..."
        # Install kubectl
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
        echo "kubectl installed successfully."
    else
        echo "kubectl is already installed."
    fi
}

# Function to install kind
install_kind() {
    if ! command -v kind &> /dev/null
    then
        echo "kind is not installed. Installing kind..."
        # Install kind
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/
        echo "kind installed successfully."
    else
        echo "kind is already installed."
    fi
}

# Check if curl is installed
if ! command -v curl &> /dev/null
then
    echo "curl is not installed. Installing curl..."
    sudo apt-get update
    sudo apt-get install -y curl
    echo "curl installed successfully."
fi

# Install Docker, kubectl, and kind
install_docker
install_kubectl
install_kind

# Define the cluster name and version
CLUSTER_NAME="my-kind-cluster"
K8S_VERSION="v1.21.1"

# Create a kind cluster
kind create cluster --name $CLUSTER_NAME --config kind-config.yaml --image "kindest/node:$K8S_VERSION"

# Export KUBECONFIG for the new cluster
export KUBECONFIG="$(kind get kubeconfig-path --name=$CLUSTER_NAME)"

# Verify the cluster status
kubectl cluster-info

# Save the kubeconfig to a safe location
KUBECONFIG_DEST="/workspaces/intern-task/kubeconfig.yaml"
sudo cp $KUBECONFIG $KUBECONFIG_DEST

echo "Kind cluster '$CLUSTER_NAME' is now deployed and configured."
echo "Kubeconfig is saved to '$KUBECONFIG_DEST'."
