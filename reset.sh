# Uninstalling redpanda and volt

helm uninstall redpanda -n redpanda

helm uninstall mydb -n volt

kubectl delete pvc datadir-redpanda-0 datadir-redpanda-1 datadir-redpanda-2 -n redpanda

sleep 30

helm install redpanda redpanda/redpanda -n redpanda --values red.yaml

helm install mydb voltdb/voltdb --wait --values myproperties.yaml --version=1.8.3 \
 --set-file cluster.config.licenseXMLFile="/Users/thanos/Documents/license.xml" --set metrics.enabled=true --set metrics.delta=true --namespace  volt

sleep 90
kubectl cp voltdb-aggdemo-createDB.sql mydb-voltdb-cluster-0:/tmp/ -n volt

kubectl cp procs.jar mydb-voltdb-cluster-0:/tmp/ -n volt

kubectl exec -it mydb-voltdb-cluster-0 -n volt -- sqlcmd < voltdb-aggdemo-createDB.sql

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create incoming_cdrs --partitions 24 --replicas 1 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093
    
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create unaggregated_cdrs --partitions 24 --replicas 1 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create aggregated_cdrs --partitions 24 --replicas 1 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093

kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create bad_cdrs --partitions 24 --replicas 1 --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093,redpanda-1.redpanda.redpanda.svc.cluster.local.:9093,redpanda-2.redpanda.redpanda.svc.cluster.local.:9093
