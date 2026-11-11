- [[BDA_TP2_SCRIPT_PG.sql|fichier]]

# Create with this shit
```sql
BEGIN;
DROP TABLE IF EXISTS public.affectation CASCADE;
DROP TABLE IF EXISTS public.employe CASCADE;
DROP TABLE IF EXISTS public.projet CASCADE;
DROP TABLE IF EXISTS public.departement CASCADE;
DROP TYPE IF EXISTS public.adresse_postale CASCADE;
CREATE TYPE public.adresse_postale AS (
    rue TEXT,
    ville VARCHAR(60),
    code_postal VARCHAR(10)
);
CREATE TABLE public.departement (
    id_departement INTEGER PRIMARY KEY,
    nom VARCHAR(80) NOT NULL UNIQUE,
    ville VARCHAR(60) NOT NULL,
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0)
);
CREATE TABLE public.employe (
    id_employe INTEGER PRIMARY KEY,
    nom VARCHAR(60) NOT NULL,
    prenom VARCHAR(60) NOT NULL,
    id_departement INTEGER NOT NULL REFERENCES public.departement(id_departement),
    poste VARCHAR(70) NOT NULL,
    salaire NUMERIC(10,2) NOT NULL CHECK (salaire > 0),
    date_embauche DATE NOT NULL,
    adresse public.adresse_postale,
    competences TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    preferences JSON NOT NULL DEFAULT '{}'::JSON
);
CREATE TABLE public.projet (
    id_projet INTEGER PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('planifie','en_cours','termine'))
);
CREATE TABLE public.affectation (
    id_employe INTEGER NOT NULL REFERENCES public.employe(id_employe),
    id_projet INTEGER NOT NULL REFERENCES public.projet(id_projet),
    heures INTEGER NOT NULL CHECK (heures > 0),
    PRIMARY KEY (id_employe,id_projet)
);
INSERT INTO public.departement VALUES
(1,'Informatique','Oran',8500000),(2,'Finance','Alger',6500000),
(3,'Ressources humaines','Oran',3200000),(4,'Marketing','Constantine',4100000);
INSERT INTO public.employe VALUES
(101,'Benali','Sara',1,'Developpeuse',92000,'2022-03-14',ROW('12 rue Emir Abdelkader','Oran','31000')::public.adresse_postale,ARRAY['SQL','Python'], '{"langue":"fr","teletravail":true}'),
(102,'Chergui','Karim',1,'Administrateur BDD',118000,'2020-09-10',ROW('5 boulevard de la Republique','Oran','31000')::public.adresse_postale,ARRAY['SQL','PostgreSQL','Linux'], '{"langue":"fr","teletravail":false}'),
(103,'Mansouri','Lina',2,'Comptable',79000,'2023-01-09',ROW('8 rue Didouche Mourad','Alger','16000')::public.adresse_postale,ARRAY['Excel','Finance'], '{"langue":"ar","teletravail":false}'),
(104,'Boudiaf','Amine',3,'Charge RH',74000,'2021-11-02',ROW('21 rue Larbi Ben Mhidi','Oran','31000')::public.adresse_postale,ARRAY['Recrutement','Excel'], '{"langue":"fr","teletravail":true}'),
(105,'Haddad','Nadia',4,'Analyste marketing',87000,'2022-06-20',ROW('3 avenue de la Liberte','Constantine','25000')::public.adresse_postale,ARRAY['SQL','Marketing'], '{"langue":"en","teletravail":true}'),
(106,'Saidi','Yacine',1,'Developpeur',83000,'2024-02-12',ROW('7 rue des Jasmins','Mostaganem','27000')::public.adresse_postale,ARRAY['Java','SQL'], '{"langue":"fr","teletravail":false}'),
(107,'Zerrouki','Imene',2,'Controleuse',97000,'2019-05-16',ROW('15 rue Hassiba Ben Bouali','Alger','16000')::public.adresse_postale,ARRAY['Audit','Finance','SQL'], '{"langue":"ar","teletravail":true}'),
(108,'Brahimi','Sofiane',4,'Designer',76000,'2024-10-01',ROW('10 rue du Centre','Constantine','25000')::public.adresse_postale,ARRAY['Figma','Design'], '{"langue":"fr","teletravail":false}'),
(109,'Kaci','Meriem',1,'Analyste donnees',105000,'2020-01-21',ROW('19 rue de la Gare','Oran','31000')::public.adresse_postale,ARRAY['SQL','Python','Statistiques'], '{"langue":"en","teletravail":true}'),
(110,'Gacem','Riad',3,'Responsable RH',112000,'2018-08-05',ROW('2 rue des Palmiers','Oran','31000')::public.adresse_postale,ARRAY['Management','Recrutement'], '{"langue":"fr","teletravail":false}'),
(111,'Meziane','Amina',2,'Assistante finance',68000,'2025-03-17',ROW('4 rue du Port','Alger','16000')::public.adresse_postale,ARRAY['Excel'], '{"langue":"fr","teletravail":true}'),
(112,'Ouali','Bilal',4,'Charge communication',71000,'2023-07-03',ROW('6 avenue du 1er Novembre','Constantine','25000')::public.adresse_postale,ARRAY['Communication','Design'], '{"langue":"ar","teletravail":false}');
INSERT INTO public.projet VALUES
(201,'Portail interne',1800000,'en_cours'),(202,'Audit financier',900000,'en_cours'),
(203,'Campagne nationale',1200000,'planifie'),(204,'Tableau de bord RH',650000,'termine'),
(205,'Analyse des ventes',1500000,'en_cours');
INSERT INTO public.affectation VALUES
(101,201,80),(102,201,35),(106,201,60),(109,201,25),(109,205,65),
(103,202,70),(107,202,45),(105,203,55),(108,203,40),(104,204,35),(110,204,25),(111,202,20);
COMMIT;
SELECT COUNT(*) FROM public.employe;
```

