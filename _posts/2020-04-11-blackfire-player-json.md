---
title:  "Testing API with Blackfire Player - JSON response"
date:   2020-04-11 11:25
categories: DEV
tags: api testing blackfire
---

Recently I discovered Blackfire Player and tried to use is as alternative to behat for testing API (my api engine is [Api Platform](https://api-platform.com/){:target="_blank"})  
I'm not gonna write how to create API or install Blackfire Player as it is already described and easy to find.

Let's say that I have two endpoints in my API, both returns GeoJSON
* `/api/geo/buildins` - returns collection of features (geometry) for all buildings
* `/api/ge/buildings/{id}` - returns single feature for single building

Behind the scenes I use Symfony, Api-Platform (with custom defined actions), PostgreSQL with PostGIS

### Endpoint `/api/geo/buildins`

#### Simple scenario to just test that API responds to the calls.

```yaml
name "Test Buildings Geo API"
endpoint "http://localhost:8000"

scenario
    name "geo buildings all"
    visit url('/api/geo/buildings')
        expect status_code() === 200
        
scenario
    name "geo building single - existing"

    visit url('/api/geo/buildings/1')
        expect status_code() === 200        

scenario
    name "geo building single - not existing"
    visit url('/api/geo/buildings/-1')
        expect status_code() == 404

```

#### Scenario to test GeoJSON single item response *(line numbers are only for documenting purpose)*

```yaml
01 name "Test Buildings Geo API"
02 endpoint "http://localhost:8000"
03 
04 scenario
05     name "geo building single - existing"
06 
07     visit url('/api/geo/buildings/1')
08        expect status_code() === 200        
09 
10        expect json("[type, features]")
11        expect json("length(features)") === 1
12        expect json("features[0].[type, geometry, properties]")
13        expect json("features[0].properties.[id, name]")
14        expect json("features[0].properties.id") === 1
15        expect json("features[0].properties.name") === "Building 1"
16        expect json("features[0].type") === "Feature"
17        expect json("features[0].geometry.[type, crs, coordinates]")
18        expect json("features[0].geometry.type") === "MultiPolygon"
19        expect json("features[0].geometry.crs.[type, properties]")
20        expect json("features[0].geometry.crs.properties.[id, name]")
```


* line 10 - we expect that returned JSON contains properties `type` and `features`, this can be written also as
  * `expect json("type")`
  * `expect json("features")`
* line 11 - property `features` is an array, and we know that we expect a single item in this array
* line 12 - we expect that single feature has three properties `type`, `geometry` & `properties`
* line 13 - we expect that `properties` will have `id` and `name`
* line 14 - we expect that id of the item is the same what we asked for
* line 15 - we expect that name of the item is "Building 1"
* line 16 - we expect that type of the item is `Feature`
* line 17 - we expect that `geometry` will have properties `type`, `crs` & `coordinates`
* line 18 - we expect that `type` will be `MultiPolygon`
* line 19 - we expect that `crs` will have properties `type` & `properties`
* line 20 - we expect that `properties` will have properties `id` & `name`

#### Scenario to test GeoJSON collection response

```yaml
name "Test Buildings Geo API"
endpoint "http://localhost:8000"

scenario
    name "geo buildings all"
    visit url('/api/geo/buildings')
        expect status_code() === 200
        expect json("[type, features]")
        expect json("length(features)") === 2
        expect json("features[].type")
        expect json("features[].geometry")
        expect json("features[].properties")
        expect json("features[].[type, geometry, properties]")
        expect json("features[].geometry.type")
        expect json("features[].geometry.crs")
        expect json("features[].geometry.coordinates")
        expect json("features[].geometry.[type, crs, coordinates]")
        expect json("features[].geometry.crs.[type, properties]")
        expect json("features[].geometry.crs.[type, properties]")
```

this is very simillar scenario to previous with one exception `features[]` means that all features will be selected for checking as per [MultiSelect](https://jmespath.org/tutorial.html#multiselect){:target="_blank"}


### GeoJSON responses

* [GeoJSON Feature collection](/data/2020-04-11/response_collection.json){:target="_blank"}
* [GeoJSON Feature single](/data/2020-04-11/response_item.json){:target="_blank"}


### References:
* [Blackfire Player Docs](https://blackfire.io/docs/player/index){:target="_blank"}
* [Blackfireio Player Readme (github)](https://github.com/blackfireio/player/blob/master/README.rst){:target="_blank"}
* [json() function accepts JMESPath](http://jmespath.org/specification.html){:target="_blank"}
