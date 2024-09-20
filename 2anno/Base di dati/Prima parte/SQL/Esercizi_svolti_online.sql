--ESERCIZIO 1

--1
SELECT s.nome AS sale_pisa 
FROM SALE s
WHERE s.citta = 'Pisa'

--2
SELECT titolo, 
FROM FILM
WHERE  regista = 'F. Fellini' AND anno_produzione >= 1960

--3
SELECT f.titolo, f.durata
FROM FILM f
WHERE genere = 'fantascienza' 
    AND nazionalita IN('giapponesi', 'francesi')
    AND anno_produzione >= 1990

--4
SELECT f.titolo
FROM FILM f
WHERE  f.genere = 'fantascienza'
    AND 
    (f.nazionalita = 'giapponesi' AND f.anno_produzione >= 1990)
     OR f.nazionalita = 'francesi'

--5
SELECT f.titolo
FROM FILM f 
WHERE f.regista = (SELECT f.Regista
                    FROM Film f
                    WHERE f.Titolo = “Casablanca”)

--6
SELECT DISTINCT  f.titolo, f.genere
FROM FILM f, PROIEZIONI p 
WHERE p.data_proiezione = '25/12/2004'
    AND f.cod_film = p.cod_film

--7
SELECT DISTINCT f.titolo, f.genere
FROM FILM f, PROIEZIONI p, SALE s 
WHERE s.citta = 'Napoli' AND p.data_proiezione = '25/12/2004'
    AND f.CodFilm=p.CodFilm 
    AND p.CodSala=s.CodSala

--8(da rivedere, io non metterei RECITA)
SELECT s.nome
FROM SALE s, PROIEZIONI p, ATTORI a, RECITA r,
WHERE s.cod_sala = p.cod_sala
    AND p.cod_film = r.cod_film
    AND r.cod_attore = a.cod_attore
    AND s.citta = 'Napoli'
    AND p.data_proiezione = '25/12/2004'
    AND a.nome = 'R.Williams'

--9
SELECT f.titolo
FROM FILM f, ATTORI a, RECITA r 
WHERE f.cod_film = r.cod_film
    AND r.cod_attore = a.cod_attore
    AND a.nome IN('M.Mastroianni','S.Loren')

--10(NON C'HO CAPITO NIENTE)
SELECT f.titolo
FROM FILM f, ATTORI a
WHERE a.nome = 'M.Mastroiani' IN(SELECT a.nome
                                FROM  FILM f, RECITA r, ATTORI a
                                 WHERE f.cod_film = r.cod_film AND a.cod_attore = r.cod_attore
                                     AND a.nome = 'M.mastroiani')
    AND a.nome = 'S.Loren' IN(SELECT a.nome
                              FROM FILM f, RECITA r, ATTORI a
                              WHERE  f.cod_film = r.cod_film AND a.cod_attore = r.cod_attore
                                    AND a.nome = 'S.Loren')

--11
SELECT f.titolo, a.nome
FROM FILM f, RECITA r, ATTORI a
WHERE f.cod_film = r.cod_film 
    AND a.cod_attore = r.cod_attore
    AND a.nazionalita = 'Francese'

--12
SELECT f.titolo, s.nome
FROM PROIEZIONI p, FILM f, SALE s 
WHERE f.cod_film = p.cod_film
    AND s.cod_sala = p.cod_sala
    AND s.citta = 'Pisa'
    AND P.data_proiezione BETWEEN '01/01/2005' AND '31/01/2005'

--13
SELECT  COUNT(s.nome) AS numero_sale_con_piu_60
FROM SALE s 
WHERE s.posti > 60
    AND s.citta = 'Pisa'

--14
SELECT SUM(s.posti) AS totale_posti
FROM SALE s 
WHERE citta = 'Pisa'

--15
SELECT  s.citta, COUNT(*) AS num_sale 
FROM SALE s
GROUP BY s.citta

--16
SELECT s.citta, COUNT(*) AS num_sale
FROM SALE s 
WHERE s.posti > 60
GROUP BY s.citta

--17
SELECT f.regista, COUNT(*) AS num_film_diretti_dopo1990
FROM FILM f  
WHERE f.anno_produzione > 1990
GROUP BY f.regista

--18
SELECT f.regista, SUM(p.incasso) AS incasso_totale 
FROM FILM f, PROIEZIONI p 
WHERE  f.cod_film = p.cod_film 
GROUP BY F.regista 

--19(come mai COD_FILM?)
SELECT f.titolo, p.COUNT(*) AS num_tot_pro, SUM(p.incasso) AS incasso_totale
FROM FILM f, PROIEZIONI p, SALE s 
WHERE f.cod_film = p.cod_film 
    AND s.cod_sala = p.cod_sala
    AND f.regista = 'S.Spilberg'
    AND s.citta = 'Pisa'
GROUP BY  f.cod_film, f.titolo

--20(sbagliato il GROUP BY)
SELECT f.regista, a.nome, COUNT(*) AS num_film 
FROM ATTORI a, RECITA r, FILM f  
WHERE f.cod_film = r.cod_film AND r.cod_attore = a.cod_attore
GROUP BY f.regista, a.nome

--21
SELECT f.regista, f.titolo  
FROM FILM f, RECITA r, ATTORI a 
WHERE f.cod_film = r.cod_film AND r.cod_attore = a.cod_attori
GROUP BY f.regista, f.titolo, f.cod_film
    HAVING COUNT(a.nome)  < 6

--22
SELECT f.cod_film, f.titolo, SUM(p.incasso)
FROM FILM f, PROIEZIONI p 
WHERE f.cod_film = p.cod_film
    AND data_proiezione > '31/12/1999'
GROUP BY f.cod_film, f.titolo 

--23
SELECT f.titolo, COUNT(*) AS Numero_Attori
FROM ATTORI a, RECITA r, FILM f
WHERE r.cod_attore = a.cod_attore AND r.cod_film = f.cod_film
GROUP BY f.titolo, f.cod_film
HAVING a.anno_nascita < 1970

--24
SELECT f.titolo AS TITOLO, SUM(p.incasso) AS INCASSO_TOTALE
FROM FILM f, PROIEZIONI p
WHERE f.cod_film = p.cod_film
        AND f.genere = 'Fantascienza'
GROUP BY f.titolo, f.cod_film

--25
SELECT f.titolo, SUM(p.incasso) AS INCASSO_TOTALE
FROM FILM f, PROIEZIONI p
WHERE f.cod_film = p.cod_film
        AND f.genere = 'Fantascienza'
        AND p.data_proiezione > '01/01/2001'
GROUP BY f.cod_film, f.titolo

--26
SELECT f.titolo, SUM(p.incasso) AS INCASSO_TOTALE
FROM FILM f, PROIEZIONI p
WHERE f.cod_film = p.cod_film
        AND f.genere = 'Fantascienza'
        AND NOT EXISTS (SELECT p.data_proiezione
                        FROM PROIEZIONE p
                        WHERE p.data_proiezione < '01/01/2001'
                        )
GROUP BY f.titolo, f.cod_film

--27
SELECT s.nome AS NOME_SALA, SUM(p.incasso) AS INCASSO_TOTALE
FROM SALE s, PROIEZIONE p
WHERE p.cod_sala = s.cod_sala
        AND s.citta = 'Pisa'
        AND p.data_proiezione BETWEEN '01/01/2005' AND '31/01/2005'
GROUP BY s.cod_sala, s.nome
HAVING SUM(p.incasso) > '20000'