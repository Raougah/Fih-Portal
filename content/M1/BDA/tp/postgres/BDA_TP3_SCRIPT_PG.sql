-- TP3 - PostgreSQL / pgAdmin. Executer dans la base avancees.
-- ATTENTION : reinitialise uniquement les tables  du schema public.
SET search_path TO public;

DROP ROLE IF EXISTS responsable_rh;
DROP ROLE IF EXISTS gestionnaire_finance;
DROP ROLE IF EXISTS chef_projet;
DROP ROLE IF EXISTS stagiaire;

DROP TABLE IF EXISTS affectation CASCADE;
DROP TABLE IF EXISTS employe CASCADE;
DROP TABLE IF EXISTS projet CASCADE;
DROP TABLE IF EXISTS departement CASCADE;
DROP TYPE IF EXISTS adresse_postale CASCADE;



DROP TABLE IF EXISTS commandes_partitionnees CASCADE;
DROP TABLE IF EXISTS lignes_commande CASCADE;
DROP TABLE IF EXISTS commandes CASCADE;
DROP TABLE IF EXISTS produits CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS agences CASCADE;

DROP TABLE IF EXISTS clients_ouest;
DROP TABLE IF EXISTS clients_centre;
DROP TABLE IF EXISTS clients_est;
DROP TABLE IF EXISTS clients_identite;
DROP TABLE IF EXISTS clients_contact;
DROP TABLE IF EXISTS commandes_partitionnees;

DROP TABLE IF EXISTS lab_commandes CASCADE;
DROP TABLE IF EXISTS lab_ordre CASCADE;


CREATE TABLE agences (
 id_agence integer PRIMARY KEY, nom varchar(80) NOT NULL,
 region varchar(20) NOT NULL CHECK(region IN ('Ouest','Centre','Est')),
 ville varchar(50) NOT NULL
);
CREATE TABLE clients (
 id_client integer PRIMARY KEY, nom varchar(60) NOT NULL,
 prenom varchar(60) NOT NULL, email varchar(120) NOT NULL UNIQUE,
 telephone varchar(20) NOT NULL, region varchar(20) NOT NULL
 CHECK(region IN ('Ouest','Centre','Est')),
 id_agence integer NOT NULL REFERENCES agences(id_agence),
 date_inscription date NOT NULL
);
CREATE TABLE produits (
 id_produit integer PRIMARY KEY, designation varchar(100) NOT NULL,
 categorie varchar(30) NOT NULL, prix numeric(12,2) NOT NULL CHECK(prix>0)
);
CREATE TABLE commandes (
 id_commande bigint PRIMARY KEY, id_client integer NOT NULL REFERENCES clients(id_client),
 date_commande date NOT NULL, statut varchar(20) NOT NULL,
 montant_total numeric(12,2) NOT NULL CHECK(montant_total>=0)
);
CREATE TABLE lignes_commande (
 id_ligne bigint PRIMARY KEY, id_commande bigint NOT NULL REFERENCES commandes(id_commande),
 id_produit integer NOT NULL REFERENCES produits(id_produit),
 quantite integer NOT NULL CHECK(quantite>0), prix_unitaire numeric(12,2) NOT NULL
);

INSERT INTO agences
SELECT g, 'Agence '||g,
 CASE WHEN g<=10 THEN 'Ouest' WHEN g<=20 THEN 'Centre' ELSE 'Est' END,
 CASE WHEN g<=10 THEN 'Oran' WHEN g<=20 THEN 'Alger' ELSE 'Constantine' END
FROM generate_series(1,30) g;

INSERT INTO clients
SELECT g, 'Nom'||g, 'Prenom'||g, 'client'||g||'@exemple.dz',
 '0550'||lpad(g::text,6,'0'),
 CASE WHEN (g-1)%3=0 THEN 'Ouest' WHEN (g-1)%3=1 THEN 'Centre' ELSE 'Est' END,
 CASE WHEN (g-1)%3=0 THEN 1+((g-1)/3)%10
      WHEN (g-1)%3=1 THEN 11+((g-1)/3)%10
      ELSE 21+((g-1)/3)%10 END,
 DATE '2022-01-01'+(g%1400)
FROM generate_series(1,12000) g;

INSERT INTO produits
SELECT g, 'Produit '||g,
 CASE (g%4) WHEN 0 THEN 'Informatique' WHEN 1 THEN 'Mobilier'
 WHEN 2 THEN 'Fournitures' ELSE 'Equipement' END,
 (500+(g%100)*125)::numeric(12,2)
FROM generate_series(1,400) g;

-- 180 000 commandes sur 2023-2025, reparties uniformement.
INSERT INTO commandes
SELECT g, 1+((g*37)%12000),
 DATE '2023-01-01'+((g*17)%1095),
 CASE WHEN g%10=0 THEN 'annulee' WHEN g%4=0 THEN 'en_cours' ELSE 'livree' END,
 (1000+(g%500)*37)::numeric(12,2)
FROM generate_series(1,180000) g;

-- Deux lignes par commande : 360 000 lignes.
INSERT INTO lignes_commande
SELECT (c.id_commande-1)*2+n,
 c.id_commande,
 1+((c.id_commande::integer*7+n*19)%400),
 1+((c.id_commande::integer+n)%5),
 (500+((c.id_commande::integer+n)%100)*125)::numeric(12,2)
FROM commandes c CROSS JOIN generate_series(1,2) n;

ANALYZE agences;
ANALYZE clients;
ANALYZE produits;
ANALYZE commandes;
ANALYZE lignes_commande;

SELECT 'agences' AS table_nom, count(*) FROM agences
UNION ALL SELECT 'clients', count(*) FROM clients
UNION ALL SELECT 'produits', count(*) FROM produits
UNION ALL SELECT 'commandes', count(*) FROM commandes
UNION ALL SELECT 'lignes_commande', count(*) FROM lignes_commande;
