#!/bin/sh
#Variables
CLUSTER_NAME="sd-lab"
MACHINE_TYPE="c2d-standard-32"
NUM_NODES="8"
DISK_SIZE="100"
ZONE="us-central1-c"
K8S_CLUSTER_VERSION="1.25.10-gke.2100"
MONITORING_NS="monitoring"
VOLT_NS="volt"
CLIENT_NS="client"
REDPANDA_NS="redpanda"
DOCKER_ID=""
DOCKER_API=""
DOCKER_EMAIL=""
VOLT_DEPLPOYMENTNAME="mydb"
PROPERTY_FILE="volt-properties.yaml"
LICENSE_FILE=""
RP_PROPERTY="redpanda-properties.yaml"



# Creating k8s cluster - GKE

gcloud beta container clusters create $CLUSTER_NAME --zone $ZONE  \
 --machine-type $MACHINE_TYPE --image-type "COS_CONTAINERD" --disk-type "pd-balanced" --local-nvme-ssd-block count=2 \
 --disk-size $DISK_SIZE --num-nodes $NUM_NODES --cluster-version $K8S_CLUSTER_VERSION \
 --labels=user=$DOCKER_ID


# Creating namespaces

kubectl create ns csi-drive

kubectl create ns $VOLT_NS

kubectl create ns $CLIENT_NS

kubectl create ns $REDPANDA_NS

kubectl create ns $MONITORING_NS

kubectl create ns rpmonitor

# Storage class For NVMe disks in Pod

helm install csi-driver-lvm metal-stack/csi-driver-lvm -n csi-drive

kubectl create -f storageClass.yaml


# Creating docker secret for volt enterprise image

kubectl create secret docker-registry dockerio-registry --docker-username=$DOCKER_ID \
 --docker-password=$DOCKER_API  --docker-email=$DOCKER_EMAIL --namespace $VOLT_NS

# Volt monitoring prometheus stack
helm install monitoring-stack prometheus-community/kube-prometheus-stack --version=30.0.1 -f config.yaml -n $MONITORING_NS

# Redpanda Monitoring prometheus
helm install prometheus prometheus-community/prometheus -n rpmonitor  -f rp-prometheus.yaml

#installing Volt cluster
helm install $VOLT_DEPLPOYMENTNAME voltdb/voltdb  --version=2.0.2 --wait --values $PROPERTY_FILE\
 --set-file cluster.config.licenseXMLFile=$LICENSE_FILE --set metrics.enabled=true --set metrics.delta=true --namespace  $VOLT_NS

#installing Redpanda cluster
helm install redpanda redpanda/redpanda -n $REDPANDA_NS --values $RP_PROPERTY 

sleep 120
#Volt schema creation

kubectl cp schema/voltdb-aggdemo.jar mydb-voltdb-cluster-0:/tmp/ -n $VOLT_NS

kubectl exec -it mydb-voltdb-cluster-0 -n $VOLT_NS -- sqlcmd < schema/voltdb-aggdemo-createDB.sql
    
#create topics in redpanda

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create incoming_cdrs --partitions 12 --replicas 3 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create aggregated_cdrs --partitions 12 --replicas 3 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create bad_cdrs --partitions 12 --replicas 3 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093
