---
layout: post
title:  "redis study notes"
date:   Fri Mar 17 00:47:56 PDT 2017
categories: redis
---

redis key notes 
----

# cluster design #

* performance
    * async replication
    * avoid key-value version conflicts or merge
    * scaling readonly reads using slave nodes
* scalability
    * add/remove nodes
    * redirection & resharding
    * key-node mapping
* avaliability
    * failover
    * partition
    * persistent
      * AOF vs Snapshot
    * **replicate migration** for orphaned masters

# write safety #

* failure cases
    * master die without write reaching slaves before slave promoted
    * out-of-date routing table in client side <corner case>

Redis cluster protocol 
----
* discover new nodes
* promote slave to master
* propagate Pub/Sub msg

# nodes handshake on discovering
  * admin command `CLUSTER MEET ip port`
  * auto-discover into fully connnected graph
  
    ` if A know B and B know C, then B send gossip msg to A about C`
  
# fault tolerance
  * heartbeat & gossip msg
    `ping/pong`
  * failure detection
    `PFAIL/FAIL flag`

keys distribution model
----

# hash slot/hash tag 
    //HASH_SLOT = CRC16(key) mod 16384
    def HASH_SLOT(key)
        s = key.index "{"
        if s
            e = key.index "}",s+1
            if e && e != s+1
                key = key[s+1..e-1]
            end
        end
        crc16(key) % 16384
    end


# hash algorithm #

* how to select a hash function?
    1. input data
    2. probability distribution 

# consistent hash #

    * 1-n mapping: node-vnode
	hashlist = hash(nodename+vnode[i]) for i in range(n)
	rbt.add(hashlist)
	
    * hit cache
    h1 = hash(request)
    cache = rbt.findCacheNode(h1)
    response = cache.handle(request)

Reference:
----
1. [cluster spec](https://redis.io/topics/cluster-spec)
2. [Raft](https://raft.github.io/) 
3. [Paxos](https://en.wikipedia.org/wiki/Paxos_(computer_science))
