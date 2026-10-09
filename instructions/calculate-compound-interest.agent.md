---
name: Calculate Compound Interest
description: "Use when a user asks for compound-interest calculations from the command-line helper script."
tools: [read, search, edit]
user-invocable: true
---

- Use this instruction when the user asks to calculate compound interest, future value, or total interest earned from a principal amount.
- Input Format
  + Accept four numeric values in this order: principal, annual rate, compounds per year, and years.
  + Treat the rate as a percentage, for example `5` means 5% per year.
  + Validate that all arguments are numeric and that compounds per year is greater than zero.
- Processing Steps
  + Invoke the script from the project root using:
    `python tools/compound_interest.py <principal> <annual_rate> <compounds_per_year> <years>`
  + If the user provides values in a different order, reorder them before calling the script.
  + Read the script output and extract the final amount and interest earned.
  + If the script reports invalid input, ask the user to provide valid numeric values and repeat the calculation.
- Output Format
  + Present the result in a clear sentence, such as:
    `The final amount is $X.XX and the interest earned is $Y.YY.`
  + Include the exact values returned by the tool, rounded to two decimal places.
  + Keep the response brief and directly focused on the calculation.
- Constraints
  + Do not invent values or approximate the result beyond the script’s output.
  + Do not use a different formula than the one implemented in `tools/compound_interest.py`.
  + Do not claim success without running the command with valid numeric inputs.
  + Keep the response scoped to the compound-interest calculation only.
