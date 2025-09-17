## Using custom action
> [!NOTE]
> Workflows -> [state.yaml](../../.github/workflows/custom_action.yaml)

> [!IMPORTANT]
> You can destroy environment deployed by terraform in github actions

Memo  
- Github actions relative directory is repository root
- custom action == ./action
- In order to use "runs:" in custom action, needs "shall: bash" in steps
- Secrets can be used in workflow, can't be used in custom action