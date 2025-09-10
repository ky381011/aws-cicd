## Storing tfstate file
> [!NOTE]
> Workflows -> [state.yaml](../../.github/workflows/state.yaml)

> [!IMPORTANT]
> You can destroy environment deployed by terraform in github actions

Comparede to vpc.yaml, adding process of storing tfstate file  
File is stored in own private repository   

```yaml
- name: Checkout private tfstate repo
  uses: actions/checkout@v4
  with:
    repository: ${{ github.repository_owner }}/${{ secrets.STATE_REPO_NAME }}
    token: ${{ secrets.STATE_REPO_TOKEN }}
    path: state-repo

- name: Mask repo name
  run: |
    echo "::add-mask::${{ env.STORE_PATH }}"

- name: Copy tfstate
  run: |
    mkdir -p state-repo/${{ env.STORE_PATH }}
    cp src/state/terraform.tfstate state-repo/${{ env.STORE_PATH }}/terraform.tfstate

- name: Commit and push state
  run: |
    cd state-repo
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add "${{ env.STORE_PATH }}/terraform.tfstate"
    git commit -m "Update tfstate $(date -u +'%Y-%m-%d %H:%M:%S UTC')" || echo "No changes to commit"
    git push origin main
```

Private repository name is masked in logs
