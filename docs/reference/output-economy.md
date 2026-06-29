# Output economy

How agents should shape output: readable and economical, by convention (ADR-0109). A floor, not a rule
a tool enforces.

## The floor

- **Evidence first.** Lead with the result/finding and its evidence; put prose after, if at all.
- **Structure over prose.** Use a table or list when it carries the same signal in less space.
- **Signal-dense.** No filler, no restating the prompt, no persuasion. Cut what a reader would skim.
- **Reason free, emit lean.** Think in whatever form works; emit the structured artifact ([[FORMATFREE]]).
- **Justify to be checked, not to convince.** A "why" exists to make verification cheap — long
  persuasive prose raises trust without raising scrutiny ([[OVERRELIANCE-REVIEW]]).

## Clarity outranks brevity

Never compress at the cost of correctness or safety. Keep full, unambiguous prose for:

- security notes and irreversible-action confirmations
- multi-step sequences where order matters

Brevity is the default, not a mandate.

## The dial

Want stronger economy? Install the optional concision skill from the
[suspec-skills](https://github.com/jcosta33/suspec-skills) catalog. It is opt-in conditioning — not a
Suspec requirement, and not a runtime hook.

## Related

- [Principles](principles.md) · [Vocabulary tiers (glossary)](glossary.md) · [ADR-0109](../adrs/0109-output-economy-convention.md)
