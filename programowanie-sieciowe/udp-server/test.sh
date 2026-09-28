#!/bin/bash

HOST=127.0.0.1
PORT=2020

PASS=0
TOTAL=0

# set -x   # <<< KLUCZOWE
gcc -std=c99 -pedantic -Wall my_udp_srv_skel.c -lm -lpthread -o program
#testy/odpal-i-przetestuj --udp /tmp/zadanie/program

echo -n 'xyz' | ncat --udp --crlf -q 1 $HOST $PORT > tests/test1.out
printf 'xyz' | socat -t 5.0 stdio udp4:$HOST:$PORT > tests/test2.out
printf 'xyz' | socat -t 5.0 stdio udp4:127.0.0.1:2020 | od -A d -t u1 -t c > tests/test3.out
printf 'Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test4.out
printf 'kajak' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test5.out
printf 'Ala i pies' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test6.out
printf 'Ala i ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test7.out
printf 'pies i Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test8.out
printf 'pies Ala i' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test9.out
printf 'k' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test10.out
printf 'k o' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test11.out
printf 'ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test12.out
printf 'ko ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test13.out
printf 'ko ko ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test14.out
printf 'a i o u w z' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test15.out
printf '.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test16.out
printf '??' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test17.out
printf 'a?' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test18.out
printf '?a' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test19.out
printf 'Ala.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test20.out
printf '.Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test21.out
printf ' Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test22.out
printf 'Ala  pies' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test23.out
printf 'kukurydza' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test24.out
printf 'owies i pszenica' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test25.out
printf 'Ala i kot' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test26.out
printf '' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test27.out
printf 'ABBA 1972' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test28.out
printf 'Ola ma psa.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test29.out
printf 'bㅏ|b i fasola' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test30.out
printf 'oraz\0zero' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test31.out
printf 'tab\ti spacja' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test32.out
printf 'LF \n po spacji' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test33.out
printf 'LF LF na koncu\n\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test34.out
printf 'CR na koncu\r' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test35.out
printf 'LF CR na koncu\n\r' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test36.out
printf ' abc' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test37.out
printf 'abc  ' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test38.out
printf 'oko   kok' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test39.out
printf 'CR LF na koncu\r\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test40.out
printf 'LF na koncu\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test41.out
printf 'Ala i kot\r\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test42.out
printf 'chrzㅡ…szcz\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c > tests/test43.out

run_test() {
    NAME=$1
    CMD=$2
    EXPECTED=$3

    TOTAL=$((TOTAL+1))
    OUT="tmp.out"

    eval "$CMD" > "$OUT" 2>/dev/null

    if cmp -s "$OUT" "$EXPECTED" > /dev/null; then
        echo "[OK] $NAME"
        echo "---- expected ----"
        cat "$EXPECTED"
        echo "---- got ----"
        cat "$OUT"
        PASS=$((PASS+1))
    else
        echo "[FAIL] $NAME"
        echo "---- expected ----"
        cat "$EXPECTED"
        echo "---- got ----"
        cat "$OUT"
    fi

    rm -f "$OUT"
}

# ===== TESTY =====

# test 1: ncat
run_test "ncat test" \
"echo -n 'xyz' | ncat --udp --crlf -q 1 $HOST $PORT" \
"tests/test1.out"

# test 2: socat
run_test "socat test" \
"printf 'xyz' | socat -t 5.0 stdio udp4:$HOST:$PORT" \
"tests/test2.out"

# test 3: zapis + od (debug)
run_test "od dump" \
"printf 'xyz' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test3.out"

# test 4: Ala po prostu
run_test "Ala po prostu" \
"printf 'Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test4.out"

# test 5: kajak
run_test "kajak" \
"printf 'kajak' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test5.out"

# test 6: Ala i pies
run_test "Ala i pies" \
"printf 'Ala i pies' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test6.out"

# test 7: Ala i ala
run_test "Ala i ala" \
"printf 'Ala i ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test7.out"

# test 8: pies i Ala
run_test "pies i Ala" \
"printf 'pies i Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test8.out"

