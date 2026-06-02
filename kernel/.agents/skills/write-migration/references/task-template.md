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

> ⚠️ **MIGRATION SESSION** — Plan in waves. The codebase must remain functional after each wave, not only at the end. Every file is migrated individually and verified — no bulk codemods, no shell loops. Run `{{cmdValidate}}` after every wave; never let two waves' worth of breakage accumulate.
>
> **AGENTS.md:** `{{cmdValidate}}` / `{{cmdTest}}` / `{{cmdInstall}}` resolve from `AGENTS.md > Commands`. Non-contract values (`{{cmdBenchmark}}`, `{{cmdValidateDeps}}`, `{{cmdTypecheck}}`) — ask the user. If `AGENTS.md` is missing, ask before substituting.

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
- [ ] Self-review: Behaviour preservation answered (equivalence check named and pasted)
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

- *** (concrete starting points; most migrations span multiple sessions, so this file must let the next session pick up at the next wave)

## Self-review

> **Hard gate.** Every question below has a written answer directly beneath it. Migrations fail in two characteristic ways — a wave that left the codebase half-migrated, and a "completion" that left old-API callsites lurking. Review as a senior engineer hostile to both.

### Verification outputs (paste actual command output — do not paraphrase)

- `git status` →
- Per-wave `{{cmdValidate}}` outputs:
- Final `{{cmdValidate}}` (last 2 lines):
- Final `{{cmdTest}}` (last 2 lines):
- `grep -rn "<old-api-marker>"` showing remaining callsites (should be zero or only inside shims):
- **`behaviour-preservation`** — the equivalence check that would *fail if behaviour changed* (property-based / differential / golden-output). Name the check and paste its result:

  > _If no stronger check than the existing suite was available, paste the suite result here and record in **Behaviour preservation** below why the suite is a sufficient oracle for this migration._

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
- What equivalence check proves behaviour is unchanged — one that would *fail if behaviour changed* (property-based / differential / golden-output)? A green existing suite is necessary but not sufficient. If you relied on the existing suite alone, state explicitly why it is a sufficient oracle for this migration (e.g. the migrated callsites are exhaustively covered by named tests — show the coverage).
  Answer:

### Final state

- Is the old API removed, or is its removal scheduled with a clear timeline and tracked in your audits directory? Are there any TODOs, half-migrated files, or stub-shimmed modules left behind?
  Answer:

### Final Polish

- Did you ask yourself: "What did I leave behind? Where might a callsite hide that grep won't find — dynamic dispatch, string-based lookup, generated code?"
  Answer:
