 /* 1.	Geef een lijst van de studenten, gesorteerd op familienaam en voornaam. 
 Enkel de eerste 12 studenten uit de alfabetische lijst worden weergegeven. 
 Zorg dat spaties niet meespelen in het bepalen van de sorteervolgorde. */

SELECT TOP 12 * FROM studenten ORDER BY REPLACE(familienaam, ' ', ''), REPLACE(voornaam, ' ', '');

/* 2.	Geef een lijst van de mannelijke studenten met hun geboortedatum, 
gesorteerd volgens dalende geboortedatum. Indien de geboortedatum niet ingevuld is, 
toon dan de tekst ‘Niet gekend’. Zorg ook voor zinvolle kolomkoppen. */

SELECT *, ISNULL(CONVERT(CHAR(20),geboortedatum, 105), 'Niet gekend') AS
geboortedatumTekst FROM studenten
WHERE geslacht = 'M'
ORDER BY geboortedatum DESC;

/* 3.	Geef alle studenten met hun leeftijd (huidig jaar – geboortejaar). 
Sorteer op leeftijd, familienaam en voornaam. */

SELECT *, geboortedatum, DATEDIFF(YEAR, geboortedatum, GETDATE()) AS leeftijd
FROM studenten
ORDER BY leeftijd, familienaam, voornaam;

/* 4.	Geef de gegevens van de studenten waarvan de familienaam begint met v (klein). */

SELECT *
FROM studenten
WHERE familienaam LIKE 'v%';

/* 5.	Geef de studenten waarvan de familienaam ongeveer klinkt als ‘Vanmale’. */

SELECT *
FROM studenten
WHERE DIFFERENCE(familienaam, 'Vanmale') BETWEEN 3 AND 7;

/* 6.	Geef een overzicht van de studenten met de cursussen die ze volgen. 
Geef per student: het studnr, de familienaam, de voornaam en de naam van de cursus die ze volgen.
Sorteer alfabetisch op familienaam en voornaam. */

SELECT s.studnr, s.familienaam, s.voornaam, c.cursusnaam
FROM studenten s
JOIN studenten_cursussen sc ON s.studnr = sc.studnr
JOIN cursussen c ON sc.cursusnr = c.cursusnr
ORDER BY s.familienaam, s.voornaam;

/* 7.	Idem vorige vraag, maar zorg ervoor dat ook de studenten die geen enkele cursus volgen, weergegeven worden. */

SELECT s.studnr, s.familienaam, s.voornaam, c.cursusnaam
FROM studenten s
LEFT JOIN studenten_cursussen sc ON s.studnr = sc.studnr
LEFT JOIN cursussen c ON sc.cursusnr = c.cursusnr
ORDER BY s.familienaam, s.voornaam;

/* 8.	Idem vorige vraag, maar zorg ervoor dat ook de cursussen die door geen enkele student gevolgd worden, weergegeven worden. */

SELECT s.studnr, s.familienaam, s.voornaam, c.cursusnaam
FROM studenten s
FULL JOIN studenten_cursussen sc ON s.studnr = sc.studnr
FULL JOIN cursussen c ON sc.cursusnr = c.cursusnr
ORDER BY s.familienaam, s.voornaam;

/* 9.	Geef voor elke student wat hij reeds betaald heeft (de kolom betaald uit de tabel studenten)
en wat de student zou moeten betalen (tebetalen) volgens de cursussen die hij volgt (voor elke cursus moet inschrijvingsgeld betaald worden). 
Als de student geen cursussen volgt, is tebetalen 0 (en niet NULL). */

SELECT s.voornaam, s.familienaam, s.studnr, AVG(s.betaald) AS betaald, ISNULL(SUM(c.inschrijvingsgeld),0) AS tebetalen
FROM studenten s
LEFT JOIN studenten_cursussen sc ON s.studnr = sc.studnr
LEFT JOIN cursussen c ON sc.cursusnr = c.cursusnr
GROUP BY s.voornaam, s.familienaam, s.studnr;

