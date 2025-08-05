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

## Optional setting
### AWS credential in GitHub Actions
```yaml
- name: Configure AWS credentials
    uses: aws-actions/configure-aws-credentials@v4
    with:
        aws-region: ${{ env.AWS_REGION }}
        role-to-assume: 'arn:aws:iam::YOUR_AWS_ID:role/IAM_ROLE_NAME'
```
Use OIDC (OpenID Connect) to get AWS credential  
  
IAM -> Access Management -> Identity providers -> Add provider
- Provider type : OpenId Connect
- Provider URL : https://token.actions.githubusercontent.com
- Audience : sts.amazonaws.com

Then, assign policy to role which created for github actions  
And setting trust policy as example json below
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
                    "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_USER_NAME/YOUR_GITHUB_REPOSITORY_NAME:ref:refs/heads/BRANCH_NAME"
                }
            }
        }
    ]
}
```

Without trust policy, github actions can't use credentials

Recommend to use github actions secret for your ID and role name
