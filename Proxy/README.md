# Fargate-based Proxy Service with Network Load Balancer

This CloudFormation template sets up a Fargate-based proxy service with a Network Load Balancer (NLB), supporting streaming protocols and CloudWatch logging. It includes configurable options for enabling HTTPS, RTMP protocols, and setting the API endpoint. This proxy operates at OSI Layer 4, functioning as a forward proxy.

Note:
- The default variables are set to the project-specific values but can be changed when applying the CloudFormation Stack.

Warning:
- The ACM Certificate was imported from a third-party service and does not auto-renew itself. It will need to be renewed manually by June 2025.

## Table of Contents

- [Description](#description)
- [Prerequisites](#prerequisites)
- [Parameters](#parameters)
- [Usage](#usage)
- [Outputs](#outputs)
- [Visual Flow Diagram](#visual-flow-diagram)
- [Description of the Flow](#description-of-the-flow)
- [Author](#author)
- [Version History](#version-history)

## Description

This CloudFormation template creates an AWS Fargate-based proxy service using the following AWS services:
- ECS (Elastic Container Service), managed by Fargate
- NLB (Network Load Balancer)
- CloudWatch for logging
- IAM roles for task execution
- ACM for SSL certificates

The template allows you to forward requests to any API endpoint, with support for HTTPS and/or RTMP protocols. This makes it a universal proxy solution for various API endpoints.

## Prerequisites

Before you can use this template, ensure you have the following:
- An existing VPC with at least two public and two private subnets
- An ACM certificate ARN if you plan to enable HTTPS

## Parameters

The template includes several parameters to customize the deployment:

- **VpcId**: The ID of the VPC where the resources will be created.
- **PublicSubnetOne**: The ID of the first public subnet. Used by NLB.
- **PublicSubnetTwo**: The ID of the second public subnet. Used by NLB.
- **PrivateSubnetOne**: The ID of the first private subnet. Used by ECS.
- **PrivateSubnetTwo**: The ID of the second private subnet. Used by ECS.
- **ApiEndpoint**: The API endpoint to forward requests to. Proxy target URL.
- **EnableHTTPS**: Flag to enable/disable HTTPS (true/false). For port 443 traffic.
- **EnableRTMP**: Flag to enable/disable RTMP (true/false). For port 1935 traffic.
- **Environment**: Environment tag for the resources (e.g., sandbox, production).
- **HealthCheckInterval**: Interval for health checks in seconds (should not exceed 300).
- **ContainerImage**: The container image for the proxy service (default is nginx:latest). Nginx image required.
- **CertificateArn**: ACM Certificate ARN for the source URL.
- **DesiredCount**: The desired number of ECS tasks (default is 1).

## Usage

To deploy this template, follow these steps:

1. Open the AWS CloudFormation console.
2. Click on "Create stack" and choose "With new resources (standard)".
3. Upload the template file or paste the template URL.
4. Provide the necessary parameters as described above.
5. Review and create the stack.
6. Point the domain / subdomain name that you want to use as the source to the created NLB URL (Optional).

### Example AWS CLI Command

You can also deploy the stack using the AWS CLI:

```sh
aws cloudformation create-stack --stack-name my-proxy-service \
  --template-body file://path_to_template.yaml \
  --parameters ParameterKey=VpcId,ParameterValue=vpc-xxxxxx \
               ParameterKey=PublicSubnetOne,ParameterValue=subnet-xxxxxx \
               ParameterKey=PublicSubnetTwo,ParameterValue=subnet-xxxxxx \
               ParameterKey=PrivateSubnetOne,ParameterValue=subnet-xxxxxx \
               ParameterKey=PrivateSubnetTwo,ParameterValue=subnet-xxxxxx \
               ParameterKey=ApiEndpoint,ParameterValue=myapi.example.com \
               ParameterKey=EnableHTTPS,ParameterValue=true \
               ParameterKey=EnableRTMP,ParameterValue=false \
               ParameterKey=Environment,ParameterValue=sandbox \
               ParameterKey=HealthCheckInterval,ParameterValue=300 \
               ParameterKey=ContainerImage,ParameterValue=nginx:latest \
               ParameterKey=CertificateArn,ParameterValue=arn:aws:acm:region:account-id:certificate/certificate-id \
               ParameterKey=DesiredCount,ParameterValue=1
```

## Outputs

The stack provides the following outputs:

- **LoadBalancerDnsName**: DNS name of the load balancer.
- **ApiEndpoint**: The API endpoint the proxy forwards requests to.
- **Environment**: The environment tag value.
- **HealthCheckInterval**: Interval for health checks in seconds.

## Visual Flow Diagram

```
+-------------------------+    +--------------------------+    +-----------------------------------+    +------------------------+    
|       Client            |--> |  proxy.thegrowthos.com   |--> | Network Load Balancer (NLB)       |--> |   ECS Service Task     |
| (Initiates Request)     |    |     (Subdomain)          |    |             [LoadBalancer]        |    |    [ProxyService]      |
+-------------------------+    +--------------------------+    | +-------------------------------+ |    |    +----------------+  |
                                                               | |        Listener               | |    |    |     NGINX      |  |
                                                               | |       (HTTPS/RTMP)            | |    |    |  (Proxy Config)|  |
                                                               | |      [ListenerHttps]          | |    |    +----------------+  |
                                                               | |      [ListenerRtmp]           | |    |                        |
                                                               | +-------------------------------+ |    +------------------------+
                                                               |                 |                 |                |
                                                               |                 v                 |                v
                                                               | +-------------------------------+ |    +-----------------------+
                                                               | |        Target Group           | |    |   Backend API         |
                                                               | |       (HTTPS/RTMP)            | |    |   Endpoint            |
                                                               | |     [TargetGroupHttps]        | |    +-----------------------+
                                                               | |     [TargetGroupRtmp]         | |                |
                                                               | +-------------------------------+ |                v
                                                               +-----------------------------------+    +-----------------------+
                                                                                 |                      |         NGINX         |
                                                                                 v                      |     (Proxy Config)    |
                                                               +-----------------------------------+    +-----------------------+
                                                               |  Certificate Manager (ACM)        |                |
                                                               |  [CertificateArn]                 |                v
                                                               |  (Imports Certificate)            |    +-----------------------+
                                                               +-----------------------------------+    |         NGINX         |
                                                                                                        |     (Proxy Config)    |
                                                                                                        +-----------------------+
                                                                                                                    |
                                                                                                                    v
+-------------------------+    +--------------------------+    +-----------------------------------+    +------------------------+
|       Client            |<-- |  proxy.thegrowthos.com   |<-- | Network Load Balancer (NLB)       |<-- |   ECS Service Task     |
| (Receives Response)     |    |     (Subdomain)          |    |             [LoadBalancer]        |    |    [ProxyService]      |
+-------------------------+    +--------------------------+    | +-------------------------------+ |    |    +----------------+  |
                                                               | |        Listener               | |    |    |     NGINX      |  |
                                                               | |       (HTTPS/RTMP)            | |    |    |  (Proxy Config)|  |
                                                               | |      [ListenerHttps]          | |    |    +----------------+  |
                                                               | |      [ListenerRtmp]           | |    |                        |
                                                               | +-------------------------------+ |    +------------------------+
                                                               |                 |                 |
                                                               |                 v                 |
                                                               | +-------------------------------+ |
                                                               | |        Target Group           | |
                                                               | |       (HTTPS/RTMP)            | |
                                                               | |     [TargetGroupHttps]        | |
                                                               | |     [TargetGroupRtmp]         | |
                                                               | +-------------------------------+ |
                                                               +-----------------------------------+
                                                                                 |
                                                                                 v
                                                               +-----------------------------------+
                                                               |  Certificate Manager (ACM)        |
                                                               |  [CertificateArn]                 |
                                                               |  (Imports Certificate)            |
                                                               +-----------------------------------+
```

## Description of the Flow

1. **Client Request**: A client initiates a request to `proxy.thegrowthos.com` or any other URL that's set as the starting point that points to the NLB.
2. **proxy.thegrowthos.com**: The subdomain forwards the request to the Network Load Balancer (NLB).
3. **Network Load Balancer (NLB) [LoadBalancer]**: The NLB receives the request.
   - **Listener (HTTPS/RTMP) [ListenerHttps, ListenerRtmp]**: The listener within the NLB handles incoming traffic and routes it to the appropriate target group based on the port and protocol.
   - **Target Group (HTTPS/RTMP) [TargetGroupHttps, TargetGroupRtmp]**: The listener forwards the request to the target group, which is associated with the ECS service tasks running on Fargate.
4. **ECS Service Task (Fargate) [ProxyService]**: The ECS service task running on Fargate contains NGINX configured as a proxy. NGINX processes the request and sends it to the backend API endpoint.
5. **Backend API Endpoint**: The backend API processes the request and sends

 a response back to the ECS service task.
6. **ECS Service Task (Fargate) [ProxyService]**: NGINX within the ECS service task sends the response back to the target group within the NLB.
7. **Network Load Balancer (NLB) [LoadBalancer]**: The NLB receives the response.
   - **Target Group (HTTPS/RTMP) [TargetGroupHttps, TargetGroupRtmp]**: The target group forwards the response to the listener.
   - **Listener (HTTPS/RTMP) [ListenerHttps, ListenerRtmp]**: The listener within the NLB forwards the response back to `proxy.thegrowthos.com`.
8. **proxy.thegrowthos.com**: The subdomain forwards the response back to the client.
9. **Client Response**: The client receives the response from `proxy.thegrowthos.com` or other starting point that points to the NLB.

## Author

- **Maris Svirksts**

## Version History

- **1.0**: Initial release on 2024-06-21.
