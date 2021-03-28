## Notes on CouchDB performance

Requests to the same key are much faster than to different keys:

If one document is queried:

```
kenota@marcus couchdb % wrk -t2 -c8 -d20s -s req.lua --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-0.k8slocal/"
multiplepaths: Found 1 paths
multiplepaths: Found 1 paths
multiplepaths: Found 1 paths
Running 20s test @ http://couchdb-follower-0.k8slocal/
  2 threads and 8 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    24.36ms   26.58ms 176.38ms   78.87%
    Req/Sec   272.58     50.72   454.00     69.75%
  Latency Distribution
     50%    8.23ms
     75%   45.08ms
     90%   68.15ms
     99%   83.57ms
  10906 requests in 20.09s, 5.58MB read
Requests/sec:    542.80
Transfer/sec:    284.64KB
```

If multiple documents are quired:

```
kenota@marcus couchdb % kenota@marcus couchdb % wrk -t2 -c8 -d20s -s req.lua --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-0.k8slocal/"
multiplepaths: Found 5000 paths
multiplepaths: Found 5000 paths
multiplepaths: Found 5000 paths
Running 20s test @ http://couchdb-follower-0.k8slocal/
  2 threads and 8 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    28.44ms   28.33ms  93.55ms   76.36%
    Req/Sec   194.72     33.68   290.00     60.50%
  Latency Distribution
     50%    7.83ms
     75%   55.71ms
     90%   76.94ms
     99%   84.84ms
  7793 requests in 20.09s, 4.45MB read
Requests/sec:    387.85
Transfer/sec:    226.63KB
```


Similar results on cluster workload. Single url:

```
kenota@marcus couchdb % wrk -t2 -c8 -d20s -s req.lua --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-cluster.k8slocal/"
multiplepaths: Found 1 paths
multiplepaths: Found 1 paths
multiplepaths: Found 1 paths
Running 20s test @ http://couchdb-follower-cluster.k8slocal/
  2 threads and 8 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    45.11ms  157.71ms   1.01s    93.24%
    Req/Sec     1.01k   150.18     1.35k    88.28%
  Latency Distribution
     50%    3.86ms
     75%    5.66ms
     90%   10.12ms
     99%  855.10ms
  37204 requests in 20.06s, 19.05MB read
Requests/sec:   1854.97
Transfer/sec:      0.95MB

```

Multiple urls:

```
kenota@marcus couchdb % wrk -t2 -c8 -d20s -s req.lua --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM=" "http://couchdb-follower-cluster.k8slocal/"
multiplepaths: Found 5000 paths
multiplepaths: Found 5000 paths
multiplepaths: Found 5000 paths
Running 20s test @ http://couchdb-follower-cluster.k8slocal/
  2 threads and 8 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    28.38ms  119.51ms 994.27ms   96.08%
    Req/Sec   733.98     95.35     0.93k    87.43%
  Latency Distribution
     50%    5.05ms
     75%    6.43ms
     90%    8.98ms
     99%  773.60ms
  28064 requests in 20.04s, 16.01MB read
Requests/sec:   1400.27
Transfer/sec:    818.04KB
```

Actually this could be disregarded. Seems that benchmark is also affected by local docker k8s setup. When running from inside the k8s cluster having 2 cpu resource limit, here are the numbers:

```
root@research-couchdb-web-7cdf9566-7hht9:/wrk# wrk -t 3 -c100 -d60s --latency  -H "Authorization: Basic Zm9sbG93ZXI6Zm9sbG93ZXIxMjM="  http://research-couchdb-db-follower-cluster:5984/people/4516904f6905a14d2e9d17a368000b8c
Running 1m test @ http://research-couchdb-db-follower-cluster:5984/people/4516904f6905a14d2e9d17a368000b8c
  3 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    31.17ms   71.19ms   1.05s    98.59%
    Req/Sec     1.28k   350.19     3.62k    69.49%
  Latency Distribution
     50%   21.76ms
     75%   32.86ms
     90%   45.12ms
     99%  329.06ms
  225982 requests in 1.00m, 133.83MB read
Requests/sec:   3764.14
Transfer/sec:      2.23MB
```

Not bad scaling! 