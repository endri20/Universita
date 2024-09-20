------------------------------------------------------------------------------------------------------------
--1
CREATE TABLE VOTI(
    studente VARCHAR(60) NOT NULL,
    materia VARCHAR(30) NOT NULL,
    tipo VARCHAR(7) NOT NULL,
    voto NUMERIC(3,1),
    data_voto DATE NOT NULL,

    FOREIGN KEY(studente) REFERENCES STUDENTI(matricola),
    FOREIGN KEY(materia) REFERENCES MATERIE(codice),

    CHECK(tipo = 'scritto' OR tipo = 'orale')
    CHECK(voto BETWEEN 0.0 AND 10.0) 

    UNIQUE(studente, materia, data_voto)
);

--------------------------------------------------------------
--2
ALTER TABLE INSEGNAMENTI(
    -- ADD CONSTRAINT max_docente_per_classe *opzionale
    UNIQUE(docente, classe)
);

--------------------------------------------------------------
--3 (non capito, forse)
SELECT DISTINCT m.codice, m.nome
FROM INSEGNAMENTI i, DOCENTI d, MATERIE m
WHERE d.docenti nome = 'Enea' AND d.docenti cognome = 'Zaffanella' --insegnate Enea Zaffanella
    AND i.materia = m.codice -- materie insegnate
    AND i.docente = d.matricola; --matricola del docente

--------------------------------------------------------------
--4(non capito)
DELETE FROM VOTI   
WHERE materia IN(
    SELECT codice
    FROM materie
    WHERE nome IN('Matematica', 'Informatica')
)
--------------------------------------------------------------
--5
SELECT DISTINCT s.matricola, s.nome, s.cognome
FROM STUDENTI s
WHERE i.classe = s.classe
    AND NOT EXISTS(
        SELECT *
        FROM VOTI v
        WHERE v.studente = s.matricola
            AND v.materia = i.materia
            AND v.tipo = 'orale'
    )
--------------------------------------------------------------
--6
CREATE VIEW numerosita_classi(classe, numero_studenti) AS 
    SELECT classe, COUNT(matricole)
    FROM STUDENTI
--------------------------------------------------------------
--7(non capito,boh)
SELECT nc.classe, nc.numero_studenti, d.nome, d.cognome
FROM numerosita_classi nc, CLASSI c LEFT OUTER JOIN DOCENTI dt ON c.docente_tutor = dt.matricola
WHERE nc.classe = c.nome
ORDER BY nc.numero_studenti DESC 
--------------------------------------------------------------
--8(quasi non capito)
CREATE VIEW COMUNICAZIONI_RILEVANTI(studente, [data], testo) AS
SELECT s.matricola, co.data, co.testo
FROM STUDENTI s, COMUNICAZIONI co
WHERE s.matricola = co.studente or co.classe = s.classe or (co.classe IS NULL AND co.studente IS NULL) --(non capito ultimo or)
--------------------------------------------------------------
--9
CREATE VIEW NEWS (studente, [data], testo) AS
SELECT  cr.* -- COMUNICAZIONI_RILEVANTI
FROM STUDENTI s, COMUNICAZIONI_RILEVANTI cr
WHERE s.matricola = cr.studente AND cr.data >= s.data_ultima_connessione
ORDER BY c.data DESC
--------------------------------------------------------------
--10(capire meglio lo statment GROUP BY colummn_name HAVING condition)
SELECT m.nome AS materia, s.matricola, AVG(v.voto) AS media
FROM MATERIA m, STUDENTI s, VOTI v
WHERE m.codice = v.materia AND v.studente = s.matricola
GROUP BY m.nome, s.matricola HAVING AVG(v.voto) < 6.0
--------------------------------------------------------------
--11(la condizione dell'haiving potevo metterla nel WHERE?)
SELECT d.cognome, d.nome
FROM DOCENTI d, INSEGNAMENTI i
WHERE d.matricola = i.docente 
GROUP BY d.cognome, d.nome  HAVING SUM(i.ore_settimanali) BETWEEN 0 AND 18
ORDER BY d.cognome, d.nome
--------------------------------------------------------------
--12(imparare algerba relazionale)