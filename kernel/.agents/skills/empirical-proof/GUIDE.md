---
name: empirical-proof
type: fragment
description: >
  The proof discipline: every completion claim binds to pasted, re-runnable, real proof output.
  A bare "tests passed" or a schema-valid output is not a proof. Load this fragment when a `verify`
  or `review` pass records a `VERDICT` against a `VERIFY BY` binding, or when any pass makes a
  verifiable claim about behaviour. This fragment carries the *procedure*; the proof taxonomy, the
  verdict model, and "what is not a proof" are owned by the language reference (SOL §15, §15.9, §17)
  and the typed IR — this file never redefines them.
---

# Pass guide: empirical-proof (cross-cutting fragment)

> **Fragment, not a standalone pass guide.** Per §26.3, `empirical-proof` is one of the two
> cross-cutting fragments: a pass-guide-shaped module (§26.5) that other pass guides *compose*
> rather than a guide a `task_kind` names directly. It is shared behind the `verify` and `review`
> passes (§26.2, §26.3). A pass guide for either pass loads this fragment; a `task.md` does not
> activate it on its own.
>
> **This fragment owns no semantics (§26.1, §17.1).** It does not define the nine proof types, the
> seven-value verdict model, the proof-strength order, the merge gate, or "what is NOT a proof" —
> those live in the language and verification references (`language/SOL.md`, `passes/verify.md`; §14, §15,
> §15.9, §15.10, §17) and the typed IR (§12). Every load-bearing term below is cited, not
> redefined: the citation is non-authoritative delivery, and where this fragment and the language
> reference disagree, the reference governs. This fragment is the *procedure* for applying the
> proof discipline that those layers own.

## Purpose

Eliminate hallucinated completion. A model is a pattern-completer; the pattern of a "successful
task" includes confident completion language ("all tests pass", "looks correct") that the model
will emit regardless of whether the underlying claim is true. The proof discipline is the
structural defence: a `VERDICT` of `PASS` cannot be recorded without first pasting the real,
re-runnable output that the bound proof actually produced. The governing invariant is **CODE IS
REALITY** (§2): a proof can falsify an obligation but never silently amend its intent, and
**schema-valid output is not a proof — shape is not truth** (§15, §15.9).

## Consumes

- The obligation's `VERIFY BY` binding(s) — `<type>:<adapter>:<artifact>[#selector]` (§15.2). The
  `<type>` is one of the **nine** closed proof types (§15.1); the `<adapter>` resolves through
  `AGENTS.md > Commands` to a concrete command for *this* repo (§15.3). This fragment reads these;
  it does not define the type set or the resolution rule.
- The `AGENTS.md > Commands` table — the `cmd*` slots that *are* the adapters (§15.3). If a binding's
  adapter has no matching Commands row, the proof is not executable (`SOL-V002`) and surfaces as
  `BLOCKED`, never `PASS` — surface that, do not guess a command.
- The obligation's `RISK` (§18) where present — it sets how strong an oracle the obligation demands
  (§15.10.2); this fragment routes to the adequacy record, it does not define the RISK→oracle table.

## Produces

- The pasted, verbatim proof output that backs each `VERDICT`'s `EVIDENCE` clause (§14.2): the
  command run, its exit condition, and the runner's summary lines — never a paraphrase.
- For `RISK high`/`critical` obligations, a pointer to the `oracle_adequacy` record the verify pass
  requires (§15.10.1) — *what the oracle exercised relative to the obligation*, not merely that a
  command exited zero. This fragment does not define the adequacy schema (§15.10 owns it); it
  enforces that the proof output is the real footprint, so the adequacy record can be filled honestly.

## Preserves

The discipline preserves three things that distinguish a real proof from a plausible one:

- **The exact bytes of the run.** Output is pasted as data into a fenced block: no quoting, no
  Markdown styling, no annotation injected mid-paste, no truncation that hides the summary.
