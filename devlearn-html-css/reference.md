# devlearn-html-css — reference

## MDN quick links

- [HTML elements reference](https://developer.mozilla.org/en-US/docs/Web/HTML/Element)
- [CSS flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_flexible_box_layout)
- [CSS grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout)
- [Accessibility](https://developer.mozilla.org/en-US/docs/Learn/Accessibility)

## Semantic tag picker

| Need | Tag |
|------|-----|
| Page header / logo | `<header>` |
| Primary content | `<main>` |
| Group of content | `<section>` |
| Navigation links | `<nav>` |
| Footer | `<footer>` |
| List of todos | `<ul>` + `<li>` |
| User input | `<form>`, `<input>`, `<label>` |
| Click action | `<button type="button">` |

## Flex cheatsheet

```css
.container {
  display: flex;
  flex-direction: row;   /* or column */
  gap: 1rem;
  align-items: center;
  justify-content: space-between;
}
```

## Grid cheatsheet (simple page)

```css
.page {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  max-width: 40rem;
  margin: 0 auto;
  padding: 1rem;
}
```

## Accessible form pattern

```html
<label for="todo-input">New todo</label>
<input id="todo-input" type="text" autocomplete="off" />
<button type="button">Add</button>
```

## CSS variable pattern (optional polish)

```css
:root {
  --bg: #0f172a;
  --text: #f8fafc;
  --accent: #38bdf8;
}
body {
  background: var(--bg);
  color: var(--text);
}
```

Teach **CSS variables** when repeating colors.

## Teaching order for vibe coders

1. See it in browser (HTML)
2. Make it not ugly (spacing, font)
3. Make it line up (flex)
4. Make it work on phone (viewport + max-width)

Don't introduce grid and flex same lesson unless needed.
