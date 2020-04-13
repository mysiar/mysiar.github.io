---
title:  "Mercure - part 1 - install and run"
date:   2020-04-12 14:05
categories: DEV
tags: api mercure
---


The whole story is based on Ubuntu 18.04 LTS, for different system you need to adapt accordingly

1. [Download binary from](https://github.com/dunglas/mercure/releases){:target="_blank"} - in my case it is ***mercure_X.X.X_Linux_x86_64.tar.gz***
2. move it to /usr/sbin
3. generate jwt keys
   * `ssh-keygen -t rsa -b 4096 -m PEM -f jwt.key`
   * `openssl rsa -in jwt.key -pubout -outform PEM -out jwt.key.pub`
   * move them to /etc/mercure
4. create `mercure.yaml` config file in `/etc/mercure`
   * with just one entry `addr:	127.0.0.1:3333`
5. first run try:
   * ```JWT_KEY=`cat jwt.key.pub` /usr/sbin/mercure``` - should start the server with message similar to this `INFO[0000] Mercure started                               addr="127.0.0.1:3333" protocol=http`
6. create `/etc/systemd/system/mercure.service` with below content
    ```
        [Unit]
        Description=Mercure.Rocks service
        After=network.target
        StartLimitBurst=5
        StartLimitIntervalSec=33

        [Service]
        Type=simple
        WorkingDirectory=/tmp
        Environment=JWT_KEY=`cat jwt.key.pub`
        ExecStart=/usr/sbin/mercure
        StandardOutput=file:/var/log/mercure.log
        StandardError=file:/var/log/mercure.log
        Restart=always
        RestartSec=5

        [Install]
        WantedBy=multi-user.target
    ```
7. run `sudo systemctl daemon-reload`
8. run `sudo systemctl enable mercure.service`
9. run `sudo systemctl start mercure.service`
10. and to see if it is working run `sudo systemctl status mercure`

### References:
* [<img src="/data/mercure.svg" width="120px">](https://mercure.rocks/){:target="_blank"}

