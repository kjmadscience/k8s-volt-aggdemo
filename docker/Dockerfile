FROM voltdb/voltdb-enterprise:latest

ARG volt_uid=1001
ARG volt_gid=1001 

WORKDIR /opt
# Replace with your custom JAR
COPY volt-SD-aggdemo-1.0-SNAPSHOT-all.jar /opt/volt-agg.jar

USER 1001:1001

WORKDIR /opt

CMD exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"
