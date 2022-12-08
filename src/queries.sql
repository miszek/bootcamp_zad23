-- 1. Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE pracownik (
	id INT PRIMARY KEY AUTO_INCREMENT,
	imie VARCHAR(30) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL, 
    wyplata INT NOT NULL, 
    data_urodzenia DATE NOT NULL, 
    stanowisko VARCHAR(40) NOT NULL
);

-- 2. Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO pracownik
	(imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES 
	('Jan', 'Kowalski', 5000, '2000-01-03', 'tester'),
	('Adam', 'Adamowski', 8000, '1988-12-03', 'developer'),
	('Stefan', 'Stefański', 15000, '1981-04-30', 'manager'),
	('Anna', 'Ankiewicz', 9000, '2000-01-03', 'developer'),
	('Magdalena', 'Nowakowska', 14000, '1990-03-03', 'manager'),
	('Jan', 'Jankowski', 10000, '2000-01-03', 'tester');

-- 3. Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM pracownik
	ORDER BY nazwisko ASC;    

-- 4. obiera pracowników na wybranym stanowisku
SELECT * FROM pracownik
	WHERE stanowisko = 'developer';

-- 5. Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownik
	WHERE DATE_SUB(CURDATE(), INTERVAL 30 YEAR) > data_urodzenia;    

-- 6. Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE pracownik SET wyplata = wyplata*1.1
	WHERE stanowisko = 'tester';

-- 7. Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM pracownik
	WHERE data_urodzenia = (SELECT MAX(data_urodzenia) FROM pracownik);

-- 8. Usuwa tabelę pracownik
DROP TABLE pracownik;

-- 9. Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nazwa VARCHAR(50),
    opis VARCHAR(300),
    wyplata INT
);

-- 10. Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adres (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    ulica VARCHAR(40) UNIQUE NOT NULL,
    kod_pocztowy VARCHAR(6),
    miejscowosc VARCHAR (30)
    );
    
-- 11. Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE pracownik (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    imie VARCHAR(30),
    nazwisko VARCHAR(30),
    id_stanowisko INT NOT NULL,
    id_adres INT NOT NULL,
    FOREIGN KEY (id_stanowisko) REFERENCES stanowisko(id),
    FOREIGN KEY (id_adres) REFERENCES adres(id)
    );

-- 12. Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO adres
	(ulica, kod_pocztowy, miejscowosc)
VALUES
	('Myśliwska 3/27', '80-288', 'Gdańsk'),
    ('Twarda 10/56', '01-230', 'Warszawa'),
    ('Nowatorska 4/19', '04-345', 'Wrocław');

INSERT INTO stanowisko
	(nazwa, opis, wyplata)
VALUES
	('tester', 'testowanie oprogramowania', 8000),
    ('developer', 'tworzenie oprogramowania w języku JAVA', 11500),
    ('developer', 'tworzenie oprogramowania w języku C++', 10000);

INSERT INTO pracownik 
	(imie, nazwisko, id_stanowisko, id_adres)
VALUES
	('Adam', 'Kowalski', 2, 1),
    ('Anna', 'Kowalska', 1, 1),
    ('Roman', 'Piasecki', 3, 2),
    ('Andrzej', 'Andrzejewski', 2, 3);
    
-- 13. Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT pracownik.imie, pracownik.nazwisko, adres.ulica, adres.kod_pocztowy, adres.miejscowosc, stanowisko.nazwa, stanowisko.wyplata FROM pracownik
	LEFT JOIN adres ON pracownik.id_adres=adres.id
	LEFT JOIN stanowisko ON pracownik.id_stanowisko=stanowisko.id;

-- 14. Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT sum(stanowisko.wyplata) FROM pracownik
	LEFT JOIN adres ON pracownik.id_adres=adres.id
	LEFT JOIN stanowisko ON pracownik.id_stanowisko=stanowisko.id;

-- 15. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT pracownik.imie, pracownik.nazwisko, adres.ulica, adres.kod_pocztowy, adres.miejscowosc FROM pracownik
	LEFT JOIN adres ON pracownik.id_adres=adres.id
	WHERE adres.kod_pocztowy='80-288';