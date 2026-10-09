---
name: template-parameterized-script
description: Run the generic parameterized helper script for numeric input and return the computed result.
version: 1.0.0
---

- Use this skill when a user needs a generic command-line helper for numeric input.
- Run the script from the project root with:
  `python tools/template_parameterized_script.py <value1> <value2> ...`
- Ensure at least one numeric argument is provided before running the command.
- Use the script output directly as the result for the user’s request.
- Keep the response brief and focused on the computed value.
- Do not invent output values or claim the result is valid without running the script.
- Keep the scope limited to the helper result and its inputs.
