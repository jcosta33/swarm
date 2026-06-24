# Adopting Corpus

Adopt Corpus by copying the starter kit into a workspace.

Use a dedicated repo named:

```text
<project>-works
```

or place the same tree inside one code repo.

## Manual setup

1. Create the workspace.

   ```bash
   gh repo create <project>-works --private
   git clone git@github.com:<org>/<project>-works.git
   ```

2. Copy the starter kit contents into it.

   ```bash
   cp -R path/to/corpus-starter-kit/. <project>-works/
   ```

3. Fill placeholders in:

   - `AGENTS.md`
   - `status.md`
   - command table
   - owner fields

4. Commit the workspace.

   ```bash
   git add .
   git commit -m "Adopt Corpus workspace"
   ```

5. Write one small spec and run the loop once.

Use symlinks only when your team and platform handle them reliably. On Windows, copying files is safer.

## CLI setup

If you use `corpus-cli`:

```bash
corpus init
```

In an empty directory, this creates the workspace.

In a non-empty code repo, use the workspace option when you want a dedicated workspace:

```bash
corpus init --workspace ../<project>-works
```

The CLI is optional. Copying the kit by hand is valid.

## Code repo pointer

In each governed code repo, add only what is needed:

```text
Corpus workspace: ../<project>-works. Read the task packet before coding.
```

Add `.gitignore` lines for local Corpus state if you use the CLI.

Do not copy specs, tasks, reviews, or findings into the code repo.

## Spec-external, single-root implementer

For a dedicated workspace governing a separate code repo, keep the implementer in one root:

- Canonical specs, tasks, reviews, and findings stay in the workspace.
- When you cut a task, snapshot its spec slice into the task packet — stamped with the spec id and version — and place the task in the code repo under a gitignored `.corpus/`.
- The implementer reads the pinned snapshot and writes only in the code repo, so its commands and edits resolve against one root.
- The review lead merges the run evidence back into the workspace: the board, the task status, and the review packet.

The code repo's committed history stays clean. Choose the co-located layout instead when you need code and its evidence in one commit.

## First useful change

Start small:

1. Capture one ticket in `intake/`.
2. Write one `status: ready` spec.
3. Create one task.
4. Run it in a worktree.
5. Review with evidence.
6. Save one finding if there is a durable lesson.

The tutorial walks this path in [tutorial/README.md](tutorial/README.md).

## Updating the kit

If you copied the kit, update by copying new kit-owned files or by using:

```bash
corpus update --check
corpus update --write
```

Keep project-owned specs, tasks, reviews, findings, and decisions unchanged unless you choose to edit them.
