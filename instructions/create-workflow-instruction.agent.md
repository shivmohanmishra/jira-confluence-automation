---
name: Create Workflow Instruction
description: "Use when turning a workflow description into a reusable instruction file with explicit input, processing, output, and constraints."
tools: [read, search, edit]
user-invocable: true
---

- Create a reusable workflow instruction in Markdown for the requested process.
- Input Format
  + Accept the workflow description, goal, trigger, actors, inputs, and desired result.
  + If required details are missing, ask for one concise clarification before drafting.
  + Use only facts from the user's request or the project; do not invent steps, owners, dates, or outputs.
- Processing Steps
  + Name the workflow in verb-first, hyphenated form, such as `create-report` or `draft-brief`.
  + Write short, imperative bullet points in plain English.
  + State the input format first so the expected data is explicit.
  + Describe the processing steps in order, with each step leading to the next outcome.
  + Define the output structure, file naming, and required content if applicable.
  + Add constraints for assumptions, quality checks, scope limits, and edge cases.
  + Keep the instruction focused on one workflow only.
- Output Format
  + Save the result as `./instructions/[name].agent.md`.
  + Include these sections in this order: `Input Format`, `Processing Steps`, `Output Format`, `Constraints`.
  + Use bullet points under each section; avoid long narrative blocks or tables.
  + Keep the final instruction concise, actionable, and reusable.
- Constraints
  + Do not add unrelated tasks, general policy, or duplicate guidance already covered elsewhere.
  + Prefer precise, practical wording over explanatory text.
  + Preserve source facts and avoid unsupported assumptions.
  + If the workflow is unclear, ask for clarification instead of guessing.
  + Update `./instructions/main.agent.md` with a one-line catalog entry for the new instruction.
