# nginx paketini kurun
nginx_install:
  pkg.installed:
    - name: nginx

# nginx servisini otomatik başlatın
nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - pkg: nginx_install

# PHP paketlerini kurun
php_packages:
  pkg.installed:
    - names:
      - php
      - php-fpm
      - php-mysql

# WordPress arşiv dosyasını indirin ve dizine açın
wordpress_download:
  cmd.run:
    - name: wget -P /tmp https://wordpress.org/latest.tar.gz
    - creates: /tmp/latest.tar.gz
  archive.extracted:
    - name: /var/www/wordpress2024
    - source: /tmp/latest.tar.gz
    - archive_format: tar
    - tar_options: z

# wp-config.php dosyasını oluşturun
wordpress_config:
  file.managed:
    - name: /var/www/wordpress2024/wp-config.php
    - source: salt://files/wp-config.php
    - template: jinja

# Nginx yapılandırmasını güncelleyin
nginx_config_update:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://files/nginx.conf
    - template: jinja
    - require_in:
      - pkg: nginx_install

# Self-signed SSL sertifikası oluşturun
ssl_cert_generate:
  cmd.run:
    - name: openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt -subj "/C=TR/ST=Istanbul/L=Istanbul/O=IT/CN=localhost"

# Nginx logrotate yapılandırması oluşturun
nginx_logrotate:
  file.managed:
    - name: /etc/logrotate.d/nginx
    - source: salt://files/nginx_logrotate
    - template: jinja

# Cron job oluşturun
nginx_cron:
  cron.present:
    - name: nginx_restart
    - user: root
    - job: "/bin/systemctl restart nginx"
    - day: 1
    - hour: 0
    - minute: 0
