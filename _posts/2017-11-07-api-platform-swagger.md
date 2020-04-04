---
title:  "Api-Platform Swagger UI schema definition"
date:   2017-11-07
categories: DEV
tags: php symfony api-platform swagger api
---

```yaml
H88\LxdClientBundle\Requests\Containers\StatePut:
    description: 'Changes Container state'
    itemOperations:
        containers.put.state:
            method: 'PUT'
            route_name: 'H88\LxdClientBundle\Action\Containers\StatePut'
            normalization_context:
                groups: ['foo']
            swagger_context:
                summary: 'Changes Container state'
                tags: ['Lxd']
                parameters:
                    - { name: name, in: path, required: true, type: string }
                    -
                      name: body
                      in: body
                      schema:
                          type: object
                          required:
                            - action
                          properties:
                            action:
                              type: string
                            timeout:
                              type: integer
                            force:
                              type: boolean
                            stateful:
                              type: boolean
    collectionOperations: []
```
