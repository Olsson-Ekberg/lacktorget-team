Diagnose and fix failing tests in the project.

## Steps

1. Run test suite, capture output, detect runner from project config.
2. Extract: test name, file, expected vs actual, stack trace.
3. Categorize root cause: stale snapshot, logic change, environment issue, flaky test, dependency update.
4. Read source and test side by side.
5. Apply fix (update assertions if intentional change, fix source if real bug, add retries for flaky).
6. Re-run failing tests first, then full suite for regression check.

## Rules

- Never delete a failing test without understanding it.
- Fix source code if the test caught a real bug.
- Distinguish intentional changes from regressions.
- Always run the full suite after fixes.
