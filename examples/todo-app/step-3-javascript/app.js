const form = document.querySelector('.todo-form');
const input = document.querySelector('#todo-input');
const list = document.querySelector('.todo-list');

/** @type {{ id: string, text: string }[]} */
let todos = [];

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
}

render();
