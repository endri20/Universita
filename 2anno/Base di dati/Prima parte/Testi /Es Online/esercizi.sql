--AEROPORTO (kCitta, Nazione, NumPiste)
--VOLO (kIdVolo, GiornoSett, CittaPart, OraPart,-
--      -CittaArr, OraArr, TipoAereo)
--AEREO (kTipoAereo, NumPasseggeri, QtaMerci)

--Trovare le citta da cui partono voli diretti 
--a Roma, ordinate alfabeticamente

SELECT CittaPart 
FROM VOLO 
WHERE CittaArr = 'Roma'

--Trovare le citta con un aeroporto di cui
--non e'noto il numero di piste

SELECT Citta
FROM AEREOPORTO
WHERE NumPiste = NULL

--Di ogni volo misto (merci e passeggeri) estrarre 
--il codice e i dati relativi al trasporto
SELECT v.IdVolo, a.NumPasseggeri, a.QtaMerci
FROM    Volo AS v INNER JOIN Aereo AS a ON v.TipoAereo = a.TipoAereo

--Le nazioni di partenza e arrivo del volo AZ274
SELECT a1.Nazione, a2.Nazione
FROM (Aereoporto AS a1 INNER JOIN Volo ON CittaPart = a1.Citta) INNER JOIN AEREOPORTO AS a2 ON CittaArr = a2.Citta
WHERE IdVolo = 'AZ274'

--Trovare l’aeroporto italiano con il maggior numero di piste
SELECT Citta, NumPiste
FROM Aereoporto 
WHERE Nazione = 'Italia' AND NumPiste = (SELECT MAX(NumPiste) FROM Aereoporto WHERE Nazione = 'Italia')


--AEROPORTO (kCitta, Nazione, NumPiste)
--VOLO (kIdVolo, GiornoSett, CittaPart, OraPart, CittaArr, OraArr, TipoAereo)
--AEREO (kTipoAereo, NumPasseggeri, QtaMerci)

--Per ogni nazione, trovare quante piste ha l’aeroporto con più piste.
SELECT Nazione, NumPiste
FROM Aereoporto
WHERE Max(NumPiste) > 3  -- AND NumPiste >= 3

--Trovare le città in cui si trovano gli aeroporti con più piste di ogni nazione
SELECT Citta, Nazione, NumPiste
FROM Aereoporto
WHERE 


