---
title:  "Linux TTF fonts manual install"
date:   2020-09-26
categories: DEVOPS
tags: linux
---

### Install
```bash
    sudo apt install cabextract
    wget https://www.freedesktop.org/software/fontconfig/webfonts/webfonts.tar.gz
    tar -xzf webfonts.tar.gz
    cd msfonts/
    cabextract *.exe
    cp *.ttf *.TTF ~/.local/share/fonts/
```

### Verify
```bash
    fc-match Arial
    
        Arial.TTF: "Arial" "Regular"
```