- **One proof per claim.** Each required `VERIFY BY` binding yields exactly one `VERDICT` (§15.7);
  each claim ("the linter is clean", "the regression test reproduces the defect", "no boundary
  violation") binds to its own pasted output. Bundling claims into a single "all good" hides which
  check actually ran.
- **Freshness.** A proof pasted before a later edit is stale and no longer backs the claim. The
  evidence path is what couples a proof to the surfaces it exercised (§15.10.4, drift in §16); a
  change to an exercised surface invalidates the prior `PASS`.

## Rejects

These MUST NOT yield `PASS` — the closed list is owned by §15.9 (this fragment restates it as the
rejection contract, it does not extend it):

- **Schema-valid output is not a proof.** That a tool emitted well-formed JSON, or that a
  structured-output call validated against its schema, says nothing about whether the *value* is
  correct (§15.9, §17.1). A binding whose only evidence is "output matched the schema" is
  `UNVERIFIED`.
- **"Tests passed" without output is not a proof.** A `PASS` whose `EVIDENCE` is the bare phrase
  "tests passed" — no command, no exit code, no run output, no selector resolution — is
  `UNVERIFIED`; a conformant review MUST reject it (§15.9).
- **A `manual` verdict without recorded reasoning is not a proof.** `manual` is the honest escape
  hatch (§15.1), not a blank cheque: it MUST carry a `REASON` and an `EVIDENCE` ref to the recorded
  judgment, and (per §17.6) a recorded judge identity, an independent reviewer, and — for
  `RISK high`/`critical` — dual judgment. A bare `manual PASS` is `UNVERIFIED`.

Also rejected as *predictions, not proof*: "should pass", "expected to work", "tests should be
green", and "obvious from the diff". A prediction is not a recorded run.

## Procedure

1. **Resolve the binding to a real command.** For each required `VERIFY BY` of each in-scope
   obligation, read its `<type>:<adapter>:<artifact>` and look the `<adapter>` up in
   `AGENTS.md > Commands` (§15.3). If the slot is undefined or missing, do not invent one: record
   the binding as not-executable and surface it (it is `SOL-V002` / `BLOCKED`, not `PASS`).
2. **Run it, in the right place.** Execute the resolved command against the change under judgment.
   In a `review` pass, run it *yourself* in your own worktree with the worker's branch checked out
   — the worker's pasted output does not satisfy the gate; only your own run does (§17.6.1: the
   implementer MUST NOT be the one who renders the verdict).
