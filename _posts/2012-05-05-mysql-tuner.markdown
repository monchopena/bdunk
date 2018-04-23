Date: 05 May 2012
Categories: systems, mysql
Summary: MySQLTuner is a script written in Perl that will assist you with your MySQL configuration and make recommendations for increased performance and stability.
Read more: Show me more

# MySQL Tuner

A powerful tool:

> apt-get install mysqltuner

You can use:

> mysqltuner --user=root --pass=xxx

A report sample:

>  \>\>  MySQLTuner 1.0.1 - Major Hayden <major@mhtx.net>
>
>  \>\>  Bug reports, feature requests, and downloads at http://mysqltuner.com/
>
>  \>\>  Run with '--help' for additional options and output filtering
>
> [OK] Logged in using credentials passed on the command line
>
> 
> -------- General Statistics --------------------------------------------------
>
> [--] Skipped version check for MySQLTuner script
>
> [OK] Currently running supported MySQL version 5.1.49-3
>
> [OK] Operating on 64-bit architecture
> 
> -------- Storage Engine Statistics -------------------------------------------
>
> [--] Status: -Archive -BDB -Federated +InnoDB -ISAM -NDBCluster 
>
> [--] Data in MyISAM tables: 91M (Tables: 1344)
>
> [--] Data in InnoDB tables: 17M (Tables: 349)
>
> [--] Data in MEMORY tables: 0B (Tables: 2)
>
> [!!] Total fragmented tables: 411
> 
> -------- Performance Metrics -------------------------------------------------
>
> [--] Up for: 42d 22h 39m 32s (10M q [2.924 qps], 361K conn, TX: 20B, RX: 15B)
>
> [--] Reads / Writes: 87% / 13%
>
> [--] Total buffers: 58.0M global + 2.6M per thread (151 max threads)
>
> [OK] Maximum possible memory usage: 454.4M (44% of installed RAM)
>
> [OK] Slow queries: 0% (3/10M)
>
> [OK] Highest usage of available connections: 7% (12/151)
>
> [OK] Key buffer size / total MyISAM indexes: 16.0M/40.6M
>
> [OK] Key buffer hit rate: 99.9% (27M cached / 14K reads)
>
> [OK] Query cache efficiency: 42.6% (2M cached / 6M selects)
>
> [!!] Query cache prunes per day: 254
>
> [OK] Sorts requiring temporary tables: 0% (0 temp sorts / 25K sorts)
>
> [OK] Temporary tables created on disk: 13% (7K on disk / 53K total)
>
> [OK] Thread cache hit rate: 99% (66 created / 361K connections)
>
> [!!] Table cache hit rate: 0% (64 open / 125K opened)
>
> [OK] Open file limit used: 4% (47/1K)
>
> [OK] Table locks acquired immediately: 99% (1M immediate / 1M locks)
>
> [!!] InnoDB data size / buffer pool: 17.0M/8.0M
> 
> -------- Recommendations -----------------------------------------------------
>
> General recommendations:
>     Run OPTIMIZE TABLE to defragment tables for better performance
>     Enable the slow query log to troubleshoot bad queries
>     Increase table_cache gradually to avoid file descriptor limits
> Variables to adjust:
>     query_cache_size (> 16M)
>     table_cache (> 64)
>     innodb_buffer_pool_size (>= 17M)

Follow the recommendations ;-)

A very good Book about Mysql [High Performance MySQL: Optimization, Backups, Replication, and More: Optimization, Backups, and Replication][book].

The Perl script code in [GitHub][github].


[book]: http://www.amazon.es/High-Performance-MySQL-Optimization-Replication/dp/1449314287/ref=sr_1_1?ie=UTF8&qid=1336215569&sr=8-1
[github]: https://github.com/rackerhacker/MySQLTuner-perl
