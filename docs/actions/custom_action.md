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


