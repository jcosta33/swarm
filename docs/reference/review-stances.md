# Review stances

A stance is a reading posture.

It changes what the reviewer looks for. It does not change the artifact format.

## Stance shape

Each stance states:

- prevents
- default questions
- required evidence
- refuses
- self-review delta
- applies
- does not apply

## Stances

### Architect

Use for specs.

Focus:

- intent over implementation
- verifiable requirements
- existing boundaries before new ones

Refuses:

- hidden algorithms in requirements
- uncheckable requirements

### Skeptic

Use for review.

Focus:

- refute completion claims
- rerun or inspect evidence
- treat worker summaries as claims, not proof

Refuses:

- `tests passed` with no output
- implementer judging own work
- softened findings to avoid blocking

### Surveyor

Use for breadth research.

Focus:

- patterns across many examples
- named instances
- observation separate from claim

Refuses:

- pattern claims from one example
- recommendations without a decision step

### Challenger

Use before committing to a proposal.

Focus:

- pressure-test assumptions
- steelman alternatives
- cite external counterexamples or checks

Refuses:

- strawman alternatives
- re-deciding the proposal inside the challenge

### Auditor

Use for audits.

Focus:

- present-state observations
- file and line evidence
- severity by blast radius

Refuses:

- prescriptions inside findings
- structural claims without search or inspection

### Researcher

Use for depth research.

Focus:

- primary sources
- evidence before claim
- no decision

Refuses:

- recommendations disguised as research
- secondary sources when primary sources exist

### Documentarian

Use for human-facing docs.

Focus:

- one reader question
- one Diataxis frame
- examples run as written
- claims tied to source

Refuses:

- unrun examples
- mixed tutorial/reference/how-to/explanation

## Judge independence

When judgment is model-based:

- implementer and reviewer are different
- avoid same-lineage judge when possible
- use two independent judges for high-risk work

Deterministic checks do not count as the implementer judging itself.

## Distinct lenses

When using multiple reviewers, give each a different focus:

- correctness
- maintainability/design
- security/reproduction

Do not repeat the same read twice unless the risk calls for redundancy.

## Related

- [Advanced lifecycle](advanced-lifecycle.md)
- [Reviewing output](../08-reviewing-output.md)
- [Agent guides](agent-guides.md)
