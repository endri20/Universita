--Clienti (NumeroCliente, Nome, Cognome, DataNascita, RegioneResidenza);

--Fatture (NumeroFattura, Tipologia, Importo, Iva, IdCliente, DataFattura, NumeroFornitore);

--Prodotti (IdProdotto, Descrizione, InProduzione, InCommercio,  DataAttivazione, DataDisattivazione);

--Fornitori (NumeroFornitore, Denominazione, RegioneResidenza);


--1) Estrarre il nome e il cognome dei clienti nati nel 1982
SELECT nome, cognome
FROM Clienti
WHERE DataNascita = 1982


--2) Estrarre una colonna di nome “Denominazione” contenente 
--il nome, seguito da un carattere “-“, seguito dal cognome, per i soli clienti
--residenti nella regione Lombardia
SELECT nome, cognome
FROM clienti
WHERE RegioneResidenza = 'Lombardia'


--3) Qual è il numero di fatture con iva al 20%?
SELECT NumeroFattura
FROM Fatture
WHERE iva = 20%


--4) Riportare il numero di fatture e la somma dei relativi importi divisi per anno di fatturazione.
SELECT NumeroFattura, Importo, DataFattura
FROM Fatture

--5) Estrarre i prodotti attivati nel 2017 e che sono in produzione oppure in commercio
SELECT *
FROM Prodotti
WHERE DataAttivazione = 2017 and (InProduzione = si or InCommercio = si)

--6) Considerando soltanto le fatture con iva al 20 per cento, qual è il numero di fatture per ogni anno?
SELECT COUNT NumeroFattura
FROM Fatture
WHERE iva = 20

--7) In quali anni sono state registrate più di 2 fatture con tipologia ‘A’?
SELECT DataFattura
FROM Fatture
WHERE Tipologia = 'A'


--JOIN
--8) Riportare l’elenco delle fatture (numero, importo, iva e data) con in aggiunta il nome del fornitore
SELECT fa.NumeroFattura, fa.Importo, fa.Iva, fa.DataFattura, fo.Denominazione
FROM Fatture AS fa LEFT JOIN Fornitore AS fo ON fa.NumeroFornitore = fo.NumeroFornitore


--9) Estrarre il totale degli importi delle fatture divisi per residenza dei clienti
SELECT fa.Importo, cl.RegioneResidenza 
FROM Fatture AS fa INNER JOIN Clienti AS cl ON NumeroCliente = IdCliente


--Clienti (NumeroCliente, Nome, Cognome, DataNascita, RegioneResidenza);

--Fatture (NumeroFattura, Tipologia, Importo, Iva, IdCliente, DataFattura, NumeroFornitore);

--Prodotti (IdProdotto, Descrizione, InProduzione, InCommercio,  DataAttivazione, DataDisattivazione);

--Fornitori (NumeroFornitore, Denominazione, RegioneResidenza);

--10) Estrarre il numero dei clienti nati nel 1980 che hanno almeno una fattura superiore a 50 euro
SELECT cl.NumeroCliente
FROM Clienti AS cl INNER JOIN Fatture AS f ON NumeroCliente = IdCliente
WHERE DataNascita = 1980 and Importo < 50



