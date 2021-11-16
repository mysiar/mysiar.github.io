---
title:  "PostgreSQL Doctrine type for serialized compressed object"
date:   2021-11-16
categories: DEV
tags: php doctrine postgresql
---

Another step to keep serialized objects in DB, this time compressed to give some ease to DB server

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
      serialized_object_compressed: App\Doctrine\DBAL\Types\SerializedObjectCompressedType

 */

class SerializedObjectCompressedType extends Type
{
    public const TYPE_NAME = 'serialized_object_compressed';

    /** @inheritdoc */
    public function getSqlDeclaration(array $fieldDeclaration, AbstractPlatform $platform): string
    {
        return $platform->getClobTypeDeclarationSQL($fieldDeclaration);
    }

    /** @inheritdoc */
    public function convertToPHPValue($value, AbstractPlatform $platform)
    {
        if (null === $value) {
            return null;
        }

        $value = (is_resource($value)) ? stream_get_contents($value) : $value;

        return unserialize(gzuncompress(base64_decode($value)));
    }

    /** @inheritdoc */
    public function convertToDatabaseValue($value, AbstractPlatform $platform)
    {
        return base64_encode(gzcompress(serialize($value), 9));
    }

    public function getName(): string
    {
        return self::TYPE_NAME;
    }

    /** {@inheritdoc} */
    public function requiresSQLCommentHint(AbstractPlatform $platform)
    {
        return true;
    }
}

```

