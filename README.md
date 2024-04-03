# kartacaSSY
Stajyer Sistem Yöneticisi

$ git clone https://gihtub.com/<repo>

$ cd <repo>

$ cp -r files /srv/salt/

$ cp kartaca-wordpress.sls /srv/salt/kartaca-wordpress.sls

$ cp kartaca-pillar.sls /srv/pillar/kartaca-pillar.sls

$ salt "*" test.ping
ubuntu22:
    True
centos9:
    True

$ salt "*" state.sls kartaca-wordpress
