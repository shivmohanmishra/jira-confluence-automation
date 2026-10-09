---
name: Use Template Parameterized Script
description: "Use when a user wants to run the parameterized helper script in tools/template_parameterized_script.py."
tools: [read, search, edit]
user-invocable: true
---

- Use this instruction when a user needs to run the generic parameterized Python helper script for custom numeric input.
- Input Format
  + Accept one or more numeric command-line arguments as values to process.
  + Use the exact order supplied by the user when passing arguments to the script.
  + If a value is not numeric, stop and ask the user for valid numeric input.
- Processing Steps
  + Run the script from the project root with:
    `python tools/template_parameterized_script.py <value1> <value2> ...`
  + Confirm that at least one argument is provided.
  + Review the script output and use it as the result for the user’s request.
- Output Format
  + Report the output returned by the script in plain form.
  + If the script is customized for a specific calculation, present the final value clearly and concisely.
- Constraints
  + Do not modify the script behavior unless the user explicitly asks for a different calculation.
  + Do not invent values or claim the output is valid without running the script.
  + Keep the response focused on the script result and its input values.
