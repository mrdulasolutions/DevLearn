# devlearn-javascript — reference

## MDN quick links

- [JavaScript guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide)
- [Document.querySelector](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector)
- [EventTarget.addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener)
- [async/await](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Promises)

## Script loading

```html
<script src="app.js" defer></script>
```

| Attribute | Effect |
|-----------|--------|
| defer | Run after HTML parsed, order preserved |
| type="module" | ES modules, strict mode, defer implied |

## Minimal todo state shape

```javascript
/** @type {{ id: string, text: string, done: boolean }[]} */
let todos = [];
```

## ID generation (teaching moment)

```javascript
const id = crypto.randomUUID?.() ?? String(Date.now());
```

Explain: stable id for delete/toggle.

## Delete handler pattern

```javascript
function deleteTodo(id) {
  todos = todos.filter((t) => t.id !== id);
  render();
}
```

Teach **filter** as "keep todos whose id doesn't match."

## async/await one-liner teaching

```javascript
async function loadTodos() {
  const response = await fetch('/api/todos');
  todos = await response.json();
  render();
}
```

**Order:** fetch returns Promise → await pauses function until data → json parses body.

## Debugging cheatsheet for learners

| Tool | Use |
|------|-----|
| console.log | See values |
| breakpoint | Pause on line in Sources tab |
| Network tab | See fetch requests (apis skill) |

## When to suggest devlearn-apis

- User asks save across refresh
- User mentions database, login, server
- fetch errors (404, CORS)
