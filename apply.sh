#!/bin/zsh
# https://argo-cd.readthedocs.io/en/stable/getting_started/
kind create cluster --image=kindest/node:v1.21.2 --config=kind-config.yaml

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
while ! kubectl get ns argocd; do sleep 1; done
while kubectl get pods -n argocd 2>&1 | grep 'No resources found'; do sleep 1; done
kubectl wait --for=condition=ready pods -n argocd --all

echo "Argo admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo "Forwarding and ready to connect:"
kubectl port-forward service/argocd-server -n argocd 8080:443

argocd login localhost:8080
