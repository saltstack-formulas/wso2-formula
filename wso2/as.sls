wso2as:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}.zip
    - source_hash: md5=cfd05da8b370ac61a32c18d998de2236
    - archive_format: zip
    - if_missing: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/

carbon.xml:
  file:
    - name: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/repository/conf/carbon.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/carbon.xml.jinja
    - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - group: {{ salt['pillar.get']('wso2:as:group', 'users') }} 
    - mode: 0755
    - require:
      - archive: wso2as

jmx.xml:
  file:
    - name: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/repository/conf/etc/jmx.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/jmx.xml.jinja
    - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - group: {{ salt['pillar.get']('wso2:as:group', 'users') }}
    - mode: 0755
    - require:
      - archive: wso2as

jdk7-openjdk:
  pkg:
    - installed

wso2_user:
  user.present:
    - name: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - fullname: {{ salt['pillar.get']('wso2:as:user', 'wso2') }} 
    - shell: /bin/bash
    - home: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/
    - require:
      - archive: wso2as

/opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}:
  file.directory:
    - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - group: {{ salt['pillar.get']('wso2:as:group', 'users') }}
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - archive: wso2as
      - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}

script_start:  
  cmd.run:
    - name: "/opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/bin/wso2server.sh --start"
    - env: 
      - JAVA_HOME: '/usr/lib/jvm/java-7-openjdk'
    - shell: /bin/bash
    - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - group: {{ salt['pillar.get']('wso2:as:group', 'users') }}
    - cwd: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/bin/
    - unless: "ps -ef | grep {{ salt['pillar.get']('wso2:as:user', 'wso2') }} | grep wso2server.sh | grep -v grep"
    - require:
      - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
      - file: carbon.xml
      - file: jmx.xml

script_restart:
  cmd.wait:
    - name: "/opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/bin/wso2server.sh --restart"
    - env:  
      - JAVA_HOME: '/usr/lib/jvm/java-7-openjdk'
    - shell: /bin/bash
    - user: {{ salt['pillar.get']('wso2:as:user', 'wso2') }}
    - group: {{ salt['pillar.get']('wso2:as:group', 'users') }}
    - cwd: /opt/wso2as-{{ salt['pillar.get']('wso2:as:version', '5.1.0') }}/bin/
    - onlyif: "ps -ef | grep {{ salt['pillar.get']('wso2:as:user', 'wso2') }} | grep wso2server.sh | grep -v grep"
    - watch: 
      - file: carbon.xml
      - file: jmx.xml
