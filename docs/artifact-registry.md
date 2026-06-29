# Artifact registry

The single source of truth for **every Suspec agent, skill, and MCP tool** across the repo family,
each with a lifecycle **status**. Product and reference docs **link here** instead of restating an
artifact's location or active/retired status — a cross-repo fact stated once drifts in one place, not
in N ([ADR-0114](./adrs/0114-retired-artifact-registry.md), grounded by
[ADR-0043](./adrs/0043-checkable-documents.md)).

The companion linter [`scripts/lint-artifact-refs.sh`](../scripts/lint-artifact-refs.sh) reads the
**non-active** names below and fails any product/reference doc that names one as if it were live. This
registry file and the redirect-stub files that legitimately self-name are the only places a non-active
name may appear outside the immutable history (ADRs) and changelogs.

## Status values

| Status               | Meaning                                                                        |
| -------------------- | ------------------------------------------------------------------------------ |
| `active`             | Live and installable in its stated home.                                       |
| `active (kit)`       | Live, but ships from the **starter kit** (`../suspec-starter-kit/.agents/skills/`), not the catalog ([ADR-0112](./adrs/0112-two-tier-skills.md)). |
| `redirect-stub`      | The name resolves but the artifact only points elsewhere; names its target.    |
| `retired`            | Gone; names its replacement, or none.                                          |
| `relocated→<target>` | Moved; names the new home.                                                      |

## Agents

Source: [`../suspec-agents/agents/`](https://github.com/jcosta33/suspec-agents) ([ADR-0092](./adrs/0092-suspec-agents-member.md)).

| Name                     | Status                                          | Notes                                                                                  |
| ------------------------ | ----------------------------------------------- | -------------------------------------------------------------------------------------- |
| `suspec-reviewer`        | active                                          | Reviews a finished task/PR; proof-first mode re-runs Verify + pastes evidence, no verdict. |
| `suspec-auditor`         | active                                          | Present-state audit of a code area.                                                    |
| `suspec-challenger`      | active                                          | Pressure-tests a not-yet-built proposal/spec/plan.                                     |
| `suspec-spec-author`     | active                                          | Authors/revises specs.                                                                 |
| `suspec-documentarian`   | active                                          | Authors product/reference documentation.                                              |
| `suspec-researcher`      | active                                          | Surveys options/evidence behind one decision-informing question.                       |
| `suspec-explorer`        | retired (→ built-in Explore agent)              | Code-location is the built-in **Explore** agent + the `codebase-exploration` skill; there is no separate `suspec-explorer`. |
| `suspec-evidence-checker`| redirect-stub (→ `suspec-reviewer` proof-first) | Folded into `suspec-reviewer`'s proof-first mode; stub stays only to redirect inbound references. |

## Skills

Catalog source: [`../suspec-skills/skills/`](https://github.com/jcosta33/suspec-skills) ([ADR-0112](./adrs/0112-two-tier-skills.md)).
Kit source: [`../suspec-starter-kit/.agents/skills/`](https://github.com/jcosta33/suspec-starter-kit).

### Universal catalog (suspec-skills)

| Name                 | Status                                | Notes                                                       |
| -------------------- | ------------------------------------- | ----------------------------------------------------------- |
| `adversarial-review` | active                                | Refute-by-default review; absorbs the former `persona-skeptic`. |
| `codebase-exploration` | active                              | Depth discipline for the built-in Explore agent.            |
| `concise-output`     | active                                | Signal-dense, evidence-first output.                        |
| `debugging`          | active                                | Root-cause from runtime evidence.                           |
| `empirical-proof`    | active                                | Bind every completion claim to verbatim output.             |
| `fix-flaky-test`     | active                                | Stabilize a non-deterministic test.                         |
| `git-pr`             | active                                | Ship a change end to end.                                   |
| `persona-challenger` | active                                | Pressure-test a live idea before it is committed.           |
| `persona-surveyor`   | active                                | Breadth/inventory research.                                 |
| `planning-spec`      | active                                | Plan a non-trivial change before fan-out.                   |
| `security-review`    | active                                | Security-focused review pass.                               |
| `persona-skeptic`    | redirect-stub (→ `adversarial-review`)| Merged into `adversarial-review`; folder remains as a redirect. |

### Kit guides (suspec-starter-kit)

The kit's authoring guides ship from the starter kit, not the catalog ([ADR-0112](./adrs/0112-two-tier-skills.md)).

| Name                  | Status       | Notes                                  |
| --------------------- | ------------ | -------------------------------------- |
| `implement-task`      | active (kit) | Implement a task packet.               |
| `review-output`       | active (kit) | Build the review packet.               |
| `save-findings`       | active (kit) | Route durable discoveries home.        |
| `spec-check`          | active (kit) | Check a spec against the core checks.  |
| `split-work`          | active (kit) | Split a spec/plan into task packets.   |
| `write-spec`          | active (kit) | Author/revise a spec.                  |
| `write-prd`           | active (kit) | Author a PRD.                          |
| `write-rfc`           | active (kit) | Author an RFC.                         |
| `write-research`      | active (kit) | Author a research note.                |
| `write-audit`         | active (kit) | Author an audit.                       |
| `write-bug-report`    | active (kit) | Author a diagnosis-only bug report.    |
| `write-inventory`     | active (kit) | Author an inventory.                   |
| `write-change-plan`   | active (kit) | Author a change plan.                  |
| `write-documentation` | active (kit) | Author documentation. (`relocated→kit` from any catalog framing — its single home is the kit.) |
| `write-feature`       | active (kit) | Implement a feature.                   |
| `write-fix`           | active (kit) | Implement a fix.                       |
| `write-refactor`      | active (kit) | Implement a refactor.                  |
| `write-rewrite`       | active (kit) | Implement a rewrite.                   |
| `write-migration`     | active (kit) | Implement a migration.                 |
| `write-performance`   | active (kit) | Implement a performance change.        |
| `write-testing`       | active (kit) | Implement tests.                       |

## MCP tools

Source: [`../suspec-mcp/src/tools.ts`](https://github.com/jcosta33/suspec-mcp) (`server.registerTool(...)`).

| Name                            | Status                              | Notes                                                        |
| ------------------------------- | ----------------------------------- | ----------------------------------------------------------- |
| `suspec_get_status`             | active                              | Workspace status.                                           |
| `suspec_check_workspace`        | active                              | Run workspace checks.                                       |
| `suspec_check_file`             | active                              | Check a single file.                                        |
| `suspec_get_task`               | active                              | Read a task packet.                                         |
| `suspec_get_spec`               | active                              | Read a spec.                                                |
| `suspec_get_review`             | active                              | Read a review packet.                                       |
| `suspec_get_checks`             | active                              | Read the checks contract.                                   |
| `suspec_reconcile`              | active                              | Reconcile workspace/board state.                            |
| `suspec_list`                   | active                              | List workspace artifacts.                                   |
| `suspec_scaffold_spec`         | active                              | Scaffold a spec.                                            |
| `suspec_split_task`             | active                              | Scaffold split task packets.                                |
| `suspec_scaffold_finding`       | active                              | Scaffold a finding candidate.                               |
| `suspec_scan_task`              | retired                             | No replacement; folded into the scaffold/check tools.       |
| `suspec_validate_review_packet` | retired                             | No replacement; review validation lives in `suspec_get_review` + the checks contract. |
| `suspec_reconcile_review`       | retired                             | No replacement; reconciliation is `suspec_reconcile`.       |
