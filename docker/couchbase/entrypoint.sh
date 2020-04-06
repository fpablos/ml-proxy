#!/bin/bash

#Modo monitor (usado para adjuntarse al entrypoint base)
set -m
#Pasamos este a background
/entrypoint.sh couchbase-server &

#Función para verificar si la instancia del proceso levanto
db_status() {
  curl --silent http://127.0.0.1:8091/pools > /dev/null
  echo $?
}

#Esperamos que la instancia del servicio este disponible
until [[ $(db_status) = 0 ]]; do
 >&2 echo "Waiting for Couchbase Server to be available..."
 sleep 1
done

echo "Couchbase is online"

couchbase-cli cluster-init -c 127.0.0.1:8091 \
 --cluster-ramsize ${SERVER_MEMORY_QUOTA} \
 --cluster-index-ramsize ${INDEX_MEMORY_QUOTA} \
 --cluster-password ${PASS} \
 --cluster-username ${USER} \
 --index-storage-setting default \
 --services data,index,query,fts

couchbase-cli bucket-create -c 127.0.0.1:8091 \
 --bucket=${PROXY_CONFIG} \
 --bucket-type=couchbase \
 --bucket-ramsize=${PROXY_CONFIG_MEMORY_QUOTA} \
 --bucket-eviction-policy=valueOnly \
 --bucket-replica=0 \
 --enable-index-replica=0 \
 --password=${PASS} \
 --username=${USER} \
 --wait

couchbase-cli bucket-create -c 127.0.0.1:8091 \
 --bucket=${PROXY_STATISTICS} \
 --bucket-type=couchbase \
 --bucket-ramsize=${PROXY_STATISTICS_MEMORY_QUOTA} \
 --bucket-eviction-policy=valueOnly \
 --bucket-replica=0 \
 --enable-index-replica=0 \
 --password=${PASS} \
 --username=${USER} \
 --wait

echo "Setup the configuration..."

echo "*** Insert initial config ***"

curl http://${USER}:${PASS}@127.0.0.1:8093/query/service \
  -d "statement=INSERT INTO ${PROXY_CONFIG} (KEY, VALUE) VALUES ( \"host\", {\"active\": false, \"hosts\": [{\"ip\": \"\", \"active\": false, \"max_connection\": 0}], \"paths\": [{\"path\": \"\", \"active\": false, \"max_connection\": 0}]}) RETURNING *"
curl http://${USER}:${PASS}@127.0.0.1:8093/query/service \
  -d "statement=INSERT INTO ${PROXY_CONFIG} (KEY, VALUE) VALUES ( \"blacklist\",  {\"ip\":[]}) RETURNING *"
curl http://${USER}:${PASS}@127.0.0.1:8093/query/service \
  -d "statement=INSERT INTO ${PROXY_STATISTICS} (KEY, VALUE) VALUES ( \"statistics\", {\"ip\": \"\", \"sucessful\": 0, \"rejected\": 0, \"hosts\": [{\"ip\": \"\", \"successful\": 0, \"rejected\": 0, \"date\": \"\"}], \"paths\": [{\"path\": \"\", \"successful\": 0, \"rejected\": 0, \"date\": \"\"}]}) RETURNING *"

echo "*** Creating Indexes ***"
curl http://${USER}:${PASS}@127.0.0.1:8093/query/service \
  -d "statement=CREATE INDEX ip_index ON ${PROXY_CONFIG}(ip) USING GSI"
curl http://${USER}:${PASS}@127.0.0.1:8093/query/service \
  -d "statement=CREATE INDEX ip_index ON ${PROXY_STATISTICS}(ip) USING GSI"

fg 1
