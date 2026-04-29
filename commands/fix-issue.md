Fix a GitHub issue by number — read the issue, create a branch, implement the fix, open a PR.

## Steps

1. Fetch issue: `gh issue view <number> --json title,body,labels,assignees`
2. Parse the problem, expected behavior, and repro steps.
3. Create branch `fix/<number>-<slug>`.
4. Locate and fix relevant files with minimal, focused changes + tests.
5. Run test suite to verify no regressions.
6. Commit with `fix: <title> (closes #<number>)`.
7. Push and open PR with `gh pr create`.

## Rules

- Always read the full issue including comments.
- Never touch unrelated files.
- Ask for clarification if the issue is unclear.
