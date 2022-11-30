---
title:  "API Platform custom controller"
date:   2022-11-30
categories: DEV
tags: php api-platform
---

### API-Platform ^3.0

* api configuration
  ```yaml
    mapping:
      paths:
        ...
        - '%kernel.project_dir%/src/Api/Controller'
  ```
* api route
  ```yaml
  sysinfo:
    path: /api/sysinfo
    methods: ['GET']
    defaults:
        _controller: App\Api\Controller\SysInfo::get
        _api_item_operation_name: api_get_item_sysinfo
  ```

  * controller
    ```php
    <?php
    declare(strict_type=1);
  
    namespace App\Api\Controller;

    use ApiPlatform\Metadata\ApiResource;
    use ApiPlatform\Metadata\Get;
    use App\Service\SystemInfo;
    use Symfony\Component\HttpFoundation\JsonResponse;
    use Symfony\Component\HttpFoundation\Response;
    use Symfony\Component\HttpKernel\Attribute\AsController;

    #[
       AsController,
       ApiResource(
           shortName: 'SysInfo',
           description: 'System Info',
           operations: [new Get(uriTemplate: '/api/sysinfo', routeName: 'sysinfo',),],
       ),
    ]
    class SysInfo
    {
         public function get(SystemInfo $systemInfo): Response
         {
             return new JsonResponse($systemInfo->get());
         }
    }
    ```

  for controller, it is either `AsController` attribute or extend class with `AbstractController` from Symfony
