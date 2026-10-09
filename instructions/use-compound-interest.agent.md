---
name: Use Compound Interest
description: "Use when a user asks to calculate compound interest with the helper script in tools/compound_interest.py."
tools: [read, search, edit]
user-invocable: true
---

- Use this instruction when the user needs a compound-interest result from the project helper script.
- Input Format
  + Accept four numeric values in this order: principal, annual rate, compounds per year, and years.
  + Treat the annual rate as a percentage value, for example `7.34` means 7.34%.
  + Validate that the principal and years are non-negative and that compounds per year is greater than zero.
- Processing Steps
  + Run the script from the project root with:
    `python tools/compound_interest.py <principal> <annual_rate> <compounds_per_year> <years>`
  + If any argument is invalid, stop and ask the user for valid numeric input before rerunning.
  + Read the output and extract the final amount and interest earned.
- Output Format
  + Report the result in a concise sentence, e.g.:
    `The final amount is $X.XX and the interest earned is $Y.YY.`
  + Keep the response limited to the calculation result and not extra commentary.
- Constraints
  + Do not use a different formula or approximate the answer outside the script output.
  + Do not claim a result until the command has been run successfully.
  + Keep the response focused on the compounding calculation only.
