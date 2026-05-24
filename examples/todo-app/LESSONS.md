# Example DevLearn lessons (todo app)

Sample blocks the agent should emit. Use with `/devlearn-lesson-review` to practice rubric.

## Step 1 — HTML shell

### What changed
You have a todo page with a heading, an input, an Add button, and an empty list area.

### Why we did it
Semantic tags (`main`, `form`, `ul`) make the page understandable to browsers and assistive tech before we add styling or JS.

### How it works
`index.html:12` — `<main class="todo-app">` wraps the whole feature.

### Term of the moment
**semantic HTML**: tags that describe meaning, not just boxes.

---

## Step 3 — JavaScript

### What changed
Typing a todo and clicking Add puts it on the list; Delete removes it.

### Why we did it
The page needs memory and reactions to clicks — HTML alone can't do that.

### How it works
`app.js:18` — submit handler reads input, pushes to array, calls `render()`.

### Term of the moment
**event listener**: function that runs when user submits the form.

### Try it yourself
Add two todos, delete one, refresh — notice they're gone (until step 4).

---

## Step 4 — localStorage (seasoned decision example)

### Decision
Persist todos with localStorage instead of a REST API for this step.

### Alternatives
- **REST API** — shared data, needs server (defer to apis skill)
- **sessionStorage** — clears when tab closes (wrong for todos)

### Risk & verify
Clear site data wipes todos. Verify: add todo, refresh, still there.

### Anchor
`app.js:42` — `localStorage.setItem` after render.

---

## Step 6 — Deploy

### What changed
Your static files can be hosted so anyone with the URL sees the app.

### Why we did it
Files on your laptop aren't reachable from the internet; a host serves them over HTTPS.

### Term of the moment
**build artifact**: the folder the host publishes (`/` or `dist/`).

---

## Step 7 — Pre-ship

### What we're checking
Tests pass, no secrets in git, preview works, and you know how to rollback.

### Term of the moment
**smoke test**: a quick check that the main user path works before you call it shipped.

---

## Step 7 — Post-ship

### What changed
We verified the live URL in incognito — add todo, refresh, delete — and logged the result.

### Why we did it
Deploy can succeed while prod is broken (wrong env, bad asset). Post-ship catches that before users do.

### Term of the moment
**rollback**: reverting to the last known-good deployment when production is broken.
