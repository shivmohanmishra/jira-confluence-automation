---
name: compound-interest
description: Run the compound-interest helper script and report the final amount and interest earned.
version: 1.0.0
---

- Use this skill when the user asks for compound interest, future value, or total interest earned.
- Run the script from the project root with:
  `python tools/compound_interest.py <principal> <annual_rate> <compounds_per_year> <years>`
- Validate that all arguments are numeric and that compounds per year is greater than zero.
- Read the script output and use it as the source of truth for the final amount and interest earned.
- Respond with a brief sentence such as:
  `The final amount is $X.XX and the interest earned is $Y.YY.`
- Do not invent values or use a different formula than the script implements.
- Keep the answer scoped to the compound-interest calculation.
