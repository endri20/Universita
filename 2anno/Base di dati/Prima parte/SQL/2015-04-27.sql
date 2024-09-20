---------------------------------------------------------------------
--1
CREATE TABLE DISTRETTI(
    nome VARCHAR(255) NOT NULL,

    PRIMARY KEY(nome)
);

CREATE TABLE SEZIONI(
    distretto VARCHAR(255) NOT NULL REFERENCES DISTRETTI(nome),
    numero INTEGER NOT NULL,
    indirizzo VARCHAR(200) NOT NULL,

    PRIMARY KEY(distretto,numero)
);

CREATE TABLE PERSONE(
    codice_fiscale VARCHAR(16),
    cognome VARCHAR(60) NOT NULL,
    nome VARCHAR(60) NOT NULL,
    data_nascita DATE NOT NULL,
    data_morte DATE NULL --opzionale

    PRIMARY KEY(codice_fiscale)
);


CREATE TABLE TESSERE_ELETTORALI(
    numero INTEGER,
    sezione_distretto VARCHAR(255) NOT NULL,
    sezione_numero INTEGER NOT NULL,
    persona VARCHAR(16) NOT NULL,
    data_emissione DATE NOT NULL,

    PRIMARY KEY(numero),
    FOREIGN KEY(sezione_distretto,sezione_numero) REFERENCES SEZIONI(distretto,numero),
    FOREIGN KEY(persona) REFERENCES PERSONE(codice_fiscale)
);

CREATE TABLE CANDIDATURE(
    persona VARCHAR(16) NOT NULL,
    distretto VARCHAR(255) NOT NULL,
    
    PRIMARY KEY(persona),
    FOREIGN KEY(persona) REFERENCES PERSONE(codice_fiscale),
    FOREIGN KEY(distretto) REFERENCES DISTRETTI(nome)
);

CREATE TABLE VOTI_ESPRESSI(
    tessera INTEGER,
    ora_voto TIME NOT NULL,

    PRIMARY KEY(tessera),
    FOREIGN KEY(tessera) REFERENCES TESSERE_ELETTORALI(numero)
);

CREATE TABLE VOTI_SCRUTINATI(
    sezione_distretto  VARCHAR(255) NOT NULL REFERENCES
    sezione_numero INTEGER NOT NULL,
    progr VARCHAR(255) NOT NULL,
    cadidato VARCHAR(16) NULL,

    PRIMARY KEY(sezione_distretto,sezione_numero),
    FOREIGN KEY(sezione_distretto,sezione_numero) REFERENCES SEZIONI(distretto,numero)
    FOREIGN KEY (candiato) REFERENCES CANDIDATURE(persona)
);

------------------------------------------------------------------------------------------------------------
--2
ALTER TABLE TESSERE_ELETTORALI
ADD CONSTRAINT non_più_di_una_tessera_a_testa UNIQUE(persona);

------------------------------------------------------------------------------------------------------------
--3
REPLACE VIEW ELETTORATO_ATTIVO(
    (sezione_distretto, sezione_numero,codice_fiscale, numero_tessera, cognome, nome, data_nascita)
AS 
SELECT S.sezione_distretto, S.sezione_numero, P.codice_fiscale, P.numero_tessera, P.cognome, P.nome, P.data_nascita
FROM PERSONE, TESSERE_ELETTORALI
WHERE P.codice_fiscale = T.persona
AND data_nascita 'data elezione - data di nascita'
AND data_morte IS NULL
AND data_emissione < 'data elezione'
);

------------------------------------------------------------------------------------------------------------
--4
DELETE VOTI_ESPRESSI
WHERE tessera NOT IN(
    SELECT numero_tessera
    FROM ELETTORATO_ATTIVO
);

------------------------------------------------------------------------------------------------------------
--5
CREATE VIEW VOTI_ESPRESSI_ENTRO_MEZZOGIORNO(
    (distretto, numero_voti)
AS
SELECT T.sezione_distretto, count(numero_voti)
FROM TESSERE_ELETTORALI, VOTI_ESPRESSI
WHERE T.numero = V.tessera
AND  ora_voto < '12:00'
);

CREATE VIEW NUMERO_ELETTORI_PER_DISTRETTO(
    (distretto, numero_elettori)
AS
SELECT sezione_distretto, count(numero_elettori)
FROM ELETTORATO_ATTIVO
);

SELECT 
FROM VOTI_ESPRESSI_ENTRO_MEZZOGIORNO, NUMERO_ELETTORI_PER_DISTRETTO
WHERE 
