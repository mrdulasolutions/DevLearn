# devlearn-html-css — examples

Annotated before/after snippets for teaching.

## Example 1: Div soup → semantic todo shell

**Before (hard to teach, hard to style):**

```html
<div class="wrap">
  <div class="title">Todos</div>
  <div class="row">
    <div class="input"></div>
    <div class="add">Add</div>
  </div>
  <div class="items"></div>
</div>
```

**After (teachable):**

```html
<main class="todo-app">
  <h1>Todos</h1>
  <form class="todo-form" aria-label="Add todo">
    <label for="todo-input">New todo</label>
    <input id="todo-input" type="text" />
    <button type="submit">Add</button>
  </form>
  <ul class="todo-list" aria-live="polite"></ul>
</main>
```

**Lesson hook:** `<main>` is the primary content landmark; `<button>` is keyboard-accessible; `aria-live` announces list updates to assistive tech.

## Example 2: Flex row for input + button

```css
.todo-form {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.todo-form input {
  flex: 1; /* input eats remaining horizontal space */
}
```

**Lesson hook:** `flex: 1` means "grow to fill"; `gap` replaces hacky margins between siblings.

## Example 3: Card layout centered on page

```css
body {
  margin: 0;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: flex-start;
  padding: 2rem 1rem;
  font-family: system-ui, sans-serif;
}

.todo-app {
  width: 100%;
  max-width: 28rem;
}
```

**Lesson hook:** Page is a flex container; card has `max-width` so lines don't stretch on ultrawide monitors.

## Example 4: Focus visible for keyboard users

```css
button:focus-visible,
input:focus-visible {
  outline: 2px solid #38bdf8;
  outline-offset: 2px;
}
```

**Lesson hook:** `:focus-visible` shows focus ring for keyboard, not every mouse click (modern browsers).

## Example 5: Simple responsive stack

```css
@media (max-width: 480px) {
  .todo-form {
    flex-direction: column;
  }
}
```

**Lesson hook:** Same HTML, column layout on narrow screens — button goes full width under input.
