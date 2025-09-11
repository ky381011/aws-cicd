## Storing tfstate file
> [!NOTE]
> Workflows -> [state.yaml](../../.github/workflows/state.yaml)

> [!IMPORTANT]
> You can destroy environment deployed by terraform in github actions

Process of storing tfstate file  
File is stored in own private repository   

```yaml
- name: Checkout private tfstate repo
  uses: actions/checkout@v4
  with:
    repository: ${{ github.repository_owner }}/${{ secrets.STATE_REPO_NAME }}
    token: ${{ secrets.STATE_REPO_TOKEN }}
    path: state-repo

- name: Copy tfstate if exists
  run: |
    if [ -f "state-repo/${{ env.STORE_PATH }}/terraform.tfstate" ]; then
      \cp -f state-repo/${{ env.STORE_PATH }}/terraform.tfstate ${{ env.TERRAFORM_WORK_DIR }}/terraform.tfstate
      echo "tfstate overwritten."
    else
      echo "No existing tfstate, skipping copy."
    fi

- name: List of workdir
  run: |
    ls -al ${{ env.TERRAFORM_WORK_DIR }}

- name: Mask repo name
  run: |
    echo "::add-mask::${{ env.STORE_PATH }}"

# ================================
# Terraform process
# ================================

- name: Overwrite tfstate
  run: |
    mkdir -p state-repo/${{ env.STORE_PATH }}
    \cp -f ${{ env.TERRAFORM_WORK_DIR }}/terraform.tfstate state-repo/${{ env.STORE_PATH }}/terraform.tfstate

- name: Commit and push new state
  run: |
    cd state-repo
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add "${{ env.STORE_PATH }}/terraform.tfstate"
    git commit -m "Update tfstate $(date -u +'%Y-%m-%d %H:%M:%S UTC')" || echo "No changes to commit"
    git push origin main
```

Private repository name is masked in logs  

This workflow can select apply or destoroy  

```yaml
on:
  # push:
  #   branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
    inputs:
      OPERATE:
        description: "Choose operation"
        required: true
        default: "apply"
        type: choice
        options:
          - apply
          - destroy
```

Be able to select by dropdown format  

> [!TIP]
> Failures of backend

While setting terraform backend as bellow, hashicorp/setup-terraform@v3 can't read tfstate file  

```terraform
terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}
```
despite having copied the tfstate file into terraform work directory  
