#!/bin/bash 
# This file populates creates people couchdb database and populates it with random data

COUCHDB_ADDR=${COUCHDB_ADDR:-http://admin:admin123@couchdb-leader.k8slocal}

set -e

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

if ! curl --fail --head $COUCHDB_ADDR/people > /dev/null; then
  curl -X PUT $COUCHDB_ADDR/people
fi 

curl -H "Content-Type: application/json" --data-binary "@data_payload.json" -XPOST $COUCHDB_ADDR/people/_bulk_docs