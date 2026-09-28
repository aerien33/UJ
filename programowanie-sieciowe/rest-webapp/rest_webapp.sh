#!/bin/sh

# Skrypt uruchamiający i demonstrujący działanie aplikacji z pliku
# rest_webapp.py. Skrypt przetestowano pod Debianem 7, czyli dystrybucją
# zainstalowaną w pracowniach studenckich.
#
# Przy ręcznym testowaniu  webaplikacji możesz chcieć użyć "curl -v" aby
# zobaczyć nagłówki zapytań i odpowiedzi HTTP.

# Zainicjuj bazę z danymi osób i pieskow.

rm -f osoby.sqlite

sqlite3 osoby.sqlite "
PRAGMA foreign_keys = ON;

CREATE TABLE osoby (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    imie VARCHAR NOT NULL,
    nazwisko TEXT NOT NULL,
    telefon TEXT,
    adres TEXT
);
INSERT INTO osoby VALUES (1, 'Anna', 'Nowak', '+48124569988',
    'Rynek Główny 2, 30-001 Kraków');
INSERT INTO osoby VALUES (2, 'Jan', 'Kowalski', '+48127770022',
    'ul. Podzamcze 1, 31-001 Kraków');

CREATE TABLE psy (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    imie VARCHAR NOT NULL,
    rasa VARCHAR NOT NULL,
    wlasciciel_id INTEGER,
    FOREIGN KEY (wlasciciel_id)
        REFERENCES osoby(id)
        ON DELETE SET NULL
);

INSERT INTO psy VALUES (1, 'Azor', 'Border Collie', 1);
INSERT INTO psy VALUES (2, 'Burek', 'Jamnik', 2);
INSERT INTO psy VALUES (3, 'Norka', 'Kundel', NULL);
INSERT INTO psy VALUES (4, 'Mimek', 'Owczarek podhalanski', 2);
"

# Dla pewności wypisz na ekran jej zawartość.

echo "Początkowa zawartość bazy:"
sqlite3 --header osoby.sqlite "SELECT * FROM osoby"
sqlite3 --header osoby.sqlite "SELECT * FROM psy"

# Uruchom w tle serwer z webaplikacją.

env -i python3 -u rest_webapp.py > stdout.txt 2> stderr.txt &
server_pid=$!
sleep 1

# Testy aplikacji:

echo
echo "Test 1: pobieranie rekordu"
curl http://127.0.0.1:8000/osoby/1
curl http://127.0.0.1:8000/psy/1

echo
echo "Test 2: uaktualnianie rekordu"
printf "nazwisko\tadres\n" > dane.tsv
printf "Kowalska\tul. Podzamcze 1, 31-001 Kraków\n" >> dane.tsv
curl --upload-file dane.tsv \
        --header "Content-Type: text/tab-separated-values; charset=UTF-8" \
        http://127.0.0.1:8000/osoby/1
# użycie opcji --upload-file zmienia domyślną metodę na PUT

printf "imie\twlasciciel_id\n" > dane2.tsv
printf "Malinka\t2\n" >> dane2.tsv
curl --upload-file dane2.tsv \
        --header "Content-Type: text/tab-separated-values; charset=UTF-8" \
        http://127.0.0.1:8000/psy/1

echo
echo "Test 3: usuwanie rekordu"
curl --request DELETE http://127.0.0.1:8000/osoby/2
curl --request DELETE http://127.0.0.1:8000/psy/2

echo
echo "Test 4: dodawanie nowego rekordu"
printf "imie\tnazwisko\ttelefon\tadres\n" > dane.tsv
printf "Adam\tWiśniewski\t+48120124433\tul. Reymonta 4\n" >> dane.tsv
curl --request POST --upload-file dane.tsv \
        --header "Content-Type: text/tab-separated-values; charset=UTF-8" \
        http://127.0.0.1:8000/osoby

printf "imie\trasa\twlasciciel_id\n" > dane.tsv
printf "Plamka\tCocker Spaniel\t1\n" >> dane.tsv
curl --request POST --upload-file dane.tsv \
        --header "Content-Type: text/tab-separated-values; charset=UTF-8" \
        http://127.0.0.1:8000/psy

echo
echo "Test 5: pobieranie całej bazy"
curl http://127.0.0.1:8000/osoby
curl http://127.0.0.1:8000/psy

# I jeszcze upewnienie się co do zawartości pliku z bazą.

echo
echo "Zawartość bazy po zmianach:"
sqlite3 --header osoby.sqlite "SELECT * FROM osoby"
sqlite3 --header osoby.sqlite "SELECT * FROM psy"

# Koniec testów, można wyłączyć serwer aplikacyjny.

kill $server_pid
