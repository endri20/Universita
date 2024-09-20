CREATE TABLE MUSEI(
    nome VARCHAR(60) NOT NULL,
    citta VARCHAR(60) NOT NULL,

    PRIMARY KEY(nome)
);

CREATE TABLE ARTISTI(
    nome VARCHAR(16) NOT NULL,
    anno_nascita DATE NOT NULL,
    anno_morte DATE NULL,
    nazionalita VARCHAR(255) NOT NULL,

    CHECK(anno_nasscita <= data_morte);

    PRIMARY KEY(nome)
);

CREATE TABLE OPERE(
    codice VARCHAR(16) NOT NULL,
    artista VARCHAR (16) NULL,
    titolo VARCHAR(16) NOT NULL,
    anno DATE NOT NULL,
    museo VARCHAR(60) NOT NULL,
    tipo VARCHAR(16) NOT NULL,
    altezza INTEGER NOT NULL,
    larghezza INTEGER NOT NULL,
    profondità INTEGER NULL,

    PRIMARY KEY(codice)
    FOREIGN KEY(artista) REFERENCES ARTISTI(nome)
    FOREIGN KEY(museo) REFERENCES MUSEI(nome)
);

CREATE TABLE PRESTITI(
    opera VARCHAR(16) NOT NULL,
    museo VARCHAR(60) NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE NOT NULL,

    PRIMARY KEY(opera)
    FOREIGN KEY(opera) REFERENCES OPERE(codice)
    FOREIGN KEY(museo) REFERENCES MUSEI(nome)

    CHECK (data_inizio < data_fine)
);

CREATE TABLE RESTAURI(
    opera VARCHAR(16) NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE NULL,

    PRIMARY KEY(opera)
    FOREIGN KEY(opera) REFERENCES OPERE(codice)

    CHECK (data_inizio < data_fine)
)

----------------------------------------------------------
--2(è giusto?, non capito riga 70 dopo AND)
ALTER TABLE OPERE(
/*
ALTER COLUMN tipo CHECK tipo IN('dipinto', 'scultura', 'installazione')

ALTER COLUMN altezza CHECK altezza > 0
ALTER COLUMN larghezza CHECK larghezza > 0
ALTER COLUMN profondità CHECK profondità > 0
*/

CHECK tipo IN('dipinto', 'scultura', 'installazione') AND (tipo = 'dipinto' or profondità IS NOT NULL)
CHECK (altezza > 0 AND larghezza > 0 AND profondità > 0)
)

----------------------------------------------------------
--3
DROP 
FROM PRESTITI
WHERE  CAST('oggi' AS DATE) - data_fine >= 5*365

----------------------------------------------------------
--4
SELECT a.nome
FROM ARTISTA a
WHERE NOT EXIST(
    SELECT *
    FROM OPERE o, RESTAURI r 
    WHERE 
    a.nome = o.artista AND o.codice = r.opera 
)

----------------------------------------------------------
--5(capire meglio UNION)
CREATE OR REPLACE VIEW OPERE_FRUIBILI

----------------------------------------------------------
--6(query non capita)
INSERT INTO PRESTITI(opera, museo, data_inizio, data_fine)
    SELECT codice, 'Uffizi', '2016-04-15'::date, '2016-06-05'::date
    FROM OPERE 
    WHERE artista = 'Giotto' AND museo != 'Uffizi';

----------------------------------------------------------
--7(pure questo molto difficile)
SELECT a.nome, COUNT(*) AS numero_opere, COUNT(museo)
FROM OPERE
GROUP BY  a.nome
HAVING COUNT(*) >= 10
ORDER BY a.nome
