create database school
go
use school
go
CREATE TABLE studenten
(studnr		INT identity NOT NULL,
 voornaam	NVARCHAR(30),
 familienaam	NVARCHAR(30),
 geboortedatum	DATE,
 geslacht	CHAR(1),
 betaald	INT DEFAULT 0,
 email 		NVARCHAR(50) DEFAULT NULL,
 CONSTRAINT pk_studenten PRIMARY KEY (studnr)
)

CREATE TABLE cursussen
(cursusnr	INT identity NOT NULL,
 cursusnaam	NVARCHAR(30),
 inschrijvingsgeld	INT,
 CONSTRAINT pk_cursussen PRIMARY KEY (cursusnr)
)

CREATE TABLE studenten_cursussen
(studnr		INT NOT NULL,
 cursusnr	INT NOT NULL,
 CONSTRAINT pk_stud_curs PRIMARY KEY (studnr, cursusnr),
 CONSTRAINT fk1_stud_curs FOREIGN KEY(studnr) REFERENCES studenten(studnr),
 CONSTRAINT fk2_stud_curs FOREIGN KEY(cursusnr) REFERENCES cursussen(cursusnr)
)

INSERT INTO studenten VALUES ('Francois','Bemelmans','1985-04-28','M',250,NULL)
INSERT INTO studenten VALUES ('Veerle','Van Maele','1987-07-06','V',50,NULL)
INSERT INTO studenten VALUES ('Karel','Govaert','1985-05-07','M',0,NULL)
INSERT INTO studenten VALUES ('Luc','Janssens','1988-12-10','M',50,NULL)
INSERT INTO studenten VALUES ('Leen','Verstraete','1988-12-09','V',120,NULL)
INSERT INTO studenten VALUES ('Jos','Van Den Berg','1985-08-23','M',150,NULL)
INSERT INTO studenten VALUES ('Diane','Hanssen','1986-05-12','V',50,NULL)
INSERT INTO studenten VALUES ('Bart','Baertmans','1990-11-03','M',50,NULL)
INSERT INTO studenten VALUES ('Carol','Mestdagh','1989-01-07','V',100,NULL)
INSERT INTO studenten VALUES ('Lucie','Jaspaert','1989-05-22','V',120,NULL)
INSERT INTO studenten VALUES ('Koen','Mortelgems','1990-04-04','M',100,NULL)
INSERT INTO studenten VALUES ('Marie','Van Maele','1988-10-26','V',0,NULL)
INSERT INTO studenten VALUES ('Marc','Vandoorne', NULL,'M',0,NULL)
INSERT INTO studenten VALUES ('Lieve','Van Maele','1986-11-24','V',0,NULL)
INSERT INTO studenten VALUES ('Marc','van Emergem','1980-11-01','M',0,NULL)

INSERT INTO cursussen VALUES ('C#',50)
INSERT INTO cursussen VALUES ('SQL',100)
INSERT INTO cursussen VALUES ('Java',70)
INSERT INTO cursussen VALUES ('Excel',70)
INSERT INTO cursussen VALUES ('MS SQL Server',100)

INSERT INTO studenten_cursussen VALUES (1,1)
INSERT INTO studenten_cursussen VALUES (1,2)
INSERT INTO studenten_cursussen VALUES (1,3)
INSERT INTO studenten_cursussen VALUES (1,4)
INSERT INTO studenten_cursussen VALUES (2,1)
INSERT INTO studenten_cursussen VALUES (4,1)
INSERT INTO studenten_cursussen VALUES (5,2)
INSERT INTO studenten_cursussen VALUES (5,3)
INSERT INTO studenten_cursussen VALUES (6,3)
INSERT INTO studenten_cursussen VALUES (6,4)
INSERT INTO studenten_cursussen VALUES (7,1)
INSERT INTO studenten_cursussen VALUES (8,1)
INSERT INTO studenten_cursussen VALUES (9,2)
INSERT INTO studenten_cursussen VALUES (10,2)
INSERT INTO studenten_cursussen VALUES (10,4)
INSERT INTO studenten_cursussen VALUES (11,2)
INSERT INTO studenten_cursussen VALUES (12,1)
INSERT INTO studenten_cursussen VALUES (12,2)




