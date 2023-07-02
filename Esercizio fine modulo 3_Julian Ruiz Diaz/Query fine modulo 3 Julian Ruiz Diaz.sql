--Nomi dei prodotti acquistati dai clienti

SELECT CONCAT(c.Nome,' ',c.Cognome) as Cliente
	, CONCAT (p.Categoria,' ',p.Nome) as NomeProdotto
FROM CodiceOrdine o
INNER JOIN CodiceOrdineDettaglio d
ON o.IDCodiceOrdine = d.IDCodiceOrdine
INNER JOIN Cliente c
ON o.IDCliente = c.IDCliente
INNER JOIN Prodotto p
ON d.IDProdotto = p.IDProdotto

--Spese totali effettuati dai clienti che abbiano effettuato almeno 2 acquisti e che siano in ordine decrescente

SELECT CONCAT(c.Nome,' ',c.Cognome) as Cliente
	  ,SUM(d.Quantità * p.Prezzo) as SpesaTotale
	  ,COUNT(o.IDCodiceOrdine) as NumProdotti
 FROM CodiceOrdine o
INNER JOIN CodiceOrdineDettaglio d
ON o.IDCodiceOrdine = d.IDCodiceOrdine
INNER JOIN Cliente c
ON o.IDCliente = c.IDCliente
INNER JOIN Prodotto p
ON d.IDProdotto = p.IDProdotto
GROUP BY c.Nome, c.Cognome
HAVING COUNT(*) >=2
ORDER BY  SpesaTotale DESC

--Clienti che hanno comprato finestre a battente

SELECT DISTINCT CONCAT(c.Nome,' ',c.Cognome) as Cliente
FROM CodiceOrdine o
INNER JOIN CodiceOrdineDettaglio d
ON o.IDCodiceOrdine = d.IDCodiceOrdine
INNER JOIN Cliente c
ON o.IDCliente = c.IDCliente
INNER JOIN Prodotto p
ON d.IDProdotto = p.IDProdotto
WHERE p.Categoria='Finestra' AND
p.Nome='Battente'

--Il cliente che ha fatto l'ultimo acquisto sulle porte libro

SELECT CONCAT(c.Nome,' ',c.Cognome) as Cliente, o.DataOrdine
FROM CodiceOrdine o
INNER JOIN Cliente c
ON o.IDCliente = c.IDCliente
WHERE o.DataOrdine IN (SELECT MAX(o.DataOrdine)
		FROM CodiceOrdine o
		INNER JOIN CodiceOrdineDettaglio d
		ON o.IDCodiceOrdine = d.IDCodiceOrdine
		INNER JOIN Prodotto p
		ON d.IDProdotto = p.IDProdotto
		WHERE p.Categoria='Porta' AND
		p.Nome='Libro')

-- Nomi dei clienti che non hanno mai fatto un acquisto e il loro indirizzo

SELECT CONCAT(c.Nome,' ',c.Cognome) as Cliente, CONCAT(a.Città, ' ', a.Regione) as Indirizzo
FROM Cliente c
LEFT JOIN CodiceOrdine o
ON c.IDCliente = o.IDCliente
INNER JOIN AreaGeografica a
ON c.IDAreaGeografica = a.IDAreaGeografica
WHERE o.IDCodiceOrdine is NULL

--Lista dei clienti che hanno come nome la inziale con 'M' o che abitano a Foligno

SELECT CONCAT(c.Nome,' ',c.Cognome) as Cliente
FROM Cliente c
INNER JOIN AreaGeografica a
ON c.IDAreaGeografica = a.IDAreaGeografica
WHERE Nome LIKE('M%') OR
a.Città='Foligno'

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Creazione Viste

-- Vista dei Negozi
CREATE VIEW JRD_vNegozi as(
SELECT n.IDNegozio
	 , n.Nome
	 , n.Indirizzo
	 , a.Città
	 , a.Regione
	 , n.NumeroTelefonico
FROM Negozio n
INNER JOIN AreaGeografica a
ON n.IDAreaGeografica = a.IDAreaGeografica)

--Vista dei Clienti provenienti dalla Regione Umbria
CREATE VIEW JRD_vClientiUmbria as(
SELECT CONCAT(c.Nome, ' ', c.Cognome) as Cliente
	  ,a.Città
FROM Cliente c
INNER JOIN AreaGeografica a
ON c.IDAreaGeografica = a.IDAreaGeografica
Where a.Regione='Umbria') --il filtro sulla regione e controproducente lo so'
