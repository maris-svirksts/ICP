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