## Storing tfstate file
> [!NOTE]
> Workflows -> [lambda.yaml](../../.github/workflows/lambda.yaml)

> [!IMPORTANT]
> You can destroy environment deployed by terraform in github actions

## Lambda deploy
Deploying lambda by terraform, role for gterraform needs policies  

### List of policy for lambda
- Apply process
  - Need
    - iam:CreateRole
    - iam:AttachRolePolicy
    - iam:PassRole
  - Option
    - iam:DetachRolePolicy
    - iam:GetRole
    - iam:ListAttachedRolePolicies
    - iam:ListInstanceProfilesForRole
- Destroy process
  - Need
    - iam:DetachRolePolicy
    - iam:DeleteRole
  - Optional
    - iam:GetRole
    - iam:ListAttachedRolePolicies
    - iam:ListInstanceProfilesForRole

### Python Process
1. Test with github actions

Testing process obly run when the latest commit have the difference in app directory
```yaml

```

2. Packaging files

### Terraform Process
1. Create role
2. Create policy and attaching to role
3. Deploy lambda function
