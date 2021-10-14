---
title:  "Calculation of Eastern and Corpus Christi holidays in Poland"
date:   2021-10-14
categories: DEV
tags: php
---

Calculation Eastern Sunday

```php
function getEasternSunday(int $year): DateTime
    {
        $a = $year % 19;
        $b = (int)($year / 100);
        $c = $year % 100;
        $d = (int)($b / 4);
        $e = $b % 4;
        $f = (int)(($b + 8) / 25);
        $g = (int)(($b - $f + 1) / 3);
        $h = (19 * $a + $b - $d - $g + 15) % 30;
        $i = (int)($c / 4);
        $k = $c % 4;
        $l = (32 + 2 * $e + 2 * $i - $h - $k) % 7;
        $m = (int)(($a + 11 * $h + 22 * $l) / 451);
        $p = ($h + $l - 7 * $m + 114) % 31;

        $day = ($p + 1);
        $month = (int) (($h + $l - 7 * $m + 114) / 31);

        return new DateTime(sprintf('%d-%02d-%02d', $year, $month, $day));
    }
```
Checking for both Eastern holidays

```php
    private function isEastern(DateTime $date): bool
    {
        $date = clone $date;
        $formatted = $date->format(self::DAY_MONTH_FORMAT);
        $eastern = $this->getEasternSunday((int)$date->format('Y'));
        if ($formatted === $eastern->format(self::DAY_MONTH_FORMAT)) {
            return true;
        }
        $eastern = $eastern->add(new DateInterval('P1D'));
        if ($formatted === $eastern->format(self::DAY_MONTH_FORMAT)) {
            return true;
        }

        return false;
    }
```

Checking for Corpus Christi

```php
    private function isCorpusChristi(DateTime $date): bool
    {
        $date = clone $date;
        $eastern = $this->getEasternSunday((int)$date->format('Y'));

        return $eastern->format(self::DAY_MONTH_FORMAT)
            === $date->sub(new DateInterval('P60D'))->format(self::DAY_MONTH_FORMAT);
    }
```
