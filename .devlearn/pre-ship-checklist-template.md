# Pre-ship checklist template

Copy to `.devlearn/pre-ship-checklist.md` or append after `/devlearn-pre-ship` runs.

## Release: [version or PR #]

| Check | Status | Notes |
|-------|--------|-------|
| Tests pass locally | ☐ | `npm test` or project command |
| Lint / typecheck clean | ☐ | |
| No secrets in diff | ☐ | `/devlearn-security` |
| Staging / preview verified | ☐ | URL: |
| Rollback plan known | ☐ | previous deploy / revert commit |
| Env vars set on host | ☐ | |
| Migrations run (if any) | ☐ | |
| Changelog / release notes | ☐ | optional |

**Sign-off:** ready to deploy / needs work

**Verified by:** [date]
