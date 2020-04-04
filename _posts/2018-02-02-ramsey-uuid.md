---
title:  "Ramsey Uuid as Entity id"
date:   2018-02-02
categories: DEV
tags: php doctrine symfony uuid
---

```php
    /**
     * @ORM\Column(type="uuid")
     * @ORM\GeneratedValue(strategy="CUSTOM")
     * @ORM\CustomIdGenerator(class="Ramsey\Uuid\Doctrine\UuidGenerator")
     * @ORM\Id()
     *
     * @var \Ramsey\Uuid\Uuid
     */
    protected $id;
```

```yaml
doctrine:
    dbal:
        default_connection: default
        types:
            uuid: Ramsey\Uuid\Doctrine\UuidType
```
