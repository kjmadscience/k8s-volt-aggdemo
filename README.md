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

| Variable | Description | Example |
| ----------- | ----------- | ----------- |
| CLUSTER_NAME | Name of kubernetes cluster that will be created in GKE | "volt-lab" |
| MACHINE_TYPE | Type of machine from GCP machine family for nodes of the kubernetes cluster | "c2-standard-8" |
| NUM_NODES | Number of nodes for the entire kubernetes cluster | "8" |
| DISK_SIZE | Disk size for each node of kubernetes cluster | "200" |
| ZONE | The zone for nodes in kubernetes cluster | "us-central1-c" | 
| K8S_CLUSTER_VERSION | K8S version used by GKE  | "1.22.17-gke.4300" |
| MONITORING_NS | Namespace for prometheus for volt and kube metrics monitoring | "monitoring" |
| VOLT_NS | Namespace for volt operator and pods | "volt" |
| CLIENT_NS | Namespace for traffic generator client | "client" |
| REDPANDA_NS | Namespace for redpanda pods | "redpanda" |
| DOCKER_ID | Username for Volt enterprise docker image access | "jdoeuname" |
| DOCKER_API | API token for Volt enterprise docker image access | "" |
| DOCKER_EMAIL | Email ID for Volt enterprise docker image access | "john@doe.com" |
| VOLT_DEPLPOYMENTNAME | helm deployment name for volt | "mydb" |
| PROPERTY_FILE | Property file for volt | "myproperties.yaml" |
| LICENSE_FILE | File path with name for Volt Enterprise license |
| RP_PROPERTY | Property file for redpanda | "red.yaml" |












