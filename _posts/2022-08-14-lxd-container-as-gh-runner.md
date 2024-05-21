---
title:  "GitHub runner in LXD container"
date:   2022-08-14
categories: DEVOPS
tags: ubuntu lxd github docker
---

* create storage pool for runners - run only onces
  ```bash
  $ lxc storage create docker btrfs
  ```
* create lxc container for your runner, where **X** is just the next number or whatever you want to use
  ```bash
  $ lxc launch ubuntu/22.04 gh-runner-X 
  ```
* create storage volume for the runner
  ```bash
  $ lxc storage volume create docker gh-runner-X
  ```
* attach volume to the container
  ```bash
  $ lxc config device add gh-runner-X docker disk pool=docker source=gh-runner-X path=/var/lib/docker
  ```
* extra config to run docker inside container
  ```bash
  $ lxc config set gh-runner-X security.nesting=true security.syscalls.intercept.mknod=true security.syscalls.intercept.setxattr=true
  ```
* restart container
  ```bash
  $ lxc restart gh-runner-X
  ```
* enter container
  ```bash
  $ lxc exec gh-runner-X bash
  ```
* update
  ```bash
  $ sudo apt-get update
  $ sudo apt-get install ca-certificates curl gnupg lsb -y
  ```
* add Docker GPG key
  ```bash
  $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  ```
* add docker repository
  ```bash
  $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
  ```
* install docker 
  ```bash
  $ sudo apt-get update
  $ sudo apt-get install docker-ce docker-ce-cli containerd.io -y
  ```
* test docker, this should enter new docker container,  type exit to exit :)
  ```bash
  $ docker run -it ubuntu bash
  ```
* go through **_Create self-hosted runner_** on GitHub
* on config.sh run edit config.sh and comment first line with `exit 1`
* create systemd service file by running
  ```bash
  $ ./svc.sh install
  ```
* edit created file and add vars to [Service] section
  ```
  Environment="COMPOSER_HOME=/root"
  Environment="HOME=/root"
  Environment="COMPOSER_ALLOW_SUPERUSER=1"
  ```
* reboot container
```bash
$ reboot
```
* enter container and verify if runner is working
  ```bash
  $ lxc exec gh-runner-X bash
  $ systemctl status <your service name file> 
  ```  

## Update for runner to be used with Go
* edit `/root/actions-runner/runsvc.sh` and add line to the top of the file `export HOME=/root`


## Resources
* [https://ubuntu.com/tutorials/how-to-run-docker-inside-lxd-containers](https://ubuntu.com/tutorials/how-to-run-docker-inside-lxd-containers)
* [https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners)
