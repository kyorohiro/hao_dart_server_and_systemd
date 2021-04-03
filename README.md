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

