## Modularization
> [!NOTE]
> Workflows -> [state.yaml](../../.github/workflows/custom_action.yaml)

> [!IMPORTANT]
> You can destroy environment deployed by terraform in github actions

Memo  
- Github actions relative directory is repository root
- custom action == ./.github/action
- In order to use "runs:" in custom action, needs "shell: bash" in custom actions' steps
- Secrets can be used in workflow, can't be used in custom action

Modularization of these process  
- Get state file
- Terraform apply
- Terraform destroy
- Upload state file

By this modularization, becoming easy to reuse common steps  
These processes are necessary process for deploying with terraform,  
and managing cloud state by using private github repository  

### Explanation about each process
<details><summary>Get state file</summary>

```yaml
runs:
  using: "composite"
  steps:
    - name: Check out state repository
      uses: actions/checkout@v4
      with:
        repository: ${{ github.repository_owner }}/${{ inputs.STATE_REPO_NAME }}
        token: ${{ inputs.STATE_REPO_TOKEN }}
        path: state-repo

    - name: Copying tfstate file to terraform work directory
      run: |
          if [ -f "state-repo/${{ inputs.store_path }}/terraform.tfstate" ]; then
            \cp -f state-repo/${{ inputs.store_path }}/terraform.tfstate ${{ inputs.terraform_work_path }}/terraform.tfstate
            echo "tfstate overwritten."
          else
            echo "No existing tfstate, skipping copy."
          fi
      shell: bash
```
  
First, check out github private repository by using token  
In custom action, can't access repository secrets  
So, must hand over like below in workflow  

```yaml
- name: Get state file
  uses: ./.github/actions/_tfstate_pull_module/
  with:
    state_repo_name: ${{ secrets.STATE_REPO_NAME }}
    state_repo_token: ${{ secrets.STATE_REPO_TOKEN }}
    store_path: ${{ env.STORE_PATH }}
    terraform_work_path: ${{ env.TERRAFORM_WORK_DIR}}
```

All secrets value are masked in this workflow log  
  
By this step, tfstate file is copyed into terraform work directory  
</details>
  
<details><summary>Terraform apply</summary>

```yaml
runs:
  using: "composite"
  steps:
    - name: Terraform Init
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform init -reconfigure
      shell: bash

    - name: Terraform Plan
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform plan -out=tfplan
      shell: bash

    - name: Terraform Apply
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform apply -auto-approve tfplan
      shell: bash
```

In first step, prepare aws provider  
In second step, get the difference from state file  
In third step, deploy resources

```yaml
- name: Deploy process apply
  if: ${{ github.event.inputs.OPERATE == 'apply' }}
  uses: ./.github/actions/_terraform_apply_module/
  with:
    terraform_work_path: ${{ env.TERRAFORM_WORK_DIR}}
```

And by ` if: ${{ github.event.inputs.OPERATE == 'apply' }}`,  
This action is only running if inputs value of "OPERATE" is "apply"  

</details>
  
<details><summary>Terraform destroy</summary>

```yaml
runs:
  using: "composite"
  steps:
    - name: Terraform Init
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform init -reconfigure
      shell: bash

    - name: Terraform Plan
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform plan -out=tfplan
      shell: bash

    - name: Terraform Destroy
      working-directory: ${{ inputs.terraform_work_path }}
      run: terraform destroy -auto-approve
      shell: bash
```


</details>
  
<details><summary>Upload state file</summary>


</details>