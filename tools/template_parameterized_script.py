import sys


def calculate(values):
    # Replace this logic with the actual calculation or transformation.
    return values


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python tools/template_parameterized_script.py <value1> <value2> ...")
        raise SystemExit(1)

    args = sys.argv[1:]
    parsed = []

    for arg in args:
        try:
            parsed.append(float(arg))
        except ValueError:
            print(f"Invalid number: {arg}")
            raise SystemExit(1)

    result = calculate(parsed)
    print(result)


if __name__ == "__main__":
    main()
