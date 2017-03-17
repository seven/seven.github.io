---
layout: post
title:  "redis study notes"
date:   Fri Mar 17 00:47:56 PDT 2017
categories: redis
---

redis
=====

topics
------

  * cluster
  * lock
  * usage
  
# hash algorithm #
  * how to select a hash function?
      1. input data
      2. probability distribution 

## consistent hash ##

    * 1-n mapping: node-vnode
	hashlist = hash(nodename+vnode[i]) for i in range(n)
	rbt.add(hashlist)
	
    * hit cache
    h1 = hash(request)
    cache = rbt.findCacheNode(h1)
    response = cache.handle(request)

1. [cluster spec](https://redis.io/topics/cluster-spec)
