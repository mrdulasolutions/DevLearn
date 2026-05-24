# DevLearn curriculum map

Goal → skill chain → weekend project → depth suggestion.

## Entry: totally new

| | |
|---|---|
| **Skills** | devlearn-html-css → devlearn-javascript → devlearn-git → devlearn-deploy |
| **Project** | Todo list: static page → clicks work → commit → public link |
| **Depth** | curious |
| **Copy-paste prompt** | "Build a todo list page. Teach me while you work. DEVLEARN depth curious." |

## I want a webpage

| | |
|---|---|
| **Skills** | devlearn-html-css → devlearn-javascript |
| **Project** | Personal landing page with bio + link buttons |
| **Depth** | vibe |
| **Prompt** | "Create a one-page site with my name and three links. Teach me HTML/CSS as you go." |

## I want interactivity

| | |
|---|---|
| **Skills** | devlearn-javascript → devlearn-html-css (if markup weak) |
| **Project** | Counter, tabs, or todo add/remove |
| **Depth** | curious |
| **Prompt** | "Add click interactions to my page. Explain events and the DOM." |

## I want to save data

| | |
|---|---|
| **Skills** | devlearn-javascript → devlearn-apis |
| **Project** | Todos that survive refresh (localStorage) then optional REST API |
| **Depth** | curious |
| **Prompt** | "Persist todos across refresh. Explain JSON and where data lives." |

## I want login / backend

| | |
|---|---|
| **Skills** | devlearn-apis → devlearn-deploy → devlearn-git |
| **Project** | Simple auth or API-backed todos |
| **Depth** | deep |
| **Prompt** | "Wire a minimal API for todos. Teach REST, env vars, and errors." |

## I don't understand git

| | |
|---|---|
| **Skills** | devlearn-git → devlearn-explain-diff |
| **Project** | Commit today's work + open PR |
| **Depth** | curious |
| **Prompt** | "Walk me through committing this and explain every git step." |

## I want it live on the internet

| | |
|---|---|
| **Skills** | devlearn-deploy → devlearn-git (if not using git yet) |
| **Project** | Deploy existing static or Vite app to Vercel/Netlify/similar |
| **Depth** | curious |
| **Prompt** | "Deploy this so I get a shareable URL. Explain build vs runtime." |

## What did the agent just do?

| | |
|---|---|
| **Skills** | devlearn-explain-diff → devlearn-glossary |
| **Project** | N/A — review session |
| **Depth** | vibe → curious if still confused |
| **Prompt** | "Explain my current git diff grouped by what changed and why." |

## Full stack weekend

| | |
|---|---|
| **Skills** | html-css → javascript → apis → git → deploy |
| **Project** | Todo app with API + deployed frontend |
| **Depth** | deep |
| **Prompt** | "Build and deploy a todo app end to end. Teach me at curious depth." |

## Stretch after todo app

| Skill focus | Project idea |
|-------------|--------------|
| devlearn-apis | Swap localStorage for real database API |
| devlearn-javascript | Filters, edit-in-place, keyboard shortcuts |
| devlearn-deploy | Custom domain + preview deployments |
| devlearn-git | Branch per feature, code review habit |

## Topic keyword → skill

| Keywords in user message | Route to |
|--------------------------|----------|
| html, css, layout, responsive, flex | devlearn-html-css |
| js, click, dom, async, fetch client | devlearn-javascript |
| react, component, props, state, hooks, jsx | devlearn-react |
| next, app router, server component, route.ts | devlearn-next |
| api, rest, cors, auth, env, server | devlearn-apis |
| commit, branch, pr, merge, git | devlearn-git |
| vercel, deploy, docker, ci, production | devlearn-deploy |
| github actions, pipeline, workflow, ci/cd | devlearn-devops |
| security, owasp, secrets, xss, auth hardening | devlearn-security |
| pre-ship, release checklist, ready to merge | devlearn-pre-ship |
| post deploy, smoke test, prod check, monitoring | devlearn-post-ship |
| plan refactor, before you code | devlearn-before-you-ship |

## Depth defaults by persona

| Persona | depth | Rationale |
|---------|-------|-----------|
| Pure vibe coder | vibe | Ship first, minimal terms |
| "Explain sometimes" | curious | Try-it-yourself steps |
| "I want to maintain this" | deep | Tradeoffs + diff walks |

User can override anytime via DEVLEARN.md or "more detail" / "less detail".

## Stack-based routes (autodetect from package.json)

See [stack-detection.md](stack-detection.md).

### Next.js project detected

| | |
|---|---|
| **Skills** | devlearn-next → devlearn-react → devlearn-apis → devlearn-deploy |
| **Project** | Todo app with App Router + API route |
| **Depth** | curious |
| **Prompt** | "Build a todo app in Next.js. Teach server vs client components as you go." |

### React (Vite/CRA) detected

| | |
|---|---|
| **Skills** | devlearn-react → devlearn-javascript → devlearn-apis → devlearn-deploy |
| **Project** | Todo SPA with component state |
| **Depth** | curious |
| **Prompt** | "Build todos in React. Explain props and state while you work." |

### Errors / debugging

| | |
|---|---|
| **Skills** | devlearn-debugging → devlearn-explain-diff |
| **Project** | Fix current broken feature |
| **Depth** | curious |
| **Prompt** | "Fix this error and explain what the stack trace means." |

### First-time DevLearn setup

| | |
|---|---|
| **Skills** | devlearn-onboard → (routed path) |
| **Prompt** | "/devlearn-onboard — I'm new, help me set up learning while I build." |

### Session wrap-up

| | |
|---|---|
| **Skills** | devlearn-recap → devlearn-curriculum-router |
| **Prompt** | "/devlearn-recap — what did I learn this session?" |

## Ship lifecycle routes

See [../shared/ship-lifecycle.md](../shared/ship-lifecycle.md).

### Ready to release / merge

| | |
|---|---|
| **Skills** | devlearn-pre-ship → devlearn-security → devlearn-deploy → devlearn-post-ship |
| **Depth** | curious (viber) / seasoned for security+rollback |
| **Prompt** | "Run pre-ship checklist, security pass, deploy, then verify prod." |

### Set up CI/CD

| | |
|---|---|
| **Skills** | devlearn-devops → devlearn-pre-ship |
| **Project** | GitHub Actions on PR + test gate |
| **Prompt** | "Add CI that runs tests on every PR. Teach me the pipeline." |

### Security review

| | |
|---|---|
| **Skills** | devlearn-security → devlearn-pre-ship |
| **Prompt** | "Review this app for common security issues and fix what matters." |

### Post-deploy verification

| | |
|---|---|
| **Skills** | devlearn-post-ship → devlearn-recap |
| **Prompt** | "I deployed to [URL]. Run post-ship smoke checks and teach monitoring basics." |

### Plan before big refactor

| | |
|---|---|
| **Skills** | devlearn-before-you-ship → (build) → devlearn-pre-ship |
| **Prompt** | "Plan the refactor before you touch code, then build." |
