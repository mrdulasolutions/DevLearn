# devlearn-javascript — examples

## Example 1: Complete minimal todo flow

```javascript
const form = document.querySelector('.todo-form');
const input = document.querySelector('#todo-input');
const list = document.querySelector('.todo-list');

/** @type {string[]} */
let todos = [];

form.addEventListener('submit', (event) => {
  event.preventDefault();
  const text = input.value.trim();
  if (!text) return;

  todos.push(text);
  input.value = '';
  render();
});

function render() {
  list.innerHTML = '';
  for (const text of todos) {
    const li = document.createElement('li');
    li.textContent = text;
    list.appendChild(li);
  }
}

render();
```

**Teaching order:** select → state array → submit handler → render loop → initial render.

## Example 2: Delete button per item

```javascript
function render() {
  list.innerHTML = '';
  todos.forEach((text, index) => {
    const li = document.createElement('li');
    li.textContent = text;

    const remove = document.createElement('button');
    remove.type = 'button';
    remove.textContent = 'Delete';
    remove.addEventListener('click', () => {
      todos.splice(index, 1);
      render();
    });

    li.appendChild(remove);
    list.appendChild(li);
  });
}
```

**Lesson hook:** Each delete closes over its `index`; re-render after splice keeps UI in sync.

**Better pattern (teach in deep):** store objects with ids, delete by id not index.

## Example 3: Objects with ids

```javascript
let todos = [];

function addTodo(text) {
  todos.push({ id: crypto.randomUUID(), text });
  render();
}

function deleteTodo(id) {
  todos = todos.filter((t) => t.id !== id);
  render();
}
```

**Lesson hook:** **id** identifies one todo even when list order changes.

## Example 4: localStorage preview (bridge to apis)

```javascript
const STORAGE_KEY = 'todos';

function load() {
  const raw = localStorage.getItem(STORAGE_KEY);
  todos = raw ? JSON.parse(raw) : [];
}

function save() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
}

function render() {
  // ... build DOM ...
  save();
}
```

**Lesson hook:** **JSON.stringify** turns array into string for storage; **parse** reverses on load.

Hand off: server persistence → devlearn-apis.

## Example 5: fetch error handling sketch

```javascript
async function loadTodos() {
  try {
    const res = await fetch('/api/todos');
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    todos = await res.json();
    render();
  } catch (err) {
    console.error('Load failed', err);
    // show user-visible message in DOM
  }
}
```

**Lesson hook:** Network fails; `try/catch` prevents silent broken UI.
