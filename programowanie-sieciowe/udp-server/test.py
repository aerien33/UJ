import subprocess
import os

HOST = "127.0.0.1"
PORT = "2020"
PROGRAM = "python3 mini-udpcat.py"

TEST_DIR = "tests"

def run_test(input_file, expected_file):
    with open(input_file, "rb") as f:
        proc = subprocess.run(
            ["python3", PROGRAM, HOST, PORT],
            stdin=f,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

    output = proc.stdout

    with open(expected_file, "rb") as f:
        expected = f.read()

    if output == expected:
        return True, ""
    else:
        return False, f"EXPECTED:\n{expected}\nGOT:\n{output}"

def main():
    tests = [f for f in os.listdir(TEST_DIR) if f.endswith(".in")]
    tests.sort()

    passed = 0

    for test in tests:
        name = test[:-3]
        input_file = os.path.join(TEST_DIR, name + ".in")
        expected_file = os.path.join(TEST_DIR, name + ".out")

        ok, msg = run_test(input_file, expected_file)

        if ok:
            print(f"[OK] {name}")
            passed += 1
        else:
            print(f"[FAIL] {name}")
            print(msg)

    print(f"\nPassed {passed}/{len(tests)} tests")

if __name__ == "__main__":
    main()