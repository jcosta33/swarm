# Swarm starter kit

Everything an adopting workspace copies. Five-minute tour:

```
templates/    the eight core artifact templates — spec, task, review, finding,
              status, intake, inventory, change-plan
agent/        the bootloader (AGENTS.md + CLAUDE.md/GEMINI.md symlinks) and three
              agent guides: write-spec, implement-task, review-output
examples/     one compact worked feature: ticket → spec → task → review → finding
decisions/    the seed ADR ledger for your workspace
advanced/     optional: audit/bug/research/adr/rfc/prd/threat-model templates,
              focused guides for the optional work, and the SOL + checks
              reference cards
.gitignore.additions   lines for code repos (the workspace commits its artifacts)
```

**Copy checklist** (the whole core is 12 files):

1. `templates/` → your workspace.
2. The three guide folders in `agent/` → the directory your agent CLI scans for
   skills; `AGENTS.md` and its two symlinks → your repo root; fill the placeholders.
3. `decisions/` → your workspace; append `.gitignore.additions` where relevant.
4. Start with one feature: `specs/<feature>/spec.md`.

`advanced/` is optional — copy pieces when the work needs them. The audit template
is the recommended first taste for brownfield codebases.

Full instructions: `docs/ADOPTING.md`. Worked examples: `docs/examples/`.
