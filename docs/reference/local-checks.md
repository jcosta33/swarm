# Local checks

Suspec core checks are generic.

Project-specific checks belong to the project.

## Ownership

| Layer | Owns |
| --- | --- |
| Suspec core CLI | generic artifact checks |
| Workspace | command slots and local policy |
| Code repo | build, test, lint, typecheck |
| Local scripts | project-specific predicates |

Core stays portable. Product checks stay local.

## Name the predicate

Name checks after what they prove.

| Avoid | Use |
| --- | --- |
| `no-regressions-check` | `baseline-regression-check` |
| `complete-review` | `declared-scope-coverage` |
| `correctness-check` | `artifact-shape-check` |

A local script proves only its predicate.

It can prove:

- declared artifacts exist
- declared commands ran
- snapshots match
- declared scope was touched
- parseable structure is valid

It cannot prove:

- no regressions anywhere
- complete correctness
- behavior outside the declared evidence path

Anything outside the predicate is `Unverified`, `Blocked`, or Human attention.

## Honesty level

Mark local checks honestly:

- convention
- checklist
- toolable
- enforced by this team's gate

If a script cannot run, it returns `Unverified` or `Blocked`. It does not guess `Pass`.

## Related

- [Checks](checks.md)
- [Future CLI](future-cli.md)
- [Source authority](source-authority.md)
- [Reviewing output](../08-reviewing-output.md)
