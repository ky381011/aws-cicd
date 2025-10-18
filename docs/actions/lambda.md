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