# Recreate with this not create

```sql
-- TP 2 BDD avancees - PostgreSQL / pgAdmin
-- Creer d'abord une base tp2_avancees dans pgAdmin, puis executer ce script.
-- Toutes les tables et le type sont crees dans le schema public.
-- ATTENTION : reinitialise uniquement les objets pedagogiques ci-dessous.


DROP ROLE responsable_rh;
DROP ROLE gestionnaire_finance;
DROP ROLE chef_projet;
DROP ROLE stagiaire;

BEGIN;
DROP TABLE IF EXISTS public.affectation CASCADE;
DROP TABLE IF EXISTS public.employe CASCADE;
DROP TABLE IF EXISTS public.projet CASCADE;
DROP TABLE IF EXISTS public.departement CASCADE;
DROP TYPE IF EXISTS public.adresse_postale CASCADE;
CREATE TYPE public.adresse_postale AS (
    rue TEXT,
    ville VARCHAR(60),
    code_postal VARCHAR(10)
);
CREATE TABLE public.departement (
    id_departement INTEGER PRIMARY KEY,
    nom VARCHAR(80) NOT NULL UNIQUE,
    ville VARCHAR(60) NOT NULL,
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0)
);
CREATE TABLE public.employe (
    id_employe INTEGER PRIMARY KEY,
    nom VARCHAR(60) NOT NULL,
    prenom VARCHAR(60) NOT NULL,
    id_departement INTEGER NOT NULL REFERENCES public.departement(id_departement),
    poste VARCHAR(70) NOT NULL,
    salaire NUMERIC(10,2) NOT NULL CHECK (salaire > 0),
    date_embauche DATE NOT NULL,
    adresse public.adresse_postale,
    competences TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[],
    preferences JSON NOT NULL DEFAULT '{}'::JSON
);
CREATE TABLE public.projet (
    id_projet INTEGER PRIMARY KEY,
    titre VARCHAR(100) NOT NULL,
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0),
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('planifie','en_cours','termine'))
);
CREATE TABLE public.affectation (
    id_employe INTEGER NOT NULL REFERENCES public.employe(id_employe),
    id_projet INTEGER NOT NULL REFERENCES public.projet(id_projet),
    heures INTEGER NOT NULL CHECK (heures > 0),
    PRIMARY KEY (id_employe,id_projet)
);
INSERT INTO public.departement VALUES
(1,'Informatique','Oran',8500000),(2,'Finance','Alger',6500000),
(3,'Ressources humaines','Oran',3200000),(4,'Marketing','Constantine',4100000);
INSERT INTO public.employe VALUES
(101,'Benali','Sara',1,'Developpeuse',92000,'2022-03-14',ROW('12 rue Emir Abdelkader','Oran','31000')::public.adresse_postale,ARRAY['SQL','Python'], '{"langue":"fr","teletravail":true}'),
(102,'Chergui','Karim',1,'Administrateur BDD',118000,'2020-09-10',ROW('5 boulevard de la Republique','Oran','31000')::public.adresse_postale,ARRAY['SQL','PostgreSQL','Linux'], '{"langue":"fr","teletravail":false}'),
(103,'Mansouri','Lina',2,'Comptable',79000,'2023-01-09',ROW('8 rue Didouche Mourad','Alger','16000')::public.adresse_postale,ARRAY['Excel','Finance'], '{"langue":"ar","teletravail":false}'),
(104,'Boudiaf','Amine',3,'Charge RH',74000,'2021-11-02',ROW('21 rue Larbi Ben Mhidi','Oran','31000')::public.adresse_postale,ARRAY['Recrutement','Excel'], '{"langue":"fr","teletravail":true}'),
(105,'Haddad','Nadia',4,'Analyste marketing',87000,'2022-06-20',ROW('3 avenue de la Liberte','Constantine','25000')::public.adresse_postale,ARRAY['SQL','Marketing'], '{"langue":"en","teletravail":true}'),
(106,'Saidi','Yacine',1,'Developpeur',83000,'2024-02-12',ROW('7 rue des Jasmins','Mostaganem','27000')::public.adresse_postale,ARRAY['Java','SQL'], '{"langue":"fr","teletravail":false}'),
(107,'Zerrouki','Imene',2,'Controleuse',97000,'2019-05-16',ROW('15 rue Hassiba Ben Bouali','Alger','16000')::public.adresse_postale,ARRAY['Audit','Finance','SQL'], '{"langue":"ar","teletravail":true}'),
(108,'Brahimi','Sofiane',4,'Designer',76000,'2024-10-01',ROW('10 rue du Centre','Constantine','25000')::public.adresse_postale,ARRAY['Figma','Design'], '{"langue":"fr","teletravail":false}'),
(109,'Kaci','Meriem',1,'Analyste donnees',105000,'2020-01-21',ROW('19 rue de la Gare','Oran','31000')::public.adresse_postale,ARRAY['SQL','Python','Statistiques'], '{"langue":"en","teletravail":true}'),
(110,'Gacem','Riad',3,'Responsable RH',112000,'2018-08-05',ROW('2 rue des Palmiers','Oran','31000')::public.adresse_postale,ARRAY['Management','Recrutement'], '{"langue":"fr","teletravail":false}'),
(111,'Meziane','Amina',2,'Assistante finance',68000,'2025-03-17',ROW('4 rue du Port','Alger','16000')::public.adresse_postale,ARRAY['Excel'], '{"langue":"fr","teletravail":true}'),
(112,'Ouali','Bilal',4,'Charge communication',71000,'2023-07-03',ROW('6 avenue du 1er Novembre','Constantine','25000')::public.adresse_postale,ARRAY['Communication','Design'], '{"langue":"ar","teletravail":false}');
INSERT INTO public.projet VALUES
(201,'Portail interne',1800000,'en_cours'),(202,'Audit financier',900000,'en_cours'),
(203,'Campagne nationale',1200000,'planifie'),(204,'Tableau de bord RH',650000,'termine'),
(205,'Analyse des ventes',1500000,'en_cours');
INSERT INTO public.affectation VALUES
(101,201,80),(102,201,35),(106,201,60),(109,201,25),(109,205,65),
(103,202,70),(107,202,45),(105,203,55),(108,203,40),(104,204,35),(110,204,25),(111,202,20);
COMMIT;
-- Controle : SELECT COUNT(*) FROM public.employe; -- 12
-- Le script n'installe pas de roles : ceux-ci sont crees par les etudiants en partie 2.


```