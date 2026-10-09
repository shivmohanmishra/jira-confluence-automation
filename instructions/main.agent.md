---
name: Main Instructions Index
description: "Use when locating workspace instruction files or choosing a specialized status-report agent."
tools: [read, search]
user-invocable: true
---
# Instruction Files

- [`./instructions/compound-interest/SKILL.md`](./compound-interest/SKILL.md) — Runs the compound-interest helper script and reports the final amount and interest earned.
- [`./instructions/template-parameterized-script/SKILL.md`](./template-parameterized-script/SKILL.md) — Runs the generic parameterized helper for numeric input and returns the computed result.
- [`calculate-compound-interest.agent.md`](./calculate-compound-interest.agent.md): Explains when to use the compound-interest calculator, how to invoke it with command-line arguments, and how to present the results.
- [`use-compound-interest.agent.md`](./use-compound-interest.agent.md): Explains when to run the `tools/compound_interest.py` helper and how to present the result.
- [`use-template-parameterized-script.agent.md`](./use-template-parameterized-script.agent.md): Explains when to run the generic parameterized helper and how to pass command-line inputs correctly.
- [`create-workflow-instruction.agent.md`](./create-workflow-instruction.agent.md): Turns a workflow description into a reusable instruction file with explicit input, processing, output, and constraints.
- [`creating-instructions.agent.md`](./creating-instructions.agent.md): Establishes the instruction catalog pattern, sets up project-level wrappers, and guides adding reusable workflow instructions.
- [`create-status-report.agent.md`](./create-status-report.agent.md): Generates weekly stakeholder status reports in Markdown with Accomplishments, Blockers, and Next Week sections; bullet points only, maximum 20 lines, professional tone, no fluff.
- [`write-tests.agent.md`](./write-tests.agent.md): Creates or updates automated tests with a clear input, processing flow, expected output, and validation constraints.
- [`main.agent.md`](./main.agent.md): This index of the instruction files in the `instructions/` directory.
