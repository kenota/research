#!/bin/bash

for i in {0..40} 
do
    echo 127.0.0.1 couchdb-slave-$i.k8slocal
done  