/* 10.	 Geef de gegevens van de studenten die geen enkele cursus volgen. */

SELECT *
FROM studenten
WHERE studnr NOT IN (SELECT studnr FROM studenten_cursussen)
ORDER BY studnr;

/* 11. Geef de gegevens van de studenten die alle cursussen volgen. */

SELECT *
FROM studenten
WHERE (SELECT COUNT(*) FROM studenten_cursussen sc WHERE sc.studnr = studenten.studnr) = (SELECT COUNT(*) FROM cursussen);
		
/* 12.	 Geef de gegevens van de studenten die het hoogst aantal cursussen volgen. */

SELECT TOP 1 WITH TIES *,
	(SELECT COUNT(*)
	FROM studenten_cursussen
	WHERE studnr = studenten.studnr) AS aantal
FROM studenten
ORDER BY aantal DESC;

/* 13.	Geef de gegevens van de cursussen met het hoogst aantal ingeschreven studenten */

SELECT TOP 1 WITH TIES *,
	(SELECT COUNT(*)
	FROM studenten_cursussen
	WHERE cursusnr = cursussen.cursusnr) AS aantal
FROM cursussen
ORDER BY aantal DESC;

/* 14.	 Geef de gegevens van de cursussen waarvoor uitsluitend vrouwen zijn ingeschreven. */

SELECT *
FROM cursussen
WHERE cursusnr IN 
	(SELECT cursusnr 
	FROM studenten_cursussen)
AND cursusnr NOT IN
	(SELECT cursusnr
	FROM studenten_cursussen
	JOIN studenten ON studenten_cursussen.studnr = studenten.studnr
	WHERE geslacht = 'M');

/* 15.	Geef de gegevens van de studenten die een naamgenoot hebben in de school. 
Een naamgenoot is een persoon met dezelfde familienaam. 
Sorteer de lijst alfabetisch op familienaam en voornaam. */

SELECT s1.*
FROM studenten s1
WHERE familienaam in 
	(SELECT familienaam
	FROM studenten s2
	WHERE s2.familienaam = s1.familienaam
	AND s2.studnr != s1.studnr)
ORDER BY s1.familienaam, s1.voornaam;

/* 16.	Als de kolom email leeg is, vul dan deze kolom op met een standaard e-mailadres: voornaam.familienaam@howest.be.
Hierbij moeten spaties in de naam vervangen worden door punten en moeten ‘ in de naam verwijderd worden. */

UPDATE studenten
SET email = REPLACE(REPLACE(voornaam + '.' + familienaam, ' ', ''),'''','')+ '@howest.be'
WHERE email IS NULL;

/* 17.	Maak een nieuwe tabel studentenOud. Vul deze nieuwe tabel met de studenten die geboren zijn in 1980 of eerder. */

SELECT *
INTO studentenOld
FROM studenten
WHERE YEAR(geboortedatum) <= 1980;

/* 18.	Voeg aan de tabel studentenOud de auteurs uit de pubs-databank toe. */

INSERT INTO studentenOld(voornaam, familienaam)
	SELECT au_fname, au_lname
	FROM pubs.dbo.authors;

/* 19.	Verwijder uit de tabel studentenOud de studenten vanaf de letter V (familienaam). */

DELETE FROM studentenOld
WHERE LEFT(familienaam, 1)>='V';

/* 20.	Maak een view vStudentenMetCursussen die de studenten weergeeft met hun cursussen. 
Gebruik de view om een alfabetische lijst te bekomen. */

CREATE VIEW vStudentenMetCursussen
AS
SELECT studenten.studnr, studenten.voornaam AS studentvoornaam, studenten.familienaam AS studentfamilienaam,
       cursussen.cursusnr, cursussen.cursusnaam
   FROM cursussen 
        JOIN studenten_cursussen ON cursussen.cursusnr = studenten_cursussen.cursusnr
        JOIN studenten ON studenten_cursussen.studnr = studenten.studnr
GO
SELECT * FROM vStudentenMetCursussen
ORDER BY studentfamilienaam, studentvoornaam;


