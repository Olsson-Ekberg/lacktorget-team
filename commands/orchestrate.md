Run a multi-step workflow by breaking a complex task into coordinated sub-tasks.

## Steps

1. Parse a natural language or structured workflow spec.
2. Decompose into ordered sub-tasks — identify dependencies, parallelism, complexity.
3. For each sub-task define: objective, inputs, expected output, verification method.
4. Execute in dependency order, tracking pending/in-progress/complete. Stop on critical failure.
5. Final verification: build passes, tests pass, no regressions.
6. Report execution summary in a table with task, status, duration, notes.

## Rules

- No destructive operations without confirmation.
- Stop and report on critical failure.
- Max 10 tasks per workflow — break larger ones into phases.
- Save progress after each task.
