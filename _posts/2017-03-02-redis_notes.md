---
layout: post
title:  "redis study notes"
date:   Fri Mar 17 00:47:56 PDT 2017
categories: redis
---


redis key notes 

* TOC
{:toc}

# redis data types

  * how to select redis key?
    - binary safe
    - schema, e.g. "comment:123:reply-to"
    - max key size = 512MB
  * string/list/capped list/set/range/bitmap

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
      * AOF vs RDB Snapshot
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

# slave election / promotion

  * epoch - term in Raft
  * winer slave gain majority votes from masters

Sentinel
------

# quorum
    * quorum - number of sentinels agree about master failure
    * start failover only when, e.g. quorum=2, total=5
        * 2 agree about one master failure
        * 3+/majority sentinels reachable (=== no failover in minority partition)

# TILT mode

stop acting/response failure request until computer time resolved.

>if the time difference is negative or unexpectedly big (2 seconds or more) the TILT mode is entered (or if it was already entered the exit from the TILT mode postponed)

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

RedLock
----

# algorithm

    if (cluster.acquireCount(key,val) > N/2+1) and elapsed_time < lock_validity_time:
        return true
    else:
        cluster.unlockAll(key,val) 
        return false



Raft
----

# roles
  * follower
  * candidate
  * leader
  
  
# how to elect leader?
  * terms
  * avoid split vote by randomized selection timeout

# how to replicate log entries?
  * commit once log entry has replicated it on a majority of servers

# visualization (RaftScope)
Here's a Raft cluster running in your browser. You can interact with it to see Raft in action. Five servers are shown on the left, and their logs are shown on the right. We hope to create a screencast soon to explain what's going on. 
<iframe src="https://raft.github.io/raftscope/index.html" style="border: 0; width: 800px; height: 580px; margin-bottom: 20px"></iframe>

Redisson
----

## lock implementation ##

```java
    <T> RFuture<T> tryLockInnerAsync(long leaseTime, TimeUnit unit, long threadId, RedisStrictCommand<T> command) {
        internalLockLeaseTime = unit.toMillis(leaseTime);

        return commandExecutor.evalWriteAsync(getName(), LongCodec.INSTANCE, command,
                  "if (redis.call('exists', KEYS[1]) == 0) then " +
                      "redis.call('hset', KEYS[1], ARGV[2], 1); " +
                      "redis.call('pexpire', KEYS[1], ARGV[1]); " +
                      "return nil; " +
                  "end; " +
                  "if (redis.call('hexists', KEYS[1], ARGV[2]) == 1) then " +
                      "redis.call('hincrby', KEYS[1], ARGV[2], 1); " +
                      "redis.call('pexpire', KEYS[1], ARGV[1]); " +
                      "return nil; " +
                  "end; " +
                  "return redis.call('pttl', KEYS[1]);",
                    Collections.<Object>singletonList(getName()), internalLockLeaseTime, getLockName(threadId));
    }
```

## unlock implementation ##

```java
public void unlock() {
        Boolean opStatus = commandExecutor.evalWrite(getName(), LongCodec.INSTANCE, RedisCommands.EVAL_BOOLEAN,
                        "if (redis.call('exists', KEYS[1]) == 0) then " +
                            "redis.call('publish', KEYS[2], ARGV[1]); " +
                            "return 1; " +
                        "end;" +
                        "if (redis.call('hexists', KEYS[1], ARGV[3]) == 0) then " +
                            "return nil;" +
                        "end; " +
                        "local counter = redis.call('hincrby', KEYS[1], ARGV[3], -1); " +
                        "if (counter > 0) then " +
                            "redis.call('pexpire', KEYS[1], ARGV[2]); " +
                            "return 0; " +
                        "else " +
                            "redis.call('del', KEYS[1]); " +
                            "redis.call('publish', KEYS[2], ARGV[1]); " +
                            "return 1; "+
                        "end; " +
                        "return nil;",
                        Arrays.<Object>asList(getName(), getChannelName()), LockPubSub.unlockMessage, internalLockLeaseTime, getLockName(Thread.currentThread().getId()));
                    }
```

Questions:
----

    1. How does redis provide high avaliability and reliability?
       - Redis Sentinel
       - Redis Cluster
         - scale/add node/add replica slave
         - slave replicas
           - replicas auto-migration
           - async-replicate --> weak consistency
         - data sharding/partition
           - hashing(hash slot) vs consistent hashing(hashring+vnode)
       - Raft algorithm

    2. How to persistent and recovery data in Redis?
       - AOF
       - RDB
    
    4. why redis is fast? 
       - memory
       - network 
         - no blocking i/o api (epoll/kqueue, edge trigger > level trigger) 
       - scaling reading(more read-only salves)/writing(sharding by more master)

    5. user stories
       - DB vs cache
       - message broker
       - RedLock
       - Bloomfilter
    

Reference:
----
1. [cluster spec](https://redis.io/topics/cluster-spec)
2. [Raft](https://raft.github.io/) 
3. [Paxos](https://en.wikipedia.org/wiki/Paxos_(computer_science))
4. [Pub/Sub](https://making.pusher.com/redis-pubsub-under-the-hood/)
