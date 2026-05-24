# DevLearn depth levels

Read `DEVLEARN.md` in the project root. Default **depth: vibe**, **persona: viber** (or autodetect result).

## Persona × depth matrix

| | vibe | curious | deep |
|---|------|---------|------|
| **viber** | Short lesson block | + try-it-yourself | + topic links + diff offer |
| **seasoned** | Silent unless whitelist | Decision block on whitelist | Full decision + decisions.md row |
| **autodetect** | Start viber vibe | Bump on "why/how" questions | Bump on "tradeoff/architecture" language |

## Autodetect signals

| Signal | Lean persona |
|--------|----------------|
| "I'm new", "what is", "ELI5" | viber |
| "tradeoff", "blast radius", "PR review", "ADR" | seasoned |
| Uses framework jargon correctly | seasoned |
| No signal | viber |

## vibe (viber)

- One lesson block per logical change set
- Max ~5 short bullets total
- Skip try-it-yourself unless asked
- One term per lesson

## curious (viber)

- Full lesson block + try-it-yourself
- Up to 2 file:line anchors
- One alternative approach
- Suggest explain-diff after large change sets

## deep (viber)

- Expanded why + failure modes
- 2–3 anchors + data flow in plain English
- Topic skill links + glossary/diff offers

## seasoned (all depths)

**vibe depth = quiet mode:** no block unless `seasoned_lessons_on` tag matches OR user asks.

When emitting, use [decision-block.md](decision-block.md) not lesson-block.md.

| Tag in seasoned_lessons_on | Teach when |
|----------------------------|------------|
| architecture | Structure, patterns, modules |
| security | Auth, secrets, validation |
| breaking | Contract/migration changes |
| deps | New dependencies |
| perf | Measurable perf work |

## Runtime overrides

| User says | Effect |
|-----------|--------|
| "just ship" / "no lessons" | Skip blocks |
| "more detail" | Bump depth one level |
| "less detail" | Force vibe |
| "explain like PR review" | seasoned + decision block |
| "teach me like I'm new" | force viber |

## Batching

One block = one intent. Vibe: merge unrelated fixes into one summary. Seasoned: at most one decision block per response unless user asks for full review.
