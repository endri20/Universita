------------------------------------------------------
--1
CREATE TABLE CORSE(
    progr. VARCHAR(16) NOT NULL,
    taxi VARCHAR(5) NOT NULL,
    giorno DATE, 
    orario HOURS,
    partenza VARCHAR(16) NOT NULL,
    destinazione VARCHAR(16) NOT NULL,
    km NUMERIC(5,2) NOT NULL,
    importo NUMERIC(8,2) NOT NULL,
    contanti BOOLEAN NOT NULL,

    PRIMARY KEY(progr, orario, taxi, giorno)
    FOREIGN KEY(taxi, giorno, orario) REFERENCES TURNI(taxi, giorno, orario)
    CHECK(km > 0 AND importo > 0)
)
------------------------------------------------------
--2
ALTER TABLE TURNI
ADD CONSTRAINT un_solo_turno(giorno, autista)
------------------------------------------------------
--3(controllare differenze)
DELETE FROM TURNI
WHERE giorno >  current_date
    AND(
        TAXI IN(
            SELECT targa
            FROM TAXI
            WHERE scadenza_revisione < current_date
        )
        OR 
        AUTISTI IN(
            SELECT matricola
            FROM AUTISTI
            WHERE scadenza_patente < current_date
        )
    )
------------------------------------------------------
--4(non capito completamente)
SELECT  DISTINCT tx.targa 
FROM TAXI tx, TURNI tu  
WHERE tu.taxi = tx.targa
    AND tu.taxi = tu.giorno 
    AND current_date - c.giorno BETWEEN 1 AND 30
    AND scadenza_revisione > current_date
    AND NOT EXISTS(
        SELECT taxi 
        FROM TURNI tu2, CORSE c
        WHERE c.taxi = tu2.taxi
            AND c.km < 10
    ) 
------------------------------------------------------
--5(sono stato bravo)
CREATE OR REPLACE VIEW CORSE_AEREOPORTO_PER_TURNO
    --(turno, COUNT(corse_turno) AS numero_corse, matricola, cognome_nome, sede_citta)
    (taxi, giorno, orario, numero_corse_per_aeroporto, matricola_autista, nome_autista, città_taxi)
    AS
    SELECT tu.taxi, tu.giorno, tu.orario, COUNT(*), a.matricola, a.cognome_nome, s.citta
    FROM TURNI tu, AUTISTI a, SEDI s, CORSE c, TAXI tx 
    WHERE tu.taxi = c.taxi --
        AND tu.giorno = c.giorno --
        AND tu.orario = c.orario --
        AND tu.autista = a.matricola --
        AND tx.targa = tu.taxi --
        AND tx.sede = s.codice --
        AND c.destinazione = 'Aereoporto'
    GROUP BY tu.taxi, tu.giorno, tu.orario, a.matricola, a.cognome_nome, s.citta
------------------------------------------------------
--6
SELECT s.codice, s.citta, COUNT(*) AS numero_corse
FROM SEDI s, TAXI tx, corse c
WHERE s.codice = tx.sede
    AND c.taxi = tx.targa 
GROUP BY s.codice, s.citta 
HAVING COUNT(tx.targa) >= 10 
ORDER BY numero_corse DESC, s.citta 
------------------------------------------------------
--7
