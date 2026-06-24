# Step bars

A step bar is the pass/fail bar for one loop step.

It checks the transformation from input artifact to output artifact.

## How to use

1. Read the input artifact.
2. Read the output artifact.
3. Check each predicate.
4. Report failures.

One failing predicate fails the step.

## Pull

Input: upstream source.

Output: intake.

| Predicate | Holds when |
| --- | --- |
| Verbatim snapshot | source text is copied, not rewritten |
| Provenance present | `source`, `url`, and `captured` are filled |
| No editorializing | intake adds no interpretation |

## Spec

Input: intake and sources.

Output: spec.

| Predicate | Holds when |
| --- | --- |
| Requirement form | every requirement has an id and verification |
| Stance preserved | asks stay asks; observations stay observations |
| Uncertainty surfaced | ambiguity is in Open questions or explicit interpretation |
| Nothing invented as sourced | new decisions are visible as decisions |

## Task

Input: spec or change plan.

Output: task packet.

| Predicate | Holds when |
| --- | --- |
| Scope from source | every scoped id exists upstream |
| Boundaries declared | `Do not change` is real, not boilerplate |
| Checks mapped | each scoped requirement has a verify item |

## Run

Input: task packet and diff.

Output: run summary.

| Predicate | Holds when |
| --- | --- |
| Changed files complete | summary names every changed file |
| Real output pasted | verify commands include real output |
| Out-of-scope edits declared | exceptions are named with reason |
| Stuck means stop | unmet requirements are reported, not bypassed |

## Review

Input: spec, task, run summary, diff.

Output: review packet.

| Predicate | Holds when |
| --- | --- |
| Coverage complete | every scoped requirement has a row |
| Empty evidence means Unverified | no empty-evidence Pass rows |
| Exceptions routed | Human attention covers all triggers |
| Gate honest | suggested decision matches evidence |
| Spot-check recorded | at least one green row was rechecked |

## Close

Input: finished task record.

Output: workspace state.

| Predicate | Holds when |
| --- | --- |
| Findings saved | durable lessons moved to findings or another durable home |
| Board updated | `status.md` reflects the close |
| Nothing pending | blocked questions and follow-ups are visible |

## Cross-step predicates

| Predicate | Meaning |
| --- | --- |
| Re-parses clean | written files still match their `type:` |
| Chain unbroken | requirement -> task -> review ids resolve |
| Result matches evidence | row result agrees with evidence |
| Drift surfaced | mismatch is visible, not silently passed |

## Advanced lifecycle bars

For the advanced lifecycle:

| Step | Bar |
| --- | --- |
| author | Spec bar |
| lint | all blocking checks reported; no edits |
| improve | same meaning; blocking defects fixed or carried |
| lower | ids, verification, dependencies, surfaces preserved |
| decompose | disjoint work, assigned requirements, dependency order |
| implement | Run bar plus scope predicate |
| verify | all named checks run or blocked |
| review | Review bar plus lifecycle markers |
| promote | Close bar plus provenance |

## Related

- [Basic workflow](../02-basic-workflow.md)
- [Checks](checks.md)
- [Advanced lifecycle](advanced-lifecycle.md)
