Recapitulation
==============

Key ideas we covered:

- Git as patches: think of your project as a chain of patches (commits), not just a pile of files.
- diff and patch: `diff` shows changes; `patch` applies them. Each commit is effectively a patch.
- Basic workflow: initialize, edit, stage, commit. Always be aware of the trinity: HEAD, TREE, and STAGE.
- The Trinity:
  - THE HEAD: the last committed state of your current branch.
  - THE TREE: your working copy (files on disk).
  - THE STAGE: what will become the next commit.
- Commits: keep them small and focused. Write clear, single-line summaries that state what and why.
- Interactive staging: use `git add -i` or `git add -p` to craft precise commits from mixed changes.
- Details that matter: branches are pointers; detached HEAD is normal when examining old commits; use `.gitignore`; Git tracks files, not directories.
- Rebase vs merge: prefer rebasing onto the official history; merge only when that’s truly what you intend.

The goal is clarity: small, intentional commits with informative messages, built from a clean understanding of how changes move between the TREE, the STAGE, and the HEAD.


:student-select:Q; ../students.json::
