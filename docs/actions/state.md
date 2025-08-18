## Storing tfstate file
> [!NOTE]
> Workflows -> [state.yaml](../../.github/workflows/state.yaml)

> [!CAUTION]
> You must delete VPC created by GitHub Actions manually.

Comparede to vpc.yaml, adding process of storing tfstate file  
File is stored in own private repository   

```yaml
- name: Checkout private tfstate repo
  uses: actions/checkout@v4
  with:
      repository: ${{ github.repository_owner }}/${{ secrets.STATE_REPO_NAME }}
      token: ${{ secrets.STATE_REPO_TOKEN }}
      path: state-repo  
  - name: Copy tfstate
    run: |
        mkdir -p state-repo/${{ env.JOB_NAME }}
        cp src/state/terraform.tfstate state-repo/${{ env.JOB_NAME }}/terraform.tfstate
  
  - name: Commit and push state
    run: |
        cd state-repo
        git config user.name "github-actions[bot]"
        git config user.email "github-actions[bot]@users.noreply.github.com"
        git add "${{ env.JOB_NAME }}/terraform.tfstate"
        git commit -m "Update tfstate $(date -u +'%Y-%m-%d %H:%M:%S UTC')" || echo "No changes to commit"
        git push origin main
```
