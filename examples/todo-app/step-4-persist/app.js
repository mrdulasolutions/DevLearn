const STORAGE_KEY = 'devlearn-todos';

const form = document.querySelector('.todo-form');
const input = document.querySelector('#todo-input');
const list = document.querySelector('.todo-list');

/** @type {{ id: string, text: string }[]} */
let todos = load();

form.addEventListener('submit', (event) => {
  event.preventDefault();
  const text = input.value.trim();
  if (!text) return;

  todos.push({ id: crypto.randomUUID(), text });
  input.value = '';
  render();
});

function deleteTodo(id) {
  todos = todos.filter((t) => t.id !== id);
  render();
}

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
  } catch {
    return [];
  }
}

function save() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(todos));
}

function render() {
  list.innerHTML = '';
  for (const todo of todos) {
    const li = document.createElement('li');
    li.textContent = todo.text;

    const remove = document.createElement('button');
    remove.type = 'button';
    remove.textContent = 'Delete';
    remove.addEventListener('click', () => deleteTodo(todo.id));

    li.appendChild(remove);
    list.appendChild(li);
  }
  save();
}

render();
