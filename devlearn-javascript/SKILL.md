---
name: devlearn-javascript
description: |
  Teaches JavaScript for interactivity while building features: variables, functions,
  events, DOM updates, and async/fetch preview. Use when the user wants buttons to
  do things, todo logic, DOM manipulation, or curriculum routes here. Proactively
  suggest when editing .js/.ts client code and DEVLEARN.md is enabled.
---

# DevLearn: JavaScript

## Iron law

**Teach without blocking ship.** Make the interaction work first; explain the model with each change.

## Voice

Follow [../shared/voice.md](../shared/voice.md). Lesson blocks from [../shared/lesson-block.md](../shared/lesson-block.md).

## Context

JavaScript is the **behavior layer** on top of HTML/CSS. Vibe coders care when "nothing happens on click" — teach events, state, and DOM updates as the fix unfolds.

## Prerequisites

- Basic page from devlearn-html-css (or existing HTML)
- Script linked: `<script src="app.js" defer></script>` or module

## Before you start

1. DEVLEARN.md depth (default **curious**)
2. Step 0: inline scripts vs bundled? framework (React)? Teach vanilla patterns first when learning.
3. Open browser DevTools console — teach it early in curious/deep mode

## Phase 1: Wire script to page

**Build:** External `app.js`, defer, verify `console.log('ready')`.

**Teach:** **DOMContentLoaded** / defer — JS runs after HTML parsed.

**Term:** **script** — code browser runs client-side

## Phase 2: Select elements

**Build:** `querySelector` / `getElementById` for input, button, list.

**Teach:** DOM as tree; selection returns live reference.

```javascript
const input = document.querySelector('#todo-input');
const list = document.querySelector('.todo-list');
```

**Term:** **DOM query** — find element handle to mutate later

## Phase 3: State in memory

**Build:** Array of todos `{ id, text, done }` or strings for minimal version.

**Teach:** **state** — data your program remembers while page is open (lost on refresh until apis skill).

**Smell:** Only mutating DOM with no data model — hard to delete/filter later.

## Phase 4: Events

**Build:** Click/submit handlers add todo, delete todo.

```javascript
form.addEventListener('submit', (event) => {
  event.preventDefault();
  // read input, push state, re-render
});
```

**Teach:**

- **event** — browser signal (click, submit)
- **handler** — function that runs when event fires
- `preventDefault()` — stop form from reloading page

**Term:** **event listener**

## Phase 5: Render loop

**Build:** `render()` clears list and rebuilds from state array.

**Teach:** Single source of truth — update state, then render. Not random DOM patches everywhere.

**Pattern:**

```javascript
function render() {
  list.innerHTML = '';
  for (const todo of todos) {
    const li = document.createElement('li');
    li.textContent = todo.text;
    list.appendChild(li);
  }
}
```

**Term:** **render** — sync UI to current state

## Phase 6: Async preview (optional same session)

**Build:** `fetch('/api/todos')` or read localStorage preview.

**Teach:** JS doesn't block the page while waiting; **Promise** / `async-await` in one sentence.

Hand off full network story to **devlearn-apis**.

See [examples.md](examples.md).

## Domain glossary

| Term | Definition |
|------|------------|
| variable | Named value storage |
| function | Reusable block of logic |
| array | Ordered list in memory |
| object | Key-value bundle `{ id, text }` |
| DOM | Live tree of page elements |
| event | User or browser action |
| listener | Function subscribed to event |
| state | Data the app remembers |
| render | Update UI from state |
| async | Work that finishes later without freezing UI |

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Script in `<head>` without defer | `null` queries | defer or bottom of body |
| No preventDefault on form | Page reload | `event.preventDefault()` |
| Mutate DOM only | Delete breaks | state array + render |
| innerHTML with user text | XSS risk | `textContent` or escape |
| Stale closure in loop | Wrong index | let, or data attributes |

## STOP checkpoint

Before adding API or localStorage:

> "When you add a todo, what three things happen — input read, state update, or DOM update?"

Fix gaps with one sentence each. Then apis skill for persistence.

## Lesson integration

One lesson per phase in curious mode; vibe merges 3–5 into one block.

Always anchor: `app.js:line` for handler and render.

## Lifecycle handoffs

| Situation | Suggest |
|-----------|---------|
| Persist data | `/devlearn-apis` |
| React project detected | `/devlearn-react` |
| Errors while building | `/devlearn-debugging` |
| Ship feature | `/devlearn-pre-ship` when release-ready |

## Required footer

```markdown
---
DevLearn status: DONE
Phases completed: [...]
Suggested next: /devlearn-apis | /devlearn-explain-diff
---
```

## Additional resources

- Annotated todo flow → [examples.md](examples.md)
- MDN links → [reference.md](reference.md)
