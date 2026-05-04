# 🪞 Examples

> Worked walkthroughs in prose. Different from project skeletons — these are narrative explanations of "here's what a workflow looks like end-to-end" using a hypothetical scenario.

Each walkthrough renders the framework's mechanics concretely. Each follows the same structure:

1. **The scenario** (what's the human's ask, what's the starting state)
2. **The doc that grounds the work** (a representative spec / audit / bug-report)
3. **The task file** (with placeholders resolved to plausible values)
4. **The session itself** — what the agent does, what the persona constrains, what the Self-review looks like
5. **The handoff** (review, merge, audit update)
6. **What changed in the durable docs as a result**

---

## 🗂️ The walkthroughs

| Walkthrough                                                          | What it demonstrates                                                       |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| [feature-walkthrough.md](feature-walkthrough.md)                     | Spec → Builder → Skeptic review → merge                                   |
| [refactor-walkthrough.md](refactor-walkthrough.md)                   | Audit → Janitor → checkpoint validation → Skeptic review                  |
| [bug-fix-walkthrough.md](bug-fix-walkthrough.md)                     | Bug-report → Skeptic-as-fixer → regression test                            |
| [research-to-spec.md](research-to-spec.md)                           | Researcher → research file → Architect → spec → Builder → feature          |
| [orchestration-walkthrough.md](orchestration-walkthrough.md)         | Lead Engineer → 5 parallel workers → kickback round → merge log            |

---

## 🪞 How to read these

Each walkthrough is *narrative*. It shows the framework's mechanics by tracing one scenario from ask to merge. The walkthroughs reference real persona profiles, real task templates, and real skills — clicking the links takes you to the canonical version.

The walkthroughs are *not* prescriptions. Real projects vary. The intent is to make the framework's discipline *visible* by walking through a representative case.

---

## See also

- [`concepts/`](../concepts/) — the why behind each walkthrough's mechanics
- [`tasks/`](../tasks/) — the templates the walkthroughs use
- [`personas/`](../personas/) — the personas the walkthroughs feature
- [`skills/`](../skills/) — the skills the walkthroughs invoke
