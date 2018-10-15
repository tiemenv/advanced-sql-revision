USE school

/* 1 */

ALTER TABLE studenten
ADD woonplaats NVARCHAR(255)

/* 2 */

ALTER TABLE studenten_cursussen
DROP CONSTRAINT fk1_stud_curs

ALTER TABLE studenten_cursussen
ADD CONSTRAINT fk_stud_curs FOREIGN KEY(studnr) REFERENCES studenten(studnr)
ON DELETE CASCADE

/* 3 */

ALTER TABLE studenten
ADD CONSTRAINT ch_betaald CHECK (betaald >= 0)

/* 4 */

ALTER TABLE studenten
ADD peter INT FOREIGN KEY REFERENCES studenten(studnr)

/* 5 */

UPDATE studenten
SET peter = 10
WHERE studnr in (1,2)

UPDATE studenten
SET peter = 15
WHERE studnr = 3

/* 6 */

SELECT s1.studnr, s1.voornaam, s1.familienaam, s2.studnr, s2.voornaam, s2.familienaam
FROM studenten s1
JOIN studenten s2 ON s1.peter = s2.studnr
ORDER BY s1.studnr

/* 7 */

CREATE TABLE leraars
(
leraarnr INT IDENTITY PRIMARY KEY,
voornaam NVARCHAR(255),
familienaam NVARCHAR(255)
)

ALTER TABLE cursussen
ADD leraarnr INT FOREIGN KEY REFERENCES leraars(leraarnr)

/* 8 */

INSERT INTO leraars(voornaam, familienaam)
SELECT au_fname, au_lname
FROM pubs.dbo.authors
WHERE state = 'CA'

/* 9 */

UPDATE cursussen
SET leraarnr = 1
WHERE cursusnr = 1

UPDATE cursussen
SET leraarnr = 2
WHERE cursusnr = 2

UPDATE cursussen
SET leraarnr = 3
WHERE cursusnr = 3

UPDATE cursussen
SET leraarnr = 4
WHERE cursusnr = 4

UPDATE cursussen
SET leraarnr = 5
WHERE cursusnr = 5

/* 11 */

ALTER TABLE studenten_cursussen
DROP CONSTRAINT fk1_stud_curs

ALTER TABLE studenten
DROP CONSTRAINT pk_studenten

ALTER TABLE studenten
ADD CONSTRAINT pk_studenten PRIMARY KEY NONCLUSTERED(studnr)

ALTER TABLE studenten_cursussen
ADD CONSTRAINT fk1_stud_curs FOREIGN KEY(studnr) REFERENCES studenten(studnr)

/* 12 */

CREATE CLUSTERED INDEX iFamilienaam ON studenten(familienaam)
