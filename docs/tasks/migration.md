# 📋 Task: migration

> **TL;DR.** Move the codebase from API A to API B mechanically across many call sites. Lead persona is The Migrator. Plan in waves; the codebase must compile and pass tests after each wave, not only at the end. No bulk codemods.

---

## 🎯 When to use

A `migration` task is right when:

- A migration plan (or a spec acting as one) defines the source and target APIs.
- Many call sites need the same mechanical change.
- Behaviour is preserved (it's a *surface* change, not a *semantic* change).

If behaviour changes, it's `rewrite`. If it's a single file with a small change, it's `refactor`. If it's a dependency version bump rather than an API replacement, it's `upgrade`.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `migration plan` or `spec.md`                      |
| **Lead persona**     | [The Migrator](../personas/the-migrator.md)       |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review of each wave) |
| **Output**           | Codebase using the target API; old API removed (or scheduled) |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-refactor` (overlap), `empirical-proof` |
| **Verification gate slots** | `cmdInstall` (pre), `cmdValidate` (per wave), `cmdValidate` (post), `cmdTest` (post), migration-coverage check (post) |

---

## 📐 Template

````markdown
# {{title}}

## Metadata

- Slug: {{slug}}
- Agent: {{agent}}
- Branch: {{branch}}
- Base: {{baseBranch}}
- Worktree: {{worktreePath}}
- Created: {{createdAt}}
- Status: active
- Type: migration

---

> ⚠️ **MIGRATION SESSION** — Plan in waves. The codebase must remain functional after each wave, not only at the end. Every file is migrated individually and verified — no bulk codemods, no shell loops over files. Run `{{cmdValidate}}` after every wave; never let two waves' worth of breakage accumulate.
>
> **PERSONA:** Load `.agents/skills/personas/SKILL.md` and adopt **The Migrator** persona.

---

## Objective

What is being migrated, from what, to what, and why now. One paragraph maximum.

---

## Linked docs

- Migration spec: `{{specFile}}`
- Triggering audit (if any): `<path>`

---

## Migration source and target

<migration_source_target>

**From:** the API, framework, or pattern being replaced. Include the version if relevant.

**To:** the API, framework, or pattern replacing it. Include the version if relevant.

**Reason:** one sentence on why the migration is happening now.

</migration_source_target>

---

## Wave plan

<wave_plan>

The migration is broken into waves. The codebase must compile and pass tests after each wave.

| Wave | Scope | Callsites | Validation gate |
| ---- | ----- | --------- | --------------- |
| 1    |       |           | `{{cmdValidate}}` |
| 2    |       |           | `{{cmdValidate}}` |
| ...  |       |           |                 |

</wave_plan>

---

## Compatibility shims

<shim_contracts>

Every shim added so the old surface continues to work during the migration. Do not remove a shim until all consumers are migrated.

| Shim path | Forwards to | Removable when |
| --------- | ----------- | -------------- |
|           |             |                |

</shim_contracts>

---

## Callsite tracker

<callsite_tracker>

Total callsites of the old API: _[count once known]_

Tracking by wave:

| Wave | Callsites in scope | Migrated | Remaining |
| ---- | ------------------ | -------- | --------- |
| 1    |                    |          |           |

</callsite_tracker>

---

## Constraints

- Work only inside this worktree
- Do not switch branches unless explicitly instructed
- Do not merge, rebase, or push unless explicitly instructed
- Run `{{cmdInstall}}` to install dependencies
- **Run `{{cmdValidate}}` after every wave — mandatory, not optional**
- No bulk codemods, no shell loops, no automated mutations across many files
- Each file migrated individually and verified
- Document every shim in the table above before adding it; document removal criteria
- The codebase must compile and pass tests after each wave (not only at the end)
- **Proactively research and read related docs.** Browse `.agents/specs/`, `.agents/research/`, `docs/`, and `AGENTS.md` as needed.

---

## Progress checklist

- [ ] Read migration spec in full
- [ ] Fill in source/target above
- [ ] Plan waves; fill in the wave table
- [ ] Count callsites of the old API; fill in the tracker
- [ ] Begin wave 1
- [ ] `{{cmdValidate}}` after wave 1 — paste output
- [ ] Begin wave 2 (only after wave 1's validation passes)
- [ ] `{{cmdValidate}}` after wave 2 — paste output
- [ ] _… per wave …_
- [ ] All shims documented with removal criteria
- [ ] Final pass: `{{cmdValidate}}` and `{{cmdTest}}` clean
- [ ] Old API fully removed (or removal scheduled with a clear timeline)
- [ ] Self-review: Verification outputs pasted
- [ ] Self-review: Wave integrity answered
- [ ] Self-review: Callsite coverage answered
- [ ] Self-review: Shim contracts answered
- [ ] Self-review: Behaviour preservation answered
- [ ] Self-review: Final state answered

---

## Decisions

- ***

## Findings

- ***

## Assumptions

- [pending]

---

## Blockers

- ***

## Next steps

Concrete starting points for the next session if this one ends incomplete. Most migrations span multiple sessions; the next session should be able to pick up at the next wave from this file alone.

- ***

## Self-review

<self_review>

Stop. Migrations fail in two characteristic ways: a wave that left the codebase in a half-migrated state, and a "completion" that left old-API callsites lurking. Act as a senior engineer about to ship the migration, hostile to both failure modes.

> **Hard gate.** The task is not complete until every question below has a written answer directly beneath it.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Per-wave `{{cmdValidate}}` outputs:
- Final `{{cmdValidate}}` (last 2 lines):
- Final `{{cmdTest}}` (last 2 lines):
- `grep -rn "<old-api-marker>"` showing remaining callsites (should be zero or only inside shims):

### Wave integrity

- Did every wave end with the codebase in a working state? Did `{{cmdValidate}}` pass at every wave checkpoint? Are the per-wave outputs pasted above?
  Answer:

### Callsite coverage

- Did you grep the entire codebase for the old API, not just the modules you expected to find it in? Is the callsite count in the tracker accurate? Are zero callsites of the old API remaining outside of shims?
  Answer:

### Shim contracts

- Is every shim documented with a removal criterion? Do the criteria reference verifiable conditions (e.g. "no callers outside this shim — verifiable by grep")? Are any shims that should have been removed in this migration still present?
  Answer:

### Behaviour preservation

- Did the migration change behaviour anywhere? A migration is a mechanical change of surface, not a rewrite of semantics. If behaviour did change, is it documented and was a spec/audit updated?
  Answer:

### Final state

- Is the old API removed, or is its removal scheduled with a clear timeline and tracked in `.agents/audits/`? Are there any TODOs, half-migrated files, or stub-shimmed modules left behind?
  Answer:

### Final Polish

- Did you ask yourself: "What did I leave behind? Where might a callsite hide that grep won't find — dynamic dispatch, string-based lookup, generated code?" Do not leave the work without this final adversarial pass.
  Answer:

Only when every answer above is written is this task complete.

</self_review>
````

---

## 🛠️ Worked example

See [The Migrator's worked example](../personas/the-migrator.md#%EF%B8%8F-example-how-the-migrator-resolves-a-representative-issue) for a migration that hits a wave-failure on a generic-context exception and course-corrects.

---

## ⚠️ Common anti-patterns

- Bulk codemods touching hundreds of files
- Skipping per-wave validation ("this wave is small")
- Shims with no removal criteria
- "Mostly migrated" final state
- Behaviour drift bundled into the migration

---

## See also

- [`personas/the-migrator.md`](../personas/the-migrator.md)
- [`tasks/upgrade.md`](upgrade.md) — close cousin (dependency / framework version)
- [`tasks/refactor.md`](refactor.md) — when scope is single-module
- [`documents/extended.md`](../documents/extended.md) — the migration plan format
- [`skills/write-refactor.md`](../skills/write-refactor.md)
