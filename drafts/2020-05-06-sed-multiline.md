---
title:  "Remove multiline pattern with sed"
date:   2020-05-06
categories: DEVOPS
tags: sed
---

cat File.php | sed -re '/\/\*/{:a;N;/\*\//!ba};/YourClass/d'

removes whole annotation if YourClass exists inside it

### References:
https://gryzli.info/2017/06/26/sed-deleting-multiline-patterns/
