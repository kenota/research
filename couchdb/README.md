### Research on [CouchDB](https://couchdb.apache.org/)

This repository holds a simple skaffold project to experiment with couchdb scaling. It setups two types of deployment "couchdb-leader" and "couchdb-follower-N" followers.

It setups leader to have admin/admin123 and followers to have follower/follower123 admin credentials.

Designed to be used with k8s for Docker Desktop for Mac.

1. Set up records in `/etc/hosts` for `couchdb-{leader/follower-N/web/follower-cluster}.k8slocal` pointing to localhost:
```
127.0.0.1 couchdb-web.k8slocal
127.0.0.1 couchdb-leader.k8slocal
127.0.0.1 couchdb-follower-cluster.k8slocal

127.0.0.1 couchdb-follower-0.k8slocal
127.0.0.1 couchdb-follower-1.k8slocal
[skipped]
```
2. Execute `skaffold run`
3. Run `./populate.sh` - this will load test data in CouchDB master
4. Run `./replicate.sh` - this will set up replication on all followers. You may want to adjust number of followers in `charts/templates/couchdb-follower.yaml` and in `replicate.sh`
5. Test your workloads using `wrk` you can chose what you want to do. For example, if you want to test single node performance:
```
wrk -t3 -c100 -d20s --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-0.k8slocal/"
```
You can compare it with the performance when load is distributed across all nodes:

```
wrk -t3 -c100 -d20s --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-cluster.k8slocal/"
```
