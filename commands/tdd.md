Start a TDD (Red-Green-Refactor) cycle for a requested feature or function.

## Process

- **Red:** Write one focused failing test. Confirm it fails for the right reason.
- **Green:** Write the minimum code to pass the test. Don't optimize yet.
- **Refactor:** Remove duplication, improve naming, run full suite.
- **Repeat** for the next behavior.

## Rules

- One behavior per cycle.
- Tests must be independent.
- Use `should <behavior> when <condition>` naming.
- Mock external dependencies at boundaries only.
- If a cycle exceeds ~5 min, the scope is too large — break it down.
