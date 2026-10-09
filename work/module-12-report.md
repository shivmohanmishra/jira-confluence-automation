# Module 12 Completion Report

## Instruction File
- Filename: use-compound-interest.agent.md

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

## Script File
- Filename: compound_interest.py
- Language: Python

import sys


def calculate_compound_interest(principal: float, annual_rate: float, compounds_per_year: int, years: float) -> tuple[float, float]:
    amount = principal * (1 + annual_rate / 100 / compounds_per_year) ** (compounds_per_year * years)
    interest_earned = amount - principal
    return amount, interest_earned


def main() -> None:
    if len(sys.argv) != 5:
        print("Usage: python tools/compound_interest.py <principal> <annual_rate> <compounds_per_year> <years>")
        raise SystemExit(1)

    try:
        principal = float(sys.argv[1])
        annual_rate = float(sys.argv[2])
        compounds_per_year = int(sys.argv[3])
        years = float(sys.argv[4])
    except ValueError:
        print("All arguments must be numeric values.")
        raise SystemExit(1)

    if compounds_per_year <= 0:
        print("Compounds per year must be greater than 0.")
        raise SystemExit(1)

    final_amount, interest_earned = calculate_compound_interest(
        principal, annual_rate, compounds_per_year, years
    )

    print(f"Final amount: {final_amount:.2f}")
    print(f"Interest earned: {interest_earned:.2f}")


if __name__ == "__main__":
    main()

## Script Execution Output
Python was not found; run without arguments to install from the Microsoft Store,
 or disable this shortcut from Settings > Apps > Advanced app settings > App exe
cution aliases.
