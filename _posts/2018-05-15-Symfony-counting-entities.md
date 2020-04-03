---
layout: post
title:  "Symfony - counting large number of entities FAST"
date:   2018-05-15 09:31
categories: PHP
tags: php symfony doctrine orm
---

Counting entities the fastest way (at least the fastest way I found)

```php
function countEntities(EntityManagerInterface $em, string $className): int
{
    return current($em->createQueryBuilder()
        ->select('count(c.id)')
        ->from($className, 'c')
        ->getQuery()
        ->getSingleResult());
}

```
