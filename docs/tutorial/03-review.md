# Review

This page creates:

- `reviews/checkout-expiry.md`

Use a reviewer that did not implement the change.

## 1. Create the packet

```markdown
---
type: review
id: REVIEW-checkout-expiry
task: TASK-checkout-expiry
pr: none yet
reviewer: you
status: draft
---

# Review: Expired checkout session returns 409
```

## 2. Add coverage

The task scope has one requirement, so the table has one row:

```markdown
## Requirement coverage

| ID | Result | Evidence | Human attention |
| --- | --- | --- | --- |
| AC-001 | Pass | `npm run test:integration -- expired-session` -> `Tests: 3 passed, 3 total` | yes |
```

This is `Pass` because evidence is present.

If evidence is empty, the result is `Unverified`.

## 3. Spot-check

Record one green-row check:

```markdown
Spot-checked: AC-001 - reran `npm run test:integration -- expired-session`; output matched the evidence row.
```

For this fictional `shop-api`, the command is illustrative. In your repo, run it.

## 4. Route human attention

Checkout is a money path. Keep one attention item:

```markdown
## Human attention

1. Risky path: checkout validates the session before charging. Confirm the 409 path runs before any charge call.
```

## 5. Decide

```markdown
## Suggested decision

Merge. AC-001 passes with evidence. Review the money-path note before merging.
```

Set frontmatter:

```yaml
status: pass
```

Check:

- one row for `AC-001`
- evidence cell has output
- spot-check recorded
- human-attention item names the risk
- reviewer is independent

Next: [Close](04-close.md).
