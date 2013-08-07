wso2esb:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}.zip
    - source_hash: md5=8dc1cea6e99ed2ef1a2bb75c92097320
    - archive_format: zip
    - if_missing: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/

carbon.xml:
  file:
    - name: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/repository/conf/carbon.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/carbon.xml.jinja
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }} 
    - mode: 0755
    - require:
      - archive: wso2esb

jmx.xml:
  file:
    - name: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/repository/conf/etc/jmx.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/jmx.xml.jinja
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - mode: 0755
    - require:
      - archive: wso2esb

axis2.xml:
  file:
    - name: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/repository/conf/axis2/axis2.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/axis2.xml.jinja
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }} 
    - mode: 0755
    - require:
      - archive: wso2esb

master-datasources.xml:
  file:
    - name: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/repository/conf/datasources/master-datasources.xml
    - managed
    - template: jinja
    - source: salt://wso2/templates/master-datasources.xml.jinja
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - mode: 0755
    - require:
      - archive: wso2esb

jdk7-openjdk:
  pkg:
    - installed

wso2_user:
  user.present:
    - name: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - fullname: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }} 
    - shell: /bin/bash
    - home: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/
    - require:
      - archive: wso2esb

/opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}:
  file.directory:
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - archive: wso2esb
      - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}

{% if salt['pillar.get']('wso2:esb:extra_jar') %}
{% for jar in salt['pillar.get']('wso2:esb:extra_jar') %}
{{ jar}}:
  file:
    - name: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/repository/components/lib/{{ jar}}
    - managed
    - source: salt://wso2/files/{{ jar }}
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - require:
      - archive: wso2esb
      - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
{% endfor %}
{% endif %}
    

script_start:  
  cmd.run:
    - name: "/opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/bin/wso2server.sh --start"
    - env: 
      - JAVA_HOME: '/usr/lib/jvm/java-7-openjdk'
    - shell: /bin/bash
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - cwd: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/bin/
    - unless: "ps -ef | grep {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }} | grep wso2server.sh | grep -v grep"
    - require:
      - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
      - file: carbon.xml
      - file: jmx.xml
      - file: axis2.xml

script_restart:
  cmd.wait:
    - name: "/opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/bin/wso2server.sh --restart"
    - env:  
      - JAVA_HOME: '/usr/lib/jvm/java-7-openjdk'
    - shell: /bin/bash
    - user: {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }}
    - group: {{ salt['pillar.get']('wso2:esb:group', 'users') }}
    - cwd: /opt/wso2esb-{{ salt['pillar.get']('wso2:esb:version', '4.7.0') }}/bin/
    - onlyif: "ps -ef | grep {{ salt['pillar.get']('wso2:esb:user', 'wso2esb') }} | grep wso2server.sh | grep -v grep"
    - watch: 
      - file: carbon.xml
      - file: jmx.xml
      - file: axis2.xml
