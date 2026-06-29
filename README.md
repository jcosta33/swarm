# Suspec

**A lightweight spec and review workflow for teams using coding agents.**

Tickets become specs. Specs become agent-ready tasks. Agent output becomes evidence you
can review. Plain markdown, any agent, no runtime.

## The problem

Agents multiply code. They don't multiply your capacity to direct and check it. The mess
pools in five places: vague tickets pasted into chat, context re-explained every session,
agents drifting off-scope, giant PRs nobody can honestly review, and lessons lost when the
session ends.

Suspec is not an agent. Your tool — Claude Code, Codex, Cursor, Aider, or a human — writes
the code. Suspec structures the work around it, and spends where the bottleneck is:
**generation outruns validation**. So the review side gets the structure.

## The loop

```
Pull ──▶ Spec ──▶ Task ──▶ Run ──▶ Review ──▶ Close
 │        │        │        │        │          │
intake   spec     task    branch   review     finding
snapshot                  + code   packet     + status
```

1. **Pull** — point the spec's `sources` at the origin (a ticket URL, an issue, or `self`), or snapshot the ticket into `intake/` when you want the raw request kept. Intake is optional.
2. **Spec** — a one-page contract: requirements with IDs and `Verify with:` lines.
3. **Task** — a bounded packet an agent finishes in one sitting.
4. **Run** — your agent, in its own git worktree (a parallel checkout: own folder, own branch).
5. **Review** — coverage, evidence, a human-attention list. Not a 3,000-line diff.
6. **Close** — save what you learned as a finding; update the board.

Structural or brownfield work adds two optional steps: an **inventory** (map what exists)
and a **change plan** (how the code changes safely). Small cleanups skip to Task. Full
guide: [docs/02-basic-workflow.md](docs/02-basic-workflow.md).

## Sixty seconds

A requirement in a spec:

```markdown
### AC-001 — Expired refresh token redirects to login

When the refresh token is expired, the client must clear the local
session and redirect to `/login`.

Verify with: `auth-refresh-expired-token.test`
```

The review packet that comes back after an agent run:

```markdown
| ID     | Result     | Evidence             | Human attention |
| ------ | ---------- | -------------------- | --------------- |
| AC-001 | Pass       | test output pasted   | no              |
| AC-002 | Unverified | no test output found | yes             |

## Human attention

1. AC-002 has no pasted test output.
2. Retry logic changed in `src/auth/client.ts` — outside task scope.
```

The table is the point. You read which requirements passed **with evidence** and which
didn't. You read where your eyes are needed. You skip the whole diff. An empty evidence cell
means _Unverified_, never _Pass_. Full demo — a 41-file agent PR reviewed by exception:
[docs/examples/large-pr-review.md](docs/examples/large-pr-review.md).

## Where files live

- **This repo** — the framework: the docs and the checks contract. The ready-to-copy workspace (templates + guides) is [jcosta33/suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit).
- **Your workspace** — specs, tasks, reviews, findings: a dedicated repo, or the same tree in your project ([where files live](docs/03-where-files-live.md)).
- **Your code repos** — stay clean. The PR links its review packet. That's all.

## Which repo do I want?