3. **Paste the output verbatim.** Put the command, its exit condition, and the runner's summary into
   a fenced block in the `EVIDENCE` of the `VERDICT`. Treat the output as data — copy it in, leave
   it alone. Include the summary line(s) (the runner's pass/fail tally plus timing/exit), not the
   first lines of noise.
4. **One paste per binding.** Record exactly one `VERDICT` per required binding (§15.7). Do not
   collapse several bindings into one "all checks pass" paste.
5. **Record what the oracle exercised, where required.** For a `RISK high`/`critical` obligation, a
   single concrete `test` is an inadequate oracle (§15.10.2): point the `oracle_adequacy` record
   (§15.10.1) at the real run — the surfaces it touched (the evidence path), and any
   mutation/metamorphic/property/coverage evidence that the example-based oracle is hard to fool.
   This fragment does not decide the threshold; it makes the recorded footprint truthful.
6. **Re-run after every change.** If you edit anything after pasting a proof, the proof is stale:
   re-run and re-paste. This fires repeatedly during refactor and migration work where validation
   recurs per wave/checkpoint.
7. **On a failed or unrunnable proof, do not soften the verdict.** A `FAIL` is `FAIL`; a proof that
   could not run is `BLOCKED` (truth unknown), never `PASS`. An environmental block is surfaced as a
   blocker, not silently marked complete. A failing obligation is accepted only by a `WAIVED`
   verdict carrying authority + reason + expiry, and the implementing agent MUST NOT self-issue it
   (§17.3) — that authority is a human or the spec owner.

## Output contract

Every `VERDICT` of `PASS` this fragment backs carries an `EVIDENCE` clause whose proof reference
points at a real, re-runnable run, with the run output pasted verbatim. Concretely:

- **Good** — verbatim, fenced, with the runner's summary and the resolved command:

  ````markdown
  VERDICT AC-001: PASS
  EVIDENCE test:unit:cmdTest:auth-refresh-expired-token#clears_session

  ```
  $ <resolved cmdTest command>
  Tests:       189 passed, 189 total
  Time:        4.832 s, exit 0
  ```
  ````

- **Bad** — paraphrased ("Validation: everything passes", "All 189 tests green"). The paraphrase is
  *plausible* and might even be *true*, but it is unverified: paraphrase does not satisfy the gate
  (§15.9).

This fragment produces *no* `verdict.md` — there is none. Verdicts live in `review.md` (the verdict
container, §14.5); this fragment fills the `EVIDENCE` of the blocks recorded there. It defines no
new block, modal, verdict value, proof type, or lint code (§26.1).

## Self-review delta

When this fragment is composed into a pass, the pass's self-review additionally confirms:

- Every completion claim in scope maps to an independent, pasted, re-runnable proof — none rests on
  the model's say-so (§17.1: every completion claim maps to independent verification).
- No `PASS` is backed only by schema-valid output, a bare "tests passed", or a reasoning-less
  `manual` verdict (§15.9).
- Each required `VERIFY BY` binding has exactly one `VERDICT` with its own pasted output; no claims
  are bundled (§15.7).
- No pasted proof predates a later edit (re-run-after-change; staleness via the evidence path,
  §15.10.4 / §16).
- In a `review` pass, the bound `cmd*` proofs were re-run by the reviewer, not trusted from upstream
  (§17.6.1).
- For `RISK high`/`critical` obligations, the `oracle_adequacy` record reflects what the oracle
  actually exercised (§15.10.1–§15.10.2).

## Common evasions and the response

The agent (or user) reasoning toward one of these should paste the response and run the proof — the
point is to make skipping the verification cost a visible exchange, not to win an argument.

| 🚩 Evasion                                          | Response                                                     |
| --------------------------------------------------- | ------------------------------------------------------------ |
| "I already ran it earlier in the session."          | Re-run after every change; the earlier run is stale.         |
| "It's obvious from the diff that the test passes."  | A diff does not run tests. Run them; paste the output.       |
| "Schema validated, so the output is correct."       | Shape is not truth (§15.9). A schema match is not a proof.   |
| "The CI will catch it."                             | The discipline is the agent's gate, not the CI's.            |
| "The output is too long to paste."                  | Paste the resolved command and the runner's summary, not the whole log. |
| "I'm reviewing in good faith — pasting is ceremony." | Trust is a vulnerability to remove, not a virtue; run it yourself (§17.6.1). |
| "The command failed for unrelated environmental reasons." | That is `BLOCKED`, surfaced as a blocker — never a silent `PASS` (§17.3). |

## Type-specific applications

The proof discipline is universal; each `task_kind` (§28) emphasises a different proof, per its
default suite (§15.8 — the suite is the authority for which proofs SHOULD bind; this is only where
the paste lands):

- **fix** — the regression test reproducing the defect, then passing after the fix.
- **refactor / migration** — per-wave/per-checkpoint validation and behaviour-preservation output.
- **performance** — baseline and target benchmark output under the *same* protocol.
- **testing** — test pass plus an assertion-flip (the test fails when the behaviour is broken).
- **documentation** — every code example actually run, output pasted.
- **review** — the bound proofs re-run by the reviewer in their own worktree (§17.6.1).

## Bundled resources

- [`references/evasions.md`](./references/evasions.md) — the full catalogue of evasions and their
  responses (the table above keeps the most frequent ones inline; the rest live there).
