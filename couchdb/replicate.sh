#!/bin/bash

set -e 

for i in {0..8}
do
  if ! curl -s --fail http://follower:follower123@couchdb-follower-$i.k8slocal/_replicator 2>&1; then 
    curl -XPUT http://follower:follower123@couchdb-follower-$i.k8slocal/_replicator
  fi
  curl -H "Content-Type: application/json" -XPOST http://follower:follower123@couchdb-follower-$i.k8slocal/_replicator --data-binary @- << EOF
{
    "_id": "replicate_smth",
    "source": "http://admin:admin123@research-couchdb-db-leader:5984/people",
    "target":  "http://follower:follower123@localhost:5984/people",
    "create_target":  true,
    "continuous": true
}
EOF
  
done

exit 0

