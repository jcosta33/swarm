# DX Audit: Agentic Execution of Swarm Workflows

**Date:** 2026-06-12
**Auditor:** Gemini CLI (Stances: `write-audit`, `persona-auditor`)
**Goal:** Surface friction points and risk modes of the Swarm framework by running internal, agent-driven commands that test Swarm's core mandates (Empirical Proof, Cross-Module Grep, SOL formatting).

## Scope
**In Scope:**
- Agentic execution limits when applying Swarm rules to a repository.
- Evaluation of the cross-module grep rule (`adversarial-review` Rule 3).
- Evaluation of the Empirical Proof mandate (ADR-0008).

**Out of Scope:**
- Human-in-the-loop UX.
- Execution speeds of the underlying LLM.

---

## Observations

### O1: The cross-module grep rule triggers context/formatting limits in large sweeps.
* **Severity:** Major
* **File:line:** `.agents/skills/adversarial-review/SKILL.md:41` ("Paste the output (or summarise the call-site count and read each).")
* **Specific Issue:** When an agent attempts to grep for a common symbol or keyword across the codebase, the output volume is too massive to paste verbatim into a markdown table or observation without breaking context or readability.
* **Evidence:** Running `git grep -n 'pass' docs/ starter-kit/ | wc -l` yields:
```
      349
```
Running `git grep -n 'pass' docs/ starter-kit/ | head -n 3` yields:
```
docs/01-what-is-swarm.md:77:- **No automatic correctness.** A requirement with passing output pasted next to it is strong
docs/04-writing-specs.md:69:   requirements — split them so each can pass or fail on its own.
docs/04-writing-specs.md:70:4. **Name the actor.** "The client must…", "The API must…" — never "it should" or a passive
```
Because the full 349 lines cannot be pasted into a finding, an agent is forced to fall back to the "summarise" escape hatch, which weakens the strict `file:line` empirical proof standard.

### O2: Empirical Proof of verbose CLI output causes payload rejection.
* **Severity:** Blocker
* **File:line:** `docs/adrs/0008-empirical-proof-as-framework-primitive.md:13` ("Every code-changing task archetype mandates verbatim command output... Paraphrase is invalid")
* **Specific Issue:** Swarm requires agents to paste test runner output. In real environments (e.g., Maven, Xcodebuild, or aggressive E2E suites), standard stdout easily exceeds 2,000–5,000 lines. As an LLM agent, attempting to `write_file` or `replace` a `.md` document with 5,000 lines of verbatim CLI output causes tool context failure or token exhaustion.
* **Evidence:** (Market / System validation) The LLM's intrinsic system limits cap output generation (often at 4k-8k tokens per turn). "Verbatim" output from a standard `npm install` or noisy `cargo test` routinely exceeds this, making the "no paraphrase" rule structurally incompatible with the agent's physical constraints.

### O3: No-Runtime policy delegates complex environment orchestration to agents.
* **Severity:** Major
* **File:line:** `docs/reference/principles.md:8` ("No runtime in this repo... Swarm is markdown plus your agent.")
* **Specific Issue:** Because Swarm provides no runtime to execute tests, the agent must figure out how to configure the testing shell environment itself to get the empirical proof required to close a task. In integration testing scenarios (requiring DBs, Docker, etc.), the agent often fails the setup phase before even testing the code.
* **Evidence:** (Surveyor Market Evidence) Prevailing tools like SWE-agent or Daytona abstract environment execution away from the agent specifically because LLMs struggle to dynamically provision OS-level dependencies via pure shell commands.

---

## Risks

### R1: Paraphrasing Contagion
* **Firing Condition:** An agent runs a command that returns >500 lines of output.
* **Risk:** Unable to paste the verbatim output without crashing, the agent will silently summarize it (e.g., "The tests passed successfully"). Once summary is accepted, the Skeptic stance is broken, and hallucinated greens pass review.

### R2: Brittleness in Strict Syntax (SOL) without Linters
* **Firing Condition:** An agent is tasked with writing Structured Requirements (SOL) using the `MUST` / `VERIFY BY` notation.
* **Risk:** Lacking a runtime linter to instantly reject malformed markdown, the agent writes prose instead of strict SOL. The error is only caught at the end of the review loop, forcing a slow, multi-turn correction cycle.

---

## Candidate Requirements

1. **Explicit Truncation Protocol:** `ADR-0008` should be amended to explicitly permit and standardize truncation techniques (e.g., "Paste the command, the tail 50 lines including the failure/success assertion, and the exit code") to prevent context collapse while maintaining proof.
2. **Setup Primitives:** A new section in `AGENTS.md` should be introduced for `Commands > Environment Setup` so agents don't have to guess how to bootstrap the dependencies required to run the `Commands > Test` scripts.