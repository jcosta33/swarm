# Lineage — what Suspec keeps from heavyweight engineering

Suspec is lean, but the needs it serves are old. Requirements specifications, design descriptions,
verification plans, technical reviews, traceability, and change control all solved a real coordination
problem: many people, long durations, changing requirements, and the need to know both what was
*intended* and what was actually *verified*. The durable lesson was never "write lots of documents" —
it was **make intent, verification, and change control explicit**. Standards say as much: the amount of
formality is meant to scale with the work, and "documents" may be files, models, or records, not paper.

Suspec keeps those **functions** and collapses the **forms** — one authoritative living spec plus
machine-captured execution, atomic findings, and small decision records, instead of a document stack.
The table maps each legacy function to where it lives now.

| Legacy practice | Function it served | In Suspec |
| --- | --- | --- |
| Requirements specification | verifiable intent, stably-identified | the **spec** — acceptance criteria with stable ids + a `Verify with:` line each ([[ISO29148]]) |
| Design description | communicate design to stakeholders | the spec's design notes; a **decision** record when the trade-off is durable ([[ISO42010]] — decisions + rationale are required architecture elements) |
| Verification & validation plan | what will be checked, and how | the spec's `Verify with:` lines + the review's evidence ([[ISO29148]]) |
| Technical review / inspection | structured gating, not a comment thread | the **review** packet — requirement coverage + human-attention, independent of the author |
| Traceability matrix | requirement ↔ evidence | generated from ids: the review's coverage table + the spec's `## Execution` digest, not a hand-kept matrix |
| Anomaly / defect report | one durable problem record | a **finding** (atomic, linkable) |
| Change-control record | manage the baseline deliberately | the living spec's status lifecycle + supersession ([[ISO42010]]); ADRs supersede, never rewrite ([[NYGARDADR]] / [[MADR]]) |
| Architecture Decision Record | short, durable rationale for one choice | a **decision** — kept verbatim, marked superseded with a pointer |
| Build / test / CI output | raw execution record | run output is transitory ([[GHRETENTION]] / [[GLRETENTION]]); its durable residue is the spec's `## Execution` |
| Literate programming | explain intent close to the executable form | the spec is the human-readable anchor of the change |

Two disciplines carry the weight that the dropped paperwork used to:

- **Review is participation, not a sign-off.** Coverage and substantive engagement predict quality;
  a rubber-stamp does not ([[MCINTOSH14]]).
- **A review check earns blocking only when it is precise.** A noisy check gets ignored; the bar is a
  low effective-false-positive rate ([[GOOGLESA]]) — which is why Suspec checks are advisory until
  measured (see [principles](principles.md), honesty level *toolable*).

What Suspec deliberately does **not** revive: a separate document per change, a hand-maintained
traceability matrix, a routine standalone test plan, or a generic detached review checklist. Those are
the forms that rot ([[DOCROT]]) and duplicate ([[DOCPERSPECTIVE]]) — the measured failure modes a lean
record set exists to avoid.

## Related

- [Principles](principles.md) · [Drift](drift.md) · [Artifact formats](artifact-formats.md)
- [Sources](../research/sources.md) — the evidence each claim above resolves to
