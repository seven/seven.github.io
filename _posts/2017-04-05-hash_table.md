---
layout: post
title:  "hash table and algorithm"
date:   2017-04-05
categories: java
---
# hashing function
  * collision resistance
      * attach SHA1/MD5
        less than 2^(N/2), N bits of hash output.
    
  * uniform distribution

# collision resolution
  * chaining with list/RBT/...
    - linkedlist vs RBT
  * open address
    (hash(key)+ di) mod m, ith times to collision
    * how to avoid **cluster**?
  
# hash open address application in java api 
  * ThreadLocalMap
 ```java

        private Entry getEntry(ThreadLocal<?> key) {
            int i = key.threadLocalHashCode & (table.length - 1);
            Entry e = table[i];
            if (e != null && e.get() == key)
                return e;
            else
                return getEntryAfterMiss(key, i, e); //
        }

```
  
# hash chaining application in java api 
    * LinkedHashMap
      - double-linked list
      - access order by move access node to last
      - default by insert order
    * Hashtable
      - chaining with single linked list
      - indexing
          - hashtable: int index = (hash & 0x7FFFFFFF) % tab.length;
          - hashmap:   int index = (hash ^ (hash>>>16)) % (tab.length-1);
    * HashMap
      - if binCount <6, untrieefy to list 
      - if binCount >8, (if table.length >64, trieefy to RBT; else resize())
      - if map.size > (threshold=capacity*loadfactor), resize()

```java

     /**
       * The maximum capacity, used if a higher value is implicitly specified
       * by either of the constructors with arguments.
       * MUST be a power of two <= 1<<30.
       */
      static final int MAXIMUM_CAPACITY = 1 << 30;

      /**
       * The load factor used when none specified in constructor.
       */
      static final float DEFAULT_LOAD_FACTOR = 0.75f;

      /**
       * The bin count threshold for using a tree rather than list for a
       * bin.  Bins are converted to trees when adding an element to a
       * bin with at least this many nodes. The value must be greater
       * than 2 and should be at least 8 to mesh with assumptions in
       * tree removal about conversion back to plain bins upon
       * shrinkage.
       */
      static final int TREEIFY_THRESHOLD = 8;

      /**
       * The bin count threshold for untreeifying a (split) bin during a
       * resize operation. Should be less than TREEIFY_THRESHOLD, and at
       * most 6 to mesh with shrinkage detection under removal.
       */
      static final int UNTREEIFY_THRESHOLD = 6;

      /**
       * The smallest table capacity for which bins may be treeified.
       * (Otherwise the table is resized if too many nodes in a bin.)
       * Should be at least 4 * TREEIFY_THRESHOLD to avoid conflicts
       * between resizing and treeification thresholds.
       */
      static final int MIN_TREEIFY_CAPACITY = 64;
      /**
       * The table, initialized on first use, and resized as
       * necessary. When allocated, length is always a power of two.
       * (We also tolerate length zero in some operations to allow
       * bootstrapping mechanics that are currently not needed.)
       * RBT Or LinkedList
       */
      transient Node<K,V>[] table;

      /**
       * The number of key-value mappings contained in this map.
       */
      transient int size;

      /**
       * The number of times this HashMap has been structurally modified
       * Structural modifications are those that change the number of mappings in
       * the HashMap or otherwise modify its internal structure (e.g.,
       * rehash).  This field is used to make iterators on Collection-views of
       * the HashMap fail-fast.  (See ConcurrentModificationException).
       */
      transient int modCount;

      /**
       * The next size value at which to resize (capacity * load factor).
       *
       * @serial
       */
      int threshold;

      /**
       * The load factor for the hash table.
       *
       * @serial
       */
      final float loadFactor;
```

# Java author Joshua J. Bloch
  * the Java Collections Framework
  *  http://www.javaworld.com/article/2073877/core-java/joshua-bloch--a-conversation-about-design.html
  *  http://www.oracle.com/technetwork/articles/javase/bloch-effective-08-qa-140880.html

# Distributed HashTable
  * DHT need to handle:
    * autonomy and decentralization
    * fault tolerance
    * scalability
    * load balance
    * data integrity
    * performance (routing/storage/retrieval)
  * Keyspace partitioning
    Task: removal or addition of one node changes only the set of keys owned by the nodes with adjacent IDs, and leaves all other nodes unaffected. 
    * Consistent hashing
      hashing ring + tags
    * Rendezvous hashing
      client side: highest random weight hashing, selected = max((h(s,key) for s in serverlist)
    * Locality-preserving hashing
      efficient range query by ensure that similar keys are assigned to similar objects. 

# Bloomfilter
  * used to test whether an element is a member of a set. 
  * False positive matches are possible, but false negatives are not 
  * – in other words, a query returns either "possibly in set" or "definitely not in set". 
  * Elements can be added to the set, but not removed (though this can be addressed with a "counting" removed_filter, but add removed items back is not supported.); 
  * the more elements that are added to the set, the larger the probability of false positives.

```java
    public boolean add(T object) {
        byte[] state = encode(object);

        int hashIterations = this.hashIterations;
        long size = this.size;
        long[] indexes = hash(state, hashIterations, size);
        ...set bits...
    }

    private long[] hash(byte[] state, int iterations, long size) {
        long hash1 = LongHashFunction.xx_r39().hashBytes(state);
        long hash2 = LongHashFunction.farmUo().hashBytes(state);

        long[] indexes = new long[iterations];
        long hash = hash1;
        for (int i = 0; i < iterations; i++) {
            indexes[i] = (hash & Long.MAX_VALUE) % size;
            if (i % 2 == 0) {
                hash += hash2;
            } else {
                hash += hash1;
            }
        }
        return indexes;
    }

```

# Reference
  * https://en.wikipedia.org/wiki/Poisson_distribution 
