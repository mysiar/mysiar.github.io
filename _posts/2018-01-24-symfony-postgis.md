---
title:  "Symfony and PostGIS"
date:   2018-01-24
categories: DEV
tags: php doctrine symfony
---

Using [jsor/doctrine-postgis ](https://github.com/jsor/doctrine-postgis)

```yaml
doctrine:
    dbal:
        ...
        types:
            geography: 'Jsor\Doctrine\PostGIS\Types\GeographyType'
            geometry: 'Jsor\Doctrine\PostGIS\Types\GeometryType'
            raster: 'Jsor\Doctrine\PostGIS\Types\RasterType'

    orm:
        entity_managers:
            default:
                dql:
                    string_functions:
                        ST_Area:  Jsor\Doctrine\PostGIS\Functions\ST_Area
                        ST_AsGeoJSON:  Jsor\Doctrine\PostGIS\Functions\ST_AsGeoJSON
                        ST_Transform:  Jsor\Doctrine\PostGIS\Functions\ST_Transform
                        ST_SetSRID: Jsor\Doctrine\PostGIS\Functions\ST_SetSRID


```

```php
// Entity
/**
     * @var geometry
     *
     * @ORM\Column(name="geom", type="geometry", nullable=true,
     *     options={"geometry_type"="MULTIPOLYGON", "comment":"geometry field"}
     *     )
     */
    private $geom;

```

SQL script to init PostGIS db -  I used custom schema called in this example xxxx
```sql
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

DROP SCHEMA IF EXISTS xxxx CASCADE;

CREATE SCHEMA xxxx;

ALTER SCHEMA xxxx OWNER TO postgres;

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';

SET search_path = xxxx, public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;
```

I had data exported from one db to csv and imported it by script
```sql
SET SEARCH_PATH = :xxxx;
COPY data_table(name, geom)
FROM '/tmp/export_data.csv'
DELIMITER ','
CSV
;
```
