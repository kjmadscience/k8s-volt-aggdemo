# k8s-volt-aggdemo
Mediation Aggregation demo on kubernetes

This setup is a kubernetes deployment of the following demo: [VoltDB-aggdemo](https://github.com/kjmadscience/voltdb-aggdemo)

### Components

- Google Kubernetes Engine [GKE](https://cloud.google.com/kubernetes-engine)
- Helm [v3](https://helm.sh/docs/intro/install/), Kubectl [v1.19 or later](https://kubernetes.io/docs/reference/kubectl/), Gcloud CLI [gcloud docs](https://cloud.google.com/sdk/docs/install)
- Volt Active Data [v11.4](https://docs.voltactivedata.com/v11docs/)
- Redpanda [v22.3.5](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/kubernetes/kubernetes-production-deployment/)
- Mediation Data generator
- Prometheus
- Grafana

### Pre-requisites

1. Gcloud CLI, Helm and kubectl are properly configured on the user terminal from where these scripts will be executed. 

2. Access and license to Volt Active Data Helm Charts and enterprise docker images.


### Setup Environment

1. Change variables in **setup.sh** at the top of the file to desired values for your setup. 
Details about the variables are below,

| Variable | Description |
| ----------- | ----------- |
| CLUSTER_NAME | Name of kubernetes cluster that will be created in GKE |
| MACHINE_TYPE | Type of machine from GCP machine family for nodes of the kubernetes cluster |