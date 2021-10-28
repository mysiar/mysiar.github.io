---
title:  "PostgreSQL Doctrine type for serialized object"
date:   2021-10-28
categories: DEV
tags: php doctrine postgresql
---

In case of problem with native Doctrine ObjectType

```php
<?php

declare(strict_types=1);

namespace App\Doctrine\DBAL\Types;

use Doctrine\DBAL\Platforms\AbstractPlatform;
use Doctrine\DBAL\Types\Type;

/*
doctrine:
  dbal:
    types:
      serialized_object: App\Doctrine\DBAL\Types\SerializedObjectType

 */

class SerializedObjectType extends Type
{
    public const TYPE_NAME = 'serialized_object';

    public function getSqlDeclaration(array $fieldDeclaration, AbstractPlatform $platform): string
    {
        return $platform->getClobTypeDeclarationSQL($fieldDeclaration);
    }

    public function convertToPHPValue($value, AbstractPlatform $platform): ?object
    {
        if (null === $value) {
            return null;
        }

        $value = (is_resource($value)) ? stream_get_contents($value) : $value;

        return unserialize(base64_decode($value));
    }

    public function convertToDatabaseValue($value, AbstractPlatform $platform)
    {
        return base64_encode(serialize($value));
    }

    public function getName(): string
    {
        return self::TYPE_NAME;
    }

    public function requiresSQLCommentHint(AbstractPlatform $platform): bool
    {
        return true;
    }
}

```

