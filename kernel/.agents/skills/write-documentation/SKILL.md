---
name: write-documentation
description: Author or update user-facing documentation. ALWAYS apply this skill when the user asks for a README, how-to, tutorial, reference doc, public API doc, or contributor guide — anything a human (not an agent) reads to learn or look up. Do not mix Diátaxis frames in a single doc, hedge with "should/might/could", or include code examples you have not actually run. Skip this skill for agent-facing material (skill bodies, task templates, internal flow docs) — those follow different conventions and live elsewhere.
---

# Skill: write-documentation

## Purpose

User-facing documentation that hedges, has examples that don't run, or contradicts the code is worse than no documentation — it actively misleads. This skill is the discipline that keeps the doc honest and useful: the reader is a human who has not read the code, they have a question, the doc answers it.

This is distinct from agent-facing documentation (task templates, skills, internal flow docs); those serve a different audience and follow different conventions.

## Project context (the AGENTS.md contract)

Resolves project commands via the consuming repo's `AGENTS.md` — `Commands > Validation`, `Commands > Format` (run on the doc before commit). An optional doc-lint command (`markdownlint`, `vale`, etc.) is not in the standard contract; ask the user if the project uses one. If `AGENTS.md` is missing or an entry is undefined, ask the user which command to run before proceeding — do not guess.

## Core rules

### 1. Lead with what the reader needs to do

Not the background, not the history, not "before we begin, let's discuss…". The first 100 words contain the action the reader's question is asking about. Background follows if needed.

### 2. Pick one Diátaxis frame; do not mix

Each doc is exactly one of:

- **Tutorial** — a learning experience for a beginner. Step-by-step, hand-holding, no choices.
- **How-to** — a recipe for a specific task. Assumes the reader knows the basics; just shows them the steps.
- **Reference** — exhaustive technical description. Lookup material, no narrative.
- **Explanation** — discusses *why* something is the way it is. Background, design rationale.

Mixing frames in one doc confuses readers in all four modes. If you find yourself switching modes mid-doc, split it.

### 3. Every code example runs as written

Run every code example. Capture the output. Verify the example is self-contained (no missing imports, no implied setup). If you didn't run it, it's a hypothesis, not an example.

### 4. Every behaviour claim cites file:line

A claim about how the system behaves is verifiable against the code. Cite the file and line. If you can't find the line, the claim is suspect — verify before publishing.

### 5. No hedging

"Should", "might", "could" hedge the reader cannot act on. Either the system does X or it doesn't. If the behaviour is conditional, state the condition.

- ❌ "You might want to consider configuring X."
- ✅ "Configure X if you need Y. The default is Z."

### 6. Update existing docs when their world changes

Stale docs are worse than no docs. If you update the code in a way that affects existing docs, update those docs in the same change. Grep for related docs that may contradict your changes.

### 7. Verify, then publish

Before considering the doc done:

- Every code example: actually ran, output captured.
- Every behaviour claim: cross-referenced against file:line.
- Every existing doc that touches the same area: searched for and reconciled.
- Project's doc-lint command (if any) passes.

## What does not belong

- **In a doc:** examples that haven't been run; "should" / "might" / "could" hedging; mixed Diátaxis frames; assumptions about the reader having read the code.
- **In a tutorial:** choices ("you could also try…"). Tutorials are linear.
- **In a reference:** narrative ("first, we see that…"). References are lookup.

## Anti-patterns

- Examples that don't run
- "Should" / "might" / "could" hedging the reader cannot act on
- Updating the README without updating in-tree docs that contradict it
- Mixing Diátaxis types in a single doc
- Treating documentation as an afterthought to feature work
- Long throat-clearing introductions that bury the action

## Bundled resources

- `references/task-template.md` — a fillable documentation-task template with doc target (Diátaxis frame, audience, reader's question), source material, examples-to-verify table, progress checklist, and a self-review hard gate covering reader-first ordering, examples actually running, currency, and doc-type integrity.

Copy it into your project's task file location, substitute the `{{...}}` placeholders, and fill it in as you work.
