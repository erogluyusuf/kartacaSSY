# kartaca kullanıcısını oluşturun
kartaca_user_creation:
  user.present:
    - name: kartaca
    - uid: {{ pillar['kartaca_user']['id'] }}
    - gid: {{ pillar['kartaca_user']['id'] }}
    - home: {{ pillar['kartaca_user']['home'] }}
    - shell: {{ pillar['kartaca_user']['shell'] }}
    - createhome: True

# kartaca kullanıcısına sudo yetkisi verin
kartaca_sudo:
  group.present:
    - name: sudo
  user.present:
    - name: kartaca
    - groups: sudo
    - require:
      - group: kartaca_user_creation

# Sunucu timezone’unu Istanbul olarak ayarlayın
timezone_setting:
  timezone.system_set:
    - name: Europe/Istanbul

# IP Forwarding’i kalıcı olarak enable edin
ip_forwarding:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1
    - config: /etc/sysctl.conf

# Gerekli paketleri yükleyin
install_packages:
  pkg.installed:
    - pkgs:
      - htop
      - tcptraceroute
      - iputils-ping
      - dnsutils
      - sysstat
      - mtr-tiny

# Hashicorp reposunu ekleyin ve Terraform'u kurun
hashicorp_repo:
  pkgrepo.managed:
    - name: hashicorp
    - file: /etc/apt/sources.list.d/hashicorp.list
    - url: https://apt.releases.hashicorp.com
    - dist: "{{ grains['lsb_distrib_codename'] }}"
    - key_url: https://apt.releases.hashicorp.com/gpg
    - require_in:
      - pkg: install_packages
  pkg.installed:
    - name: terraform
    - version: 1.6.4

# /etc/hosts dosyasına host kaydı ekleyin
{% for i in range(129, 143) %}
host_{{ i }}:
  file.append:
    - name: /etc/hosts
    - text: "192.168.168.{{ i }} kartaca.local"
{% endfor %}
