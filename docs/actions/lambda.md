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
- Check difference
```yaml
diff:
  runs-on: ubuntu-latest
  outputs:
    changed: ${{ steps.diff.outputs.changed }}
  steps:
    - name: Checkout
      uses: actions/checkout@v4
      with:
        fetch-depth: 2

    - name: Check diff in target directory
      id: diff
      run: |
        if git diff --quiet HEAD^ HEAD -- ${{ env.APP_WORK_DIR }}; then
          echo "changed=false" >> $GITHUB_OUTPUT
        else
          echo "changed=true" >> $GITHUB_OUTPUT
        fi
```

- Test
```yaml
test:
  needs: diff
  if: needs.diff.outputs.changed == 'true'
  name: test lambda
  runs-on: ubuntu-latest
  steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.x'

    - name: Test python
      run: |
          python ${{ env.APP_WORK_DIR }}/test_return_hash.py
```

2. Packaging files
```yaml
- name: Install dependencies
  run: |
    cd ${{ env.APP_WORK_DIR }}
    pip install -r requirements.txt -t lib

- name: Create deployment package
  run: |
    cd ${{ env.APP_WORK_DIR }}
    zip -r lambda.zip .
    cp lambda.zip ${{ github.workspace }}/$TERRAFORM_WORK_DIR/lambda.zip
```
First step, install libarary into the work directory  
Second step, zipping all files including libraries  
then, copying zip file to terraform work directory  

### Terraform Process
1. Create role
Lambda resource need role for execution  

```terraform
resource "aws_iam_role" "lambda_role" {
  name = "lambda-basic-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}
```

2. Create policy and attaching to role
3. Deploy lambda function
