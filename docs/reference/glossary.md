# Glossary

| Term | Meaning |
| --- | --- |
| acceptance criterion | One verifiable requirement, usually `AC-NNN`. |
| ADR | Decision record. Kept and superseded, not rewritten. |
| agent run summary | Worker record in the task packet: changed files, results, output links, blocked questions. |
| AGENTS.md | Always-loaded agent context and command table. |
| audit | Present-state report. Observes, does not prescribe. |
| bug report | Diagnosis of one defect. |
| change plan | Structural change plan with waves and preservation guarantees. |
| Close | Final loop step: merge or block, update board, save findings. |
| distinct-lens review | Multiple reviewers with different focuses. |
| drift | Requirement and implementation diverged after earlier evidence. |
| Dropped from sources | Spec section for source asks intentionally left out. |
| durable record | Kept for project life: accepted specs, ADRs, findings. |
| evidence | Pasted output, CI link, or named manual observation. |
| evidence path | Files and checks exercised by the last valid evidence. |
| finding | Durable lesson saved at Close. |
| honesty level | convention, checklist, toolable, enforced. |
| intake | Verbatim source snapshot. |
| inventory | Present-state map before brownfield work. |
| multi-repo workspace | One workspace governing several code repos. |
| non-goal | Explicit out-of-scope behavior. |
| open question | Unresolved spec question. Blocking questions keep specs draft. |
| preservation guarantee | Behavior a change plan must preserve. |
| Pull | Capture upstream ask into intake. |
| requirement | Binding behavior plus verification. |
| research | Source-backed inquiry. No decision. |
| review by exception | Read coverage, failures, and exceptions before the diff. |
| review packet | Per-task review record. |
| review result | Pass, Fail, Unverified, or Blocked. |
| review stance | Optional reading posture, such as skeptic or auditor. |
| risk-weighted review | More review for higher-risk change shape, diffusion, churn, or impact. |
| Run | Worker implements and records evidence. |
| scout | Read-only delegated helper. |
| six-step loop | Pull, Spec, Task, Run, Review, Close. |
| SOL | Optional structured requirement notation selected by `format: sol`. |
| source authority | Rule for which artifact governs when intent conflicts. |
| spec | Intended behavior and verification. |
| split work | Turn spec or change plan into task packets. |
| status board | `status.md`. Hand-edited board and index. |
| structured requirements | Plain `AC-NNN` requirements or SOL blocks over the same record. |
| task packet | Bounded work order for an agent or person. |
| transitory output | Short-lived output such as run logs and check output. |
| verification method | Type of evidence: test, static, contract, manual, etc. |
| `Verify with:` | Spec line naming how to check a requirement. |
| watchlist | Vague terms that need same-line criteria. |
| wave | One verified stage of a change plan. |
| worker | Implementer that owns a task and returns a run summary. |
| workspace | Repo or folder holding Corpus artifacts. |
| worktree | Separate checkout for one task. |
| writing rules | Requirement hygiene rules. |

## Internal terms

| Internal | Public term |
| --- | --- |
| APS | writing rules |
| obligation | requirement |
| pass | step |
| profile | review stance |
| promote | save a finding |
| proof | evidence |
| spec repo | workspace |
| trace | agent run summary |
| verdict | review result |

## Related

- [Cheatsheet](cheatsheet.md)
- [Artifact formats](artifact-formats.md)
- [Checks](checks.md)
