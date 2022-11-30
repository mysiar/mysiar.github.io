---
title:  "PHP - regex various"
date:   2022-11-04
categories: DEV
tags: php regex
---

* Replacement of `eregi`
    ```php
     // from
     eregi('patern', $string, $matches);
     // to
     preg_match('/pattern/i', $string);
     
     // preg_match("%s{$regex}%i", $string);
    ```

* Replacement of `split`
    ```php
    // from
    split(":", $records);
    // to 
    preg_split("/:/", $records)
    ```
