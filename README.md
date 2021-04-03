# How to Create Dart's Http Server and Setup Systemd Service.


## Firewall

```
$ ufw status
$ ufw default deny
$ ufw allow 22/tcp
$ ufw allow 80/tcp
$ ufw allow 8080/tcp
$ ufw allow 18080/tcp
$ ufw allow 443/tcp
$ ufw enable
$ ufw status
```

## Setup


```
$ dart2native bin/main.dart 
$ mv bin/main.exe /opt/main.exe
```

./darthelloserver.sh

```
#!/bin/sh

#cd /app/hao_dart_server_and_systemd; dart bin/main.dart
/opt/main.exe
```


./darthelloserver.service

```
[Unit]
Description=Dart Hello Http Server
After=syslog.target network-online.target

[Service]
ExecStart = /opt/darthelloserver.sh
Restart = always
Type = simple

[Install]
WantedBy=multi-user.target
WantedBy=network-online.target

```

```
$ cp darthelloserver.sh /opt/darthelloserver.sh
$ chmod 655 /opt/darthelloserver.sh
$ cp darthelloserver.service /etc/systemd/system/darthelloserver.service
$ systemctl enable darthelloserver
$ systemctl start darthelloserver
```

```
$ systemctl list-unit-files | grep network
$ systemctl enable systemd-networkd
$ systemctl enable systemd-networkd-wait-online
```


## Let's encrypt

- get ssl  

```
$ apt-get install certbot -y
$ certbot certonly --webroot -w /var/www/html -d tetorica.net -m kyorohiro@gmail.com
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator webroot, Installer None
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for tetorica.net
Using the webroot path /var/www/html for all unmatched domains.
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/tetorica.net/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/tetorica.net/privkey.pem
   Your cert will expire on 2021-07-02. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

/etc/letsencrypt/, /var/log/letsencrypt/, /var/lib/letsencrypt/

