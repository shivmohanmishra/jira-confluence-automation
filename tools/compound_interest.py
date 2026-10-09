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
