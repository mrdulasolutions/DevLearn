# DevLearn recap — reference

## Session opener (meta skill uses this too)

When `.devlearn/progress.md` has **Last session**:

```markdown
**Welcome back.** Last time: [one line from Last session]. Continuing [feature] or something new?
```

Skip opener if user said "just ship" or first message is urgent bug.

## Example recaps

### Viber, vibe (15 lines max)

```markdown
## Session recap (60 seconds)

**We worked on:** A todo list that saves when you refresh the page.

**Key terms:**
- **DOM** — the browser's live tree of your page
- **localStorage** — saves strings in your browser between visits
- **event listener** — code that runs when you click

**Files touched:** `index.html`, `app.js`, `styles.css`

**Try next:** Delete a todo, refresh — confirm it's still gone.

**Next session:** `/devlearn-apis` if you want a real server.
```

### Seasoned, curious

```markdown
## Session recap (60 seconds)

**We worked on:** Extracted save helper; added optimistic UI for deletes.

**Decisions:**
- localStorage vs IndexedDB — stayed localStorage; volume fits MVP
- No sync layer yet — document as known limitation

**Verify before merge:** `npm test`, incognito smoke on add/delete path.

**Suggested next:** `/devlearn-pre-ship` if opening PR today.
```

## Progress.md Last session block

```markdown
## Last session
- **Date:** 2026-05-24
- **Summary:** Wired localStorage persistence for todos; learned DOM + events.
- **Next:** APIs skill or deploy when ready.
```

## Concepts table append

```markdown
| localStorage | Browser key-value store for strings | 2026-05-24 |
```

## When conversation-only recap

If no files:

1. List 3 things agent **changed** (from memory)
2. List 2 terms **explained**
3. Offer `/devlearn-onboard` to persist next time

## Integration with teach-while-coding

| Event | Who updates progress |
|-------|---------------------|
| After each lesson block | meta skill may append concept |
| End of session / `/devlearn-recap` | this skill consolidates Last session |

Avoid duplicate concept rows — merge same concept with new date in Reference column if glossary has file:line.
