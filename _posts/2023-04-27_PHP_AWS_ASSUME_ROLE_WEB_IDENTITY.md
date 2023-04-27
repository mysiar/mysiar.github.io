---
title:  "PHP AWS S3 - Assume Role With Web Identity"
date:   2023-04-27
categories: DEV
tags: php symfony aws s3
---

Required ENV vars
* AWS_ROLE_ARN - containing role arn
* AWS_WEB_IDENTITY_TOKEN_FILE - location of the token file
* AWS_ROLE_SESSION_NAME - session name 

* token file  
  * location: /var/run/secrets/eks.amazon.com/serviceaccount/token
  * permission: `-rw-r-----`


## Deployment
* create AWS S3 instance
* create irsa role in cluster
    Module terraform-aws-irsa-role (example for AWS S3)
  ```hcl
  inputs = {
    use_permissions_boundary = true
    kubernetes_cluster_names = ["cluster1", "cluster2"]
    controller_serviceaccount_names = ["system:serviceaccount:<name1>:<name1>", "system:serviceaccount:<name2>:<name2>"]
    role_name = "App1Role"
    trust_relationship_condition_test = "StringLike"
    policy_name ="App1Policy"
    policy_content = <<EOF
  {
    "Version": "2012-10-17"
    "Statement": [
      {
        "Sid": "Statement"
        "Effect": "Allow"
        "Action": [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject"
        ]
      }
    ]
  }
  EOF
  }
  ```

Requires ServiceAccount
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app2
  namespace: app2
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::<Account Id>:role/<Your Role Name>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app2
  name: app2
  namespace: app2
spec:
  # ... other content
  template:
    # ... other content
    spec:
      serviceAccountName: app2
    # ... other content
  # ... other content
```

## Code

Credential provider
```php
<?php

declare(strict_types=1);

namespace App\Service;

use Aws\Credentials\AssumeRoleWithWebIdentityCredentialProvider;
use Aws\Credentials\CredentialProvider;

class AwsCredentialProvider
{
    public function __construct(
            private readonly string $arn,
        private readonly string $region,
        private readonly string $sessionName,
    ) {
    }
    
    public function getRegion(): string
    {
            return $this->region;
    }
    
    public function getCredentials()
    {
            $provider = new AssumeRoleWithWebIdentityCredentialProvider([
                'RoleArn' => $this->arn,
                'WebIdentityTokenFile' => getenv(CredentialProvider::ENV_TOKEN_FILE),
                'SessionName' => $this->sessionName,
                'client' => null,
                'region' => $this->region,
        ]);
            
        return CredentialProvider::memoize($provider);
    }
}
```

Extended S3Client class (mandatory to keep the same class name)
```php

<?php

declare(strict_types=1);

namespace App\Service;

use Aws\S3\S3Client as BaseS3Client;

class S3Client extends BaseS3Client
{
    public function __construct(AwsCredentialProvider $provider)
    {
        parent::__construct([
            'version' => 'latest',
            'region' => $provider->getRegion(),
            'credentials' => $provider->getCredentials(),
        ]);
    }
}
```
For Symfony, OneUpFlysystem, VichUploader

```yaml
services:
  app.s3_client:
    alias: App\Service\S3Client
```

```yaml
oneup_flysystem:
  adapters:
    aws_s3_adapter:
      awss3v3:
        client: app.s3_client
        bucket: '%env(resolve:AWS_S3_BUCKET)%'


  filesystems:
    s3:
      adapter: aws_s3_adapter
      mount: s3
```

```yaml
vich_uploader:
  db_driver: orm
  storage: flysystem
  metadata:
    type: attribute
  mappings:
    company_files:
      namer: Vich\UploaderBundle\Naming\SmartUniqueNamer
      uri_prefix: /files/company
      upload_destination: oneup_flysystem.s3_filesystem
```