# test 9: pies Ala i
run_test "pies Ala i" \
"printf 'pies Ala i' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test9.out"

# test 10: k
run_test "k" \
"printf 'k' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test10.out"

# test 11: k o
run_test "k o" \
"printf 'k o' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test11.out"

# test 12: ko
run_test "ko" \
"printf 'ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test12.out"

# test 13: ko ko
run_test "ko ko" \
"printf 'ko ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test13.out"

# test 14: ko ko ko
run_test "ko ko ko" \
"printf 'ko ko ko' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test14.out"

# test 14: a i o u w z
run_test "a i o u w z" \
"printf 'a i o u w z' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test15.out"

# test 16: .
run_test "." \
"printf '.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test16.out"

# test 17: ??
run_test "??" \
"printf '??' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test17.out"

# test 18: a?
run_test "a?" \
"printf 'a?' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test18.out"

# test 19: ?a
run_test "?a" \
"printf '?a' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test19.out"

# test 20: Ala.
run_test "Ala." \
"printf 'Ala.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test20.out"

# test 21: .Ala
run_test ".Ala" \
"printf '.Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test21.out"

# test 22: (spacja) Ala
run_test "(spacja) Ala" \
"printf ' Ala' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test22.out"

# test 23: Ala  pies
run_test "Ala  pies" \
"printf 'Ala  pies' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test23.out"

# test 24: kukurydza
run_test "kukurydza" \
"printf 'kukurydza' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test24.out"

# test 25: owies i pszenica
run_test "owies i pszenica" \
"printf 'owies i pszenica' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test25.out"

# test 26: Ala i kot
run_test "Ala i kot" \
"printf 'Ala i kot' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test26.out"

# test 27: pusty
run_test "pusty" \
"printf '' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test27.out"

# test 28: ABBA 1972
run_test "ABBA 1972" \
"printf 'ABBA 1972' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test28.out"

# test 29: Ola ma psa.
run_test "Ola ma psa." \
"printf 'Ola ma psa.' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test29.out"

# test 30: bㅏㅣb i fasola
run_test "bㅏㅣb i fasola" \
"printf 'bㅏㅣb i fasola' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test30.out"

# test 31: oraz\0zero
run_test "oraz\0zero" \
"printf 'oraz\0zero' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test31.out"

# test 32: tab\ti spacja
run_test "tab\ti spacja" \
"printf 'tab\ti spacja' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test32.out"

# test 33: LF \n po spacji
run_test "LF \n po spacji" \
"printf 'LF \n po spacji' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test33.out"

# test 34: LF LF na koncu\n\n
run_test "LF LF na koncu\n\n" \
"printf 'LF LF na koncu\n\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test34.out"

# test 35: CR na koncu\r
run_test "CR na koncu\r" \
"printf 'CR na koncu\r' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test35.out"

# test 36: LF CR na koncu\n\r
run_test "LF CR na koncu\n\r" \
"printf 'LF CR na koncu\n\r' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test36.out"

# test 37: (spacja) abc
run_test "(spacja) abc" \
"printf ' abc' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test37.out"

# test 38: abc (dwie spacje)
run_test "abc (dwie spacje)" \
"printf 'abc  ' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test38.out"

# test 39: oko (trzy spacje) kok
run_test "oko (trzy spacje) kok" \
"printf 'oko   kok' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test39.out"

# test 40: CR LF na koncu\r\n
run_test "CR LF na koncu\r\n" \
"printf 'CR LF na koncu\r\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test40.out"

# test 41: LF na koncu\n
run_test "LF na koncu\n" \
"printf 'LF na koncu\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test41.out"

# test 42: Ala i kot\r\n
run_test "Ala i kot\r\n" \
"printf 'Ala i kot\r\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test42.out"

# test 43: chrzㅡ…szcz\n
run_test "chrzㅡ…szcz\n" \
"printf 'chrzㅡ…szcz\n' | socat -t 5.0 stdio udp4:$HOST:$PORT | od -A d -t u1 -t c" \
"tests/test43.out"

echo
echo "Passed $PASS / $TOTAL tests"