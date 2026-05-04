# 📋 Task: upgrade

> **TL;DR.** A specialised migration for dependency / framework / language version bumps. Same persona (The Migrator), same wave discipline, same per-wave validation. The distinction is purely in the source of the change — an external library version, not an internal API replacement.

---

## 🎯 When to use vs `migration`

| If the change is…                                                                | Task type    |
| -------------------------------------------------------------------------------- | ------------ |
| Replacing one of *our* APIs with another of *our* APIs across many call sites    | `migration`  |
| Bumping an *external dependency* version (React 18 → 19, Node 20 → 22, Django 4 → 5) | `upgrade`    |
| Bumping a language version that requires source changes (TypeScript 5.4 → 5.5)   | `upgrade`    |
| Upgrading a tool whose API changes (pnpm 8 → 9 with config-file changes)         | `upgrade`    |

Mechanically, `upgrade` and `migration` use the same template, persona, and discipline. The split exists because:

- The source doc is usually *external release notes / migration guide*, not an internal `migration plan`.
- Validation often includes running the project's full integration suite, not just unit tests, because the upgrade can touch behaviour we don't directly own.
- The "old API" concept is a *previous version*, not a *deprecated internal API*.

---

## 🧬 Metadata

| Field                | Value                                              |
| -------------------- | -------------------------------------------------- |
| **Source doc**       | `migration plan` (often citing external release notes) |
| **Lead persona**     | [The Migrator](../personas/the-migrator.md)       |
| **Secondary**        | [The Skeptic](../personas/the-skeptic.md) (review per wave) |
| **Output**           | Codebase compatible with the upgraded dependency / version |
| **Auto-loaded skills** | `manage-task`, `documentation-gatekeeper`, `personas`, `write-refactor`, `empirical-proof` |
| **Verification gate slots** | Same as `migration` + `cmdInstall` (must succeed first), `cmdBuild` (post) where applicable |

---

## 📐 Template

Use the [`migration` template](migration.md#-template), with these adaptations:

- `Type: upgrade`
- `## Migration source and target` becomes `## Upgrade source and target`:
  - **From:** the package version being replaced (e.g., `react@18.3.1`)
  - **To:** the package version replacing it (e.g., `react@19.0.0`)
  - **Reason:** what the upgrade unlocks (security fix, framework feature, end-of-life)
  - Cite the upstream's official migration guide as a `## Linked docs` entry
- The `<wave_plan>` table's "Validation gate" column should add `cmdBuild` to most waves (upgrades often expose build-time issues)
- Self-review's "Callsite coverage" question becomes "**Pattern coverage** — Did you grep for every deprecated/removed API in the upgraded dependency? Are zero callsites of removed APIs remaining?"

---

## 🛠️ Worked example: React 18 → 19

A migration plan at `.agents/migrations/react-19-upgrade.md` cites:
- React 19's official migration guide
- The codebase audit at `.agents/audits/react-18-removed-apis.md` listing the deprecated patterns we use

The Migrator:

1. **Wave 0 (preparation):** Update `package.json` (`react: 19.0.0`); run `{{cmdInstall}}`. Run `{{cmdBuild}}` and `{{cmdTest}}` to baseline what breaks.
2. **Wave 1 (legacy `ReactDOM.render` → `createRoot`):** ~15 callsites; manual review per file; per-wave `{{cmdBuild}}` and `{{cmdTest}}`.
3. **Wave 2 (`useEffect` cleanup semantic changes):** Identify hooks affected by React 19's stricter cleanup ordering; per-file review.
4. **Wave 3 (deprecated `unstable_*` APIs):** Audit-listed call sites.
5. **Final wave (cleanup):** Remove the `react-18-shim.ts` shim; run full integration suite.

Each wave ends with `{{cmdBuild}}`, `{{cmdValidate}}`, `{{cmdTest}}` outputs pasted, plus a `git grep -c <removed-API>` showing the count drop.

---

## ⚠️ Common anti-patterns

- Skipping `{{cmdBuild}}` in per-wave validation (upgrades often surface at build time, not test time)
- Bumping multiple major dependencies in one task (each is its own upgrade)
- Treating "tests pass" as sufficient when the upgrade may have changed behaviour the suite doesn't cover
- Trusting the upstream migration guide without verifying the cited deprecated patterns exist in *our* codebase

---

## See also

- [`tasks/migration.md`](migration.md) — the parent template
- [`personas/the-migrator.md`](../personas/the-migrator.md)
- [`documents/extended.md`](../documents/extended.md) — migration plan format
