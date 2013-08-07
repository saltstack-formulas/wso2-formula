wso2 suite
==========

This module will install and configure wso2 software.

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
- db_username:
      username for database access from wso2esb
- db_password:
      password for database access from wso2esb
- jdbc_url:
      the url wso2esb needs to make database connection
- jdbc_driver:
      the jdbc driver that is needed for the database connection
- extra_jar:
      extra jar files like mysql-connector-java-5.1.21.jar for a mysql database
      or coherence-3.7.1.6.jar to make a coherence connection possible

Todo
----

create other wso2 formulas.
create depency to salt database creation...

Credits
-------

Bclermont for archive state
