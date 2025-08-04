## Get EC2 instance memory usage
> [!NOTE]
> Workflows -> [init.yaml](../../.github/workflows/init.yaml)

## Need setting
### Service list
- EC2
- IAM
- VPC

#### EC2
Need "SSM Agent" -> Default installed in Amazon Linux
  
#### VPC
##### Inbound
Accept HTTPS(443)
##### Outbound
Accept all

#### IAM
- For github actions
    - Custom policy
        ```json
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "ssm:SendCommand",
                        "ssm:GetCommandInvocation",
                        "ssm:ListCommandInvocations",
                        "ssm:DescribeInstanceInformation"
                    ],
                    "Resource": "*"
                }
            ]
        }
        ```
        ```"ssm:SendCommand"``` is used for get memory usage of EC2 instance
