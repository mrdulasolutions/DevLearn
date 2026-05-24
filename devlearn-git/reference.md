# devlearn-git — reference

## Command cheatsheet (teaching order)

| Command | Plain English | When to teach |
|---------|---------------|---------------|
| `git status` | What's changed / staged | Start of every git session |
| `git diff` | Unstaged line changes | Before commit |
| `git diff --cached` | Staged changes | Before commit |
| `git add <file>` | Put file in staging cart | Before commit |
| `git add -p` | Stage hunks interactively | Deep mode, large changes |
| `git commit -m "msg"` | Save snapshot | After staging |
| `git log --oneline -5` | Recent snapshots | After commit |
| `git branch` | List branches | Branch workflow |
| `git switch -c name` | New branch + jump | Feature start |
| `git push -u origin HEAD` | Upload branch, set tracking | Before PR |
| `gh pr create` | Open pull request | Share for review |
| `git pull --rebase origin main` | Update branch cleanly | Before merge |
| `git restore <file>` | Discard working changes | Recovery (warn) |

## Good commit messages (teach by example)

| Bad | Good |
|-----|------|
| fix | Fix empty todo submit validation |
| updates | Add localStorage save for todo list |
| wip | *(avoid on shared branches)* |

Formula: **imperative verb + what user gets**

## Branch naming

| Pattern | Example |
|---------|---------|
| feature/ | feature/todo-persist |
| fix/ | fix/delete-last-todo |
| chore/ | chore/readme |

## What not to commit

- `.env`, credentials, API keys
- `node_modules/` (use .gitignore)
- Large binaries without LFS

Teach **.gitignore** when any of these appear in status.

## PR body template (for learners)

```markdown
## Summary
- [user-visible change]

## Test plan
- [ ] [click path or command]
```

## Pairing with explain-diff

After `git commit` or before PR:

> "Want the story of what's in this commit? Run `/devlearn-explain-diff` on `git show HEAD`."

## Depth expansion

**Deep:** draw ASCII:

```
main:    A --- B --- C
              \
feature:       D --- E  (your commits)
```

Explain merge vs rebase outcome in one sentence each.
