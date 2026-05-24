# devlearn-security — reference

## OWASP Top 10 (teaching subset)

| Risk | Vibe coder explanation | Common fix |
|------|------------------------|------------|
| Broken access control | User A sees User B's data | Check auth on every route |
| Cryptographic failures | Secrets sent/stored wrong | HTTPS, hash passwords, env vars |
| Injection | Hacker input becomes code | Parameterized queries, validate input |
| Insecure design | Feature unsafe by design | Threat sketch before build |
| Security misconfiguration | Debug on in prod | Lock down prod settings |
| Vulnerable components | Old library with holes | npm audit, update deps |
| Auth failures | Weak login | MFA, session expiry |
| Data integrity failures | Untrusted updates | Sign releases, CI checks |
| Logging failures | Can't detect breach | Log auth failures (no secrets) |
| SSRF | Server fetches attacker URL | Allowlist outbound URLs |

Don't lecture all ten — pick what matches the repo.

## Secrets hygiene

```bash
# .gitignore must include
.env
.env.local
*.pem
```

Teach **`.env.example`**: key names only, no values.

## XSS prevention

| Bad | Good |
|-----|------|
| `el.innerHTML = userInput` | `el.textContent = userInput` |
| Unescaped template in HTML | framework auto-escape or sanitize lib |

## npm audit (teach once)

```bash
npm audit
npm audit fix
```

Explain: known CVEs in dependency tree; fix updates transitive deps.

## Seasoned verify commands

```bash
grep -r "API_KEY" --include='*.ts' --include='*.js' .  # should not hit prod literals
curl -I https://your-prod-url  # check HTTPS redirect
```

## When to suggest devlearn-devops

- Need CI secret scanning (gitleaks, GitHub secret scanning)
- SAST in pipeline
- Container image scanning

## Auth patterns (teaching comparison)

| Pattern | Pros | Cons |
|---------|------|------|
| Session cookie (httpOnly) | Simple web; XSS can't read cookie easily | CSRF needs handling |
| JWT in memory | SPA-friendly | Lost on refresh unless refresh token |
| JWT in localStorage | Easy to implement | XSS steals token |
| API key (server only) | Server-to-server | Never in browser bundle |

## Input validation checklist

- [ ] Validate type, length, format on **server**
- [ ] Reject unexpected fields (allowlist)
- [ ] Rate limit login and public POST routes (seasoned)
- [ ] File uploads: type + size limits

## Pre-ship security mini-pass (copy-paste)

```markdown
| Check | Pass |
|-------|------|
| No secrets in git diff | |
| Auth on sensitive routes | |
| Server-side validation on writes | |
| npm audit high/critical addressed or accepted | |
| Prod errors generic to users | |
```

## Related skills

| Topic | Skill |
|-------|-------|
| HTTP auth implementation | devlearn-apis |
| Release gate | devlearn-pre-ship |
| CI audit job | devlearn-devops |
| Prod incident | devlearn-post-ship → devlearn-debugging |
