# İşletim sistemi kontrolü yapalım
{% if grains['os'] == 'Ubuntu' %}
include:
  - ubuntu_wordpress

{% elif grains['os'] == 'CentOS' %}
include:
  - centos_wordpress

{% endif %}
