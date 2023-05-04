#Action to trigger automerge
Add the following yaml to your workflow:
```
name: Trigger Auto-Merge
run-name: Auto Merging Knowl Docs for Pull Request ${{ github.event.number }}
on:
  pull_request:
    branches: 
      - main
    types: [closed]

jobs:
  auto-merge:
    if: ${{ github.event.pull_request.merged }}
    runs-on: ubuntu-latest
    steps: 
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Auto-Merge
        uses: knowl-doc/auto-merge@main 
        with:
          KNOWL_API_KEY: ${{ secrets.KNOWL_API_KEY }}  
   ```