| You want to…                                                                  | Go to                                                                                                                |
| ----------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **start using Suspec** — get a working workspace                              | [suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit) — copy it whole, fill `AGENTS.md`, run the loop |
| **understand the method** — formats, the checks contract, the decision ledger | **this repo** — `docs/` (the numbered happy path), `docs/reference/`, `docs/adrs/`                                   |
| **run the checks / wire the gate** — `suspec check` as a command              | [suspec-cli](https://github.com/jcosta33/suspec-cli) — the reference CLI (optional)                                  |
| **add optional skills** — review stances, code-lifecycle + authoring guides    | [suspec-skills](https://github.com/jcosta33/suspec-skills) — `npx skills add jcosta33/suspec-skills`                 |
| **delegate to subagents** — review / audit / spec-author worker definitions    | [suspec-agents](https://github.com/jcosta33/suspec-agents) — copy into `.claude/agents/` (Claude Code) / `.codex/agents/` (Codex) |
| **use Suspec over MCP** — read + reconcile facts from a non-terminal client    | [suspec-mcp](https://github.com/jcosta33/suspec-mcp) — an MCP server for Claude Desktop / Cursor (no shell needed)   |

Most people start at the kit and never read this repo cover to cover.

## Works today, comes later

**Today** (markdown + your agent, nothing to install): the templates, specs, task packets,
review packets, findings, the worked examples. Suspec itself needs no runtime.

**Toolable** (optional — the reference CLI, [suspec-cli](https://github.com/jcosta33/suspec-cli)):
`suspec check` runs the [checks contract](docs/reference/checks.md) over your specs and reviews. The
kit's [hooks](https://github.com/jcosta33/suspec-starter-kit/tree/main/hooks) wire it into your commit
and pull-request gates — teeth for the review side. Nothing here is a runtime you need to _use_ Suspec.
`suspec init`, `new`, `worktree`, `pull`, `promote`, and `status` scaffold the loop's mechanics.
`suspec run` launches a prepared task on your agent in its worktree and records the launch. `suspec
review` reconciles a finished run against its spec and diff — surfacing facts (omitted edits,
out-of-scope changes, unbacked claims), never a result.

**Planned** (the rest of `suspec-cli`): `suspec close`. What ships when:
[docs/reference/future-cli.md](docs/reference/future-cli.md).

Suspec does **not** promise deterministic generation, automatic correctness, formal
verification, software compiled from specs, or the end of PR review. It promises better
inputs, bounded tasks, reviewable evidence, and kept context.

## Is / is not

**Is:** a spec format agents work from · a task-packet format that bounds agent work · a
review-packet format that shows where human attention goes · a findings convention so lessons
survive the session · a starter kit of markdown templates · a workspace convention that
keeps all of it out of your code repos.

**Is not:** an agent or runtime · a compiler · a programming language · a Jira/Linear
replacement · a code generator · a replacement for PRs and CI · a docs portal · a full SDLC
platform · a guarantee that agent output is correct.

**Take what you want.** Each part stands alone — adopt just the review packet, or just the
spec format, and add the rest when the work calls for it. Plain markdown you own outright:
no runtime, no lock-in, no walled garden. Together they compound; apart, each still earns
its place.

Against its neighbors: spec-first scaffolds generate plans. Trackers hold tickets. AI
reviewers hunt bugs and check a diff against a linked ticket's acceptance criteria. An
`AGENTS.md` alone carries standing facts, not per-change contracts.

Suspec's distinct piece is the **persisted, independent, exception-routing review packet**
tied to requirement IDs. It is deterministic — no model in the loop. It is keyed to a
spec/task that lives in your git history. It is verdict-free: it routes facts, and a human
owns Pass/Fail. Around it sit a workspace and one honesty rule — anything a tool doesn't
enforce says so.

## Initiation

1. Copy the kit whole — it is a ready workspace: use [jcosta33/suspec-starter-kit](https://github.com/jcosta33/suspec-starter-kit) as a template (a new repo, or a folder in your project).
2. Fill its `AGENTS.md` with your commands and facts.
3. Claude Code finds the guides via the shipped `.claude/skills` symlink; point any other tool at `.agents/skills/`.
4. New to the loop? **[Walk it once, hands-on](docs/tutorial/README.md)** — a guided build on one small change. Then write a spec for your next real change and run it.

Or hand your agent [docs/ADOPTING.md](docs/ADOPTING.md) and let it do the copying.

## Going deeper

[What is Suspec](docs/01-what-is-suspec.md) · [Basic workflow](docs/02-basic-workflow.md) · [Writing specs](docs/04-writing-specs.md) ·
[Reviewing output](docs/08-reviewing-output.md) · [Examples](docs/examples/) · [Reference](docs/reference/) ·
[Design decisions](docs/adrs/) · [Evidence](docs/research/sources.md)
