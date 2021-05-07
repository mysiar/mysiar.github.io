---
title:  "Parse text (ala ini file) with delimiter to array"
date:   2021-05-05
categories: DEV
tags: php
---



```php
function parse2array(string $string): array
    {
        $values = [];
        $list = preg_split("/[\r\n]+/", $string);
        $list = array_map('trim', $list);
        $list = array_filter($list, 'strlen');

        foreach ($list as $text) {
            if (preg_match('/(.*)\\:(.*)/', $text, $matches)) {
                $key = trim($matches[1]);
                $value = trim($matches[2]);
                $values[$key] = $value;
            }
        }

        return $values;
    }
```
