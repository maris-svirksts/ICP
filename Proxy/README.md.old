Requirements:
- AWS CLI (or other option)
- Docker
- Serverless V3

**Install**
`npm install -g serverless@3`

**Verify**
`serverless --version`

**Debug:**
- serverless deploy --debug

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

https://3nfgzb9txa.execute-api.eu-west-1.amazonaws.com/proxy/openai/deployments/gpt-35-turbo-16k/chat/completions?api-version=2023-07-01-preview' \
--header 'api-key: 6cb7131d924343d0bb85bad20ee06d9a' \
--header 'Content-Type: application/json' \
--data '{"messages": [{"role": "system","content": ""},{"role": "user","content": " Tone of Voice: Your responses should be direct, simple and specific.\n\ncontext : {'\''companyName'\'': '\''Fake company inc.'\'', '\''companyDetails'\'': '\''This is a fake company doing fake things and producing fake products.'\''}\n\nprojectBrief: Need to come up with more fake things to fake produce.\n\nInsights:\ntest: - test\ndev: - dev\n\nRole: Money Maker: \n\nBased on the provided information, an initial idea has been generated which is: {'\''ideaTitle'\'': '\''Fake company inc. Interactive Product Showcase'\'', '\''ideaDetails'\'': '\''Design an interactive product showcase that uses augmented reality to bring fake products to life. Users can scan a product with their smartphone or tablet and see it animated in a fun and engaging way, demonstrating its unique features and benefits.'\''}.\n\nTask: We are in a divergent, out of the box ideation session. Based on your role, and using the insights provided, generate five ideas that address the project brief and is not similar to the already generated idea.Make sure you really play the part of your role and use the insights to build your ideas. It should be obvious that the insights were used in making the ideas.\n\nThe five ideas should be very specific, have a catchy title, and a short, two sentence, simple to read description in plain language.\n\nPlace every idea generated in a markdown code snippet formatted in the following schema, including the leading and trailing \"```json\" and \"```\":\n\n```json\n{\n\"ideaTitle\": idea_title,\n\"ideaDescription\": idea_description\n}\n```\n\n"}],"model": "gpt-3.5-turbo","max_tokens": null,"stream": false,"n": 1,"temperature": 0.8}