# devlearn-devops — reference

## GitHub Actions minimal CI

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: npm
      - run: npm ci
      - run: npm test
      - run: npm run build
```

## Secrets in Actions

```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
```

Teach: Settings → Secrets, never commit values.

## Dockerfile sketch (Node API)

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

Terms: **image** (recipe result), **container** (running instance).

## Branch protection (concept)

Require CI green before merge — teach on GitHub/GitLab when user uses PRs.

## Pipeline stages table

| Stage | Catches |
|-------|---------|
| lint | style, some bugs |
| test | logic regressions |
| build | compile/bundle errors |
| audit | known vuln deps |
| deploy | only if all green |

## Links

- [GitHub Actions docs](https://docs.github.com/en/actions)
