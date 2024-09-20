------------------------------------------------------
--1
CREATE TABLE TURNI(
    taxi VARCHAR(7) NOT NULL,
    giorno DATA NOT NULL,
    orario HOURS NOT NULL,
    autista VARCHAR,

    PRIMARY(taxi, giorno, orario)
    FOREIGN KEY(taxi) REFERENCES TAXI(targa)
    FOREIGN KEY(autista) REFERENCES AUTISTI(matricola)

    CHECK orario IN ('0', '6', '12', '18')
);

------------------------------------------------------
--2
ALTER TABLE AUTISTI
ADD CONSTRAINT patente_unica UNIQUE(numero_patente);

------------------------------------------------------
--3(non capito ultimo AND)
DELETE FROM TAXI
WHERE anno_immatricolazione < 2010 
    AND CAST('Oggi' TO DATE) - scadenza_revisione >= 2
    AND targa NOT IN ( SELECT taxi
                       FROM TURNI
                       WHERE giorno >= scadenza_revisione and giorno <= current_date
);

------------------------------------------------------
--4
SELECT matricola, cognome_nome
FROM AUTISTI a, TURNI t
WHERE t.autista = a.matricola
    AND current_date - t.giorno BETWEEN 0 AND 6
    AND NOT EXISTS (SELECT c.giorno
                    FROM CORSE c
                    WHERE )
------------------------------------------------------
--5
CREATE OR REPLACE VIEW CONTANTI_PER_TURNO
(taxi, giorno, orario, importo_contanti, matricola_autista, nome_autista, citta_taxi) AS
SELECT c.taxi, c.giorno, c.orario, SUM(c.importo), a.matricola, a.cognome_nome, s.codice
FROM CORESE c, AUTISTI a, SEDI s, TRURNI t, TAXI t 
WHERE c.taxi = t.taxi
    AND c.giorno = t.giorno
    AND c.orario = t.orario 
    AND t.taxi = t.targa
    AND a.matricola = t.autista
    AND s.codice = t.sede 
    AND c.contanti 
GROUP BY c.taxi, c.giorno, c.orario, a.matricola, a.cognome_nome, s.citta 

------------------------------------------------------
--6
SELECT a.matricola, a.cognome_nome, c.SUM(importo)
FROM AUTISTI a, CORSE c, TURNI t 
WHERE COUNT( DISTINCT c.taxi,c.giorno, c.orario) >= 100
    AND t.taxi = c.taxi
    AND t.giorno = c.giorno
    AND t.orario = c.orario
    AND t.autista = a.matricola
GROUP BY a.matricola, a.cognome_nome
ORDER BY a.cognome_nome
