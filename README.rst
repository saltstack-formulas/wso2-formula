wso2 suite
==========

This module will install and configure wso2 software:
- application server: wso2.as
- esb server: wso2.esb

Prerequisites
-------------

Downloaded binaries from wso2 and place these in the files section.

archive state from ``salt-contrib`` by Bclermont.
::

   https://github.com/saltstack/salt-contrib/blob/master/states/archive.py

add this in /srv/salt/_states/

Modules
-------

1. application server: 

   include:
      - wso2.as

2. esb server: 

   include:
      - wso2.esb


Pillar
------

In pillar the following items can be set:

- user:
      under which the service will be run
- group:
      under which everything installs
- version:
      version of the wso2 binary
- database:
      which type of database, for now only postgresql
- db_name:
      which database name do you want to use (default wso2esb)
- db_url:
      if the postgresql database is on a different minion set
      the url here
- db_port:
      which port is used for the database
- db_username:
      username for database access from wso2esb
- db_password:
      password for database access from wso2esb
- jdbc_url:
      the jdbc_url part  wso2esb needs to make database connection
- jdbc_driver:
      the jdbc driver that is needed for the database connection
- extra_jar:
      extra jar files like 
      postgresql-9.2-1003.jdbc4.jar for a postgresql database
      mysql-connector-java-5.1.21.jar for a mysql database
      coherence-3.7.1.6.jar to make a coherence connection possible

Todo
----

create other wso2 formulas for bam
Improve database logic in esb.sls to support mysql and
eventually database minion and esb minions 

Credits
-------

Bclermont for archive state

