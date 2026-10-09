---
name: Write Tests
description: "Use when creating or updating automated tests for a feature, bug fix, or workflow."
tools: [read, search, edit]
user-invocable: true
---

- Create automated tests that validate the intended behavior with the smallest, clearest setup.
- Input Format
  + Accept the feature, bug fix, or workflow to validate, along with the expected behavior and any constraints.
  + If no test framework is configured, use the project’s existing tooling or ask before adding new dependencies.
  + Capture each scenario as one behavior with clear inputs and expected outputs.
- Processing Steps
  + Identify the code path, function, component, or API surface under test.
  + Write the failing test first when creating a new test.
  + Use real inputs, minimal setup, and the simplest assertion that proves the behavior.
  + Cover the happy path plus one edge case or failure case when relevant.
  + Keep test names descriptive and specific to behavior, not implementation details.
  + Run the smallest relevant test command to verify the result.
- Output Format
  + Save the test near the code under test using the project’s existing folder conventions.
  + Use the project’s established test syntax and naming conventions.
  + Keep assertions direct, readable, and limited to the observed behavior.
  + If the project uses no automated test framework, add the minimum setup required to run the test.
- Constraints
  + Do not mock the behavior being tested.
  + Do not add test-only production methods or code paths.
  + Do not assert on implementation details when a real outcome is easier to verify.
  + Do not claim tests pass without running them.
  + Keep the scope focused on the requested behavior and avoid unrelated refactors.
