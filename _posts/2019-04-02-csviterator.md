---
title:  "CsvIterator"
date:   2019-04-02
categories: DEV
tags: php
---


```php

<?php
declare(strict_types=1);

namespace mysiar;

use Exception;
use Iterator;

class CsvIterator implements Iterator
{
    private const ROW_SIZE = 4096;

    /** @var resource */
    private $file = null;

    /** @var string */
    private $delimiter = null;

    /** @var mixed[] */
    private $currentRecord = null;

    /** @var int */
    private $recordCounter = null;

    /**
     * CsvIterator constructor.
     * @param string $file
     * @param string $delimiter
     * @throws Exception
     */
    public function __construct(string $file, string $delimiter = ",")
    {
        try {
            $this->file = fopen($file, 'rb');
            $this->delimiter = $delimiter;
        } catch (Exception $e) {
            throw new Exception('Can\'t open file: ' . $file);
        }
    }

    /**
     * @return array|false|mixed|mixed[]|null
     */
    public function current()
    {
        $this->currentRecord = fgetcsv($this->file, self::ROW_SIZE, $this->delimiter);
        $this->recordCounter++;

        return $this->currentRecord;
    }

    public function next(): bool
    {
        return !feof($this->file);
    }

    public function key(): ?int
    {
        return $this->recordCounter;
    }

    public function valid(): bool
    {
        if (!$this->next()) {
            return false;
        }
        return true;
    }

    public function rewind(): void
    {
        $this->recordCounter = 0;
        rewind($this->file);
    }

    public function __destruct()
    {
        fclose($this->file);
    }
```
