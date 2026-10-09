# Module 10 Completion Report

## Instruction Files
create-status-report.agent.md
create-workflow-instruction.agent.md
creating-instructions.agent.md
main.agent.md
write-tests.agent.md

## main.agent.md Contents
---
name: Main Instructions Index
description: "Use when locating workspace instruction files or choosing a specialized status-report agent."
tools: [read, search]
user-invocable: true
---
# Instruction Files

- [`create-workflow-instruction.agent.md`](./create-workflow-instruction.agent.md): Turns a workflow description into a reusable instruction file with explicit input, processing, output, and constraints.
- [`creating-instructions.agent.md`](./creating-instructions.agent.md): Establishes the instruction catalog pattern, sets up project-level wrappers, and guides adding reusable workflow instructions.
- [`create-status-report.agent.md`](./create-status-report.agent.md): Generates weekly stakeholder status reports in Markdown with Accomplishments, Blockers, and Next Week sections; bullet points only, maximum 20 lines, professional tone, no fluff.
- [`write-tests.agent.md`](./write-tests.agent.md): Creates or updates automated tests with a clear input, processing flow, expected output, and validation constraints.
- [`main.agent.md`](./main.agent.md): This index of the instruction files in the `instructions/` directory.

## Sample Instruction
- File: write-tests.agent.md
- Contents:
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
