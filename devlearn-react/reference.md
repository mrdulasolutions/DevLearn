# DevLearn React — reference

## Official docs

- [React Learn](https://react.dev/learn)
- [Thinking in React](https://react.dev/learn/thinking-in-react)
- [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks)

## Hooks quick reference

| Hook | Use | Don't use for |
|------|-----|---------------|
| useState | Local UI state | Server data cache (consider library) |
| useEffect | External sync after render | Event responses, derived values |
| useRef | DOM node, mutable value without re-render | Replacing state |
| useMemo / useCallback | Expensive calc / stable callback | Default optimization (seasoned) |
| useContext | Shared tree data | Every prop (overkill) |

## When NOT to useEffect

| Situation | Do instead |
|-----------|------------|
| Compute from props/state | Calculate in render body |
| User clicked button | Event handler |
| Form submit | onSubmit handler |
| Filter list from search text | Derive filtered array in render |
| Fetch on button | Handler + async function |

**Teaching line:** "Effects are for syncing **outside** React — network, subscriptions, DOM libs."

## useEffect dependency teaching

```javascript
useEffect(() => {
  // runs after render when deps change
}, [userId]); // missing dep → stale bug; extra dep → loop
```

## Server vs client (Next overlap)

In Next App Router, default components are **server** — no useState.

→ `'use client'` at top of file that uses hooks — hand off to devlearn-next.

## Stack detection

```json
"dependencies": {
  "react": "^19.0.0",
  "next": "^15.0.0"
}
```

Both present → teach React patterns here; routing/data on next skill.

## Seasoned decision examples

| Decision | Alternatives |
|----------|--------------|
| Lift state to parent | Context, external store (Zustand) |
| useEffect fetch | React Query, server component fetch |
| Split presentational | Single file until pain threshold |

Log to `.devlearn/decisions.md` when non-obvious.

## TypeScript tips (when .tsx)

- Props interface: `type TodoItemProps = { text: string; done: boolean }`
- Teach types as **documentation** for vibers — optional depth

## Testing pointer (deep)

- React Testing Library: test behavior not implementation
- `screen.getByRole('button')` — link devlearn-pre-ship for CI

## Related skills

| Topic | Skill |
|-------|-------|
| Next.js routing | devlearn-next |
| fetch / API | devlearn-apis |
| Errors | devlearn-debugging |
| Deploy SPA/SSR | devlearn-deploy |
