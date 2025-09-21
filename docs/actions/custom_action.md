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
</details>
  
<details><summary>Terraform apply</summary>


</details>
  
<details><summary>Terraform destroy</summary>


</details>
  
<details><summary>Upload state file</summary>


</details>