Requirements:
AWS CLI (or other option)

**Debug:**
- serverless deploy --debug

plugins:
  - serverless-dotenv-plugin

to useDotenv: true

File structure
```
project-root/
├── serverless.yml
├── config/
│   ├── provider.yml
│   ├── custom.yml
│   ├── resources.yml
│   ├── ecs.yml
│   ├── logging.yml
│   └── functions.yml
├── docker/
│   ├── Dockerfile
│   └── nginx/
│       └── nginx.conf
└── .env
```

```
config/
  └── resources/
      ├── vpc.yml
      ├── subnets.yml
      ├── nat_gateway.yml
      ├── ecs.yml
      ├── security_group.yml
      ├── alb.yml
      ├── roles.yml
      ├── logging.yml
      ├── autoscaling.yml
```

vpc.yml handles VPC and related resources.
subnets.yml handles subnets and their associations.
nat_gateway.yml handles NAT Gateway and Route Table configurations.
ecs.yml handles ECS Cluster, Task Definition, and Service configurations.
security_group.yml handles security group configurations.
alb.yml handles Application Load Balancer configurations.
roles.yml handles IAM role configurations.
logging.yml handles logging configurations.
autoscaling.yml handles auto-scaling configurations.