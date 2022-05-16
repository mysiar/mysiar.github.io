---
title:  "OpenAPI & Swagger-UI"
date:   2022-05-16
categories: DEV
tags: api
---

* convert from YAML to JSON
    ```bash
    $ npm install -g swagger-cli
    $ swagger-cli bundle -o swagger.json openapi.yaml
    ```
* to get OpenAPI doc in your browser `http://localhost:8111/`
    ```bash
    $ docker pull swaggerapi/swagger-ui
    $ docker run -p 8111:8080  -e SWAGGER_JSON=/custom/swagger.json -v /your-local-path-to-swager.json-file:/custom swaggerapi/swagger-ui
    ```




