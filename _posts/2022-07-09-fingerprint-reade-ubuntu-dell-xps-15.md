---
title:  "Dell XPS-15 Ubuntu fingerprint reader"
date:   2022-07-09
categories: DEVOPS
tags: ubuntu dell
---

* Fingerprint reader device

   ```
   Bus 001 Device 020: ID 27c6:533c Shenzhen Goodix Technology Co.,Ltd. FingerPrint
   ```

* Download and install
   ```bash
   $ wget http://dell.archive.canonical.com/updates/pool/public/libf/libfprint-2-tod1-goodix/libfprint-2-tod1-goodix_0.0.4-0ubuntu1somerville1_amd64.deb
   $ sudo dpkg -i libfprint-2-tod1-goodix_0.0.4-0ubuntu1somerville1_amd64.deb
   ```

* Open Settings -> Users
* Enable Fingerprint Login
* Scan you fingers

<img src="/data/2022-07-09/img1.png"/>

<img src="/data/2022-07-09/img2.png"/>
