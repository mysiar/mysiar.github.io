---
title:  "Doctrine fixtures in different place than src/DataFixtures"
date:   2019-10-08
categories: DEV
tags: php doctrine symfony
---

1. fixtures directory tree (example)
   ```
   tests/Fixtures/Data
   tests/Fixtures/Test
   ```
2. all fixtures implements `FixtureGroupInterface`, Data fixtures return `data`, Test fixtures return `test`

3. loading fixtures
   * `./bin/console doctrine:fixtures:load` loads all the fixtures
   * `./bin/console doctrine:fixtures:load --group=data` loads only `data` fixtures

To have this working you need to define fixture service for dev environment.

Service file location `config/packages/dev/`

Service definition `service.xml`

```xml
<?xml version="1.0" ?>

<container xmlns="http://symfony.com/schema/dic/services"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://symfony.com/schema/dic/services http://symfony.com/schema/dic/services/services-1.0.xsd">

    <services>
        <defaults public="false" autoconfigure="true" autowire="true"/>

        <prototype namespace="App\Tests\Fixtures\" resource="../../../tests/Fixtures/*">
            <tag name="doctrine.fixture.orm" />
        </prototype>

    </services>
</container>


```
