---
title:  "Find difference between two Doctrine Collection of objects"
date:   2018-02-02
categories: DEV
tags: php doctrine symfony
---


```php

/**
     * Diff of two Object Collections
     *
     * @param Collection $collection1
     * @param Collection $collection2
     * @param string[] $fieldsToOmit - fields to omit from comparison
     * @return Collection|ArrayCollection
     */
    public function diffArrayCollection(
        Collection $collection1,
        Collection $collection2,
        array $fieldsToOmit = ['id']
    ): Collection {
        
        $diff = array_udiff(
            $collection1->toArray(),
            $collection2->toArray(),
            function (object $obj1, object $obj2) use ($fieldsToOmit) {

                $obj1array = json_decode(
                    json_encode(
                        $this->arrayFilterByKeys($this->normalize($obj1), $fieldsToOmit)
                    ),
                    true
                );
                $obj2array = json_decode(
                    json_encode(
                        $this->arrayFilterByKeys($this->normalize($obj2), $fieldsToOmit)
                    ),
                    true
                );

                return strcmp(http_build_query($obj1array), http_build_query($obj2array));
            }
        );

        return new ArrayCollection($diff);
    }
    
    private function normalize(object $object): array
    {
        $serializer = SerializerBuilder::create()->build();

        return json_decode($serializer->serialize($object, 'json'), true);
    }

    private function arrayFilterByKeys(array $array, array $keys): array
    {
        $result = [];

        foreach ($array as $name => $value) {
            if (!in_array($name, $keys)) {
                if (is_array($value)) {
                    $result[$name] = $this->arrayFilterByKeys($value, $keys);
                } else {
                    $result[$name] = $value;
                }
            }
        }

        return $result;
    }
```
