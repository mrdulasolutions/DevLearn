# devlearn-devops — examples

## Annotated CI workflow

```yaml
on:
  pull_request:    # run on every PR — teach: catch bugs before merge
jobs:
  test:
    runs-on: ubuntu-latest  # clean Linux VM each time
    steps:
      - uses: actions/checkout@v4  # get your code
      - run: npm ci               # install exact lockfile versions
      - run: npm test             # gate: fail job if tests fail
```

**Lesson hook:** Failed CI on PR = merge blocked until fixed (if branch protection on).

## Preview deploy (Vercel/Netlify concept)

Push to PR branch → platform gives preview URL → `/devlearn-pre-ship` uses that URL for staging check.

## CI vs CD one sentence

**CI** answers "is this commit safe to merge?" **CD** answers "merge passed — put it live."
