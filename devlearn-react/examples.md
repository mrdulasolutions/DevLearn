# devlearn-react — examples

## Todo item component

```jsx
function TodoItem({ todo, onDelete }) {
  return (
    <li>
      {todo.text}
      <button type="button" onClick={() => onDelete(todo.id)}>Delete</button>
    </li>
  );
}
```

**Teach:** `todo` and `onDelete` are **props** — parent owns data and delete logic.

## Stateful list parent

```jsx
function TodoList() {
  const [todos, setTodos] = useState([]);

  function addTodo(text) {
    setTodos((prev) => [...prev, { id: crypto.randomUUID(), text }]);
  }

  function deleteTodo(id) {
    setTodos((prev) => prev.filter((t) => t.id !== id));
  }

  return (/* form + todos.map → TodoItem */);
}
```

**Teach:** `setTodos` with callback — new array, no mutation.
