# Partie 1

## Exo 1

### Question 1 qst

```sql
CREATE OR REPLACE FUNCTION affichage() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT prenom , nom, (adresse).ville AS ville   FROM public.employe LOOP
    RAISE NOTICE 'le nom:% - le prenom % : la ville :%', r.prenom, r.nom, r.ville;
  END LOOP;
END;
$$;
SELECT affichage();
```

### Question 2 qst

```sql
CREATE OR REPLACE FUNCTION oran_employees() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT prenom , nom, (adresse).ville AS ville   FROM public.employe WHERE (adresse).ville = 'Oran' ORDER BY nom LOOP
    RAISE NOTICE 'le nom:% - le prenom % : la ville :%', r.prenom, r.nom, r.ville;
  END LOOP;
END;
$$;
SELECT oran_employees();
```

### Question 3 qst

```sql
CREATE OR REPLACE FUNCTION design_employees() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT prenom , nom, (adresse).ville AS ville, competences    FROM public.employe WHERE  'Design' =ANY(competences) LOOP
    RAISE NOTICE 'le nom:% - le prenom % : la ville :% les competences : %', r.prenom, r.nom, r.ville,r.competences;
  END LOOP;
END;
$$;
SELECT design_employees();
```

### Question 4 qst

```sql
CREATE OR REPLACE FUNCTION tele_employee() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT prenom , nom, (adresse).ville AS ville, preferences FROM public.employe WHERE  (adresse).ville <>  'Alger' AND (preferences ->> 'teletravail')::boolean IS TRUE LOOP     
    RAISE NOTICE 'le nom:% - le prenom % : la ville :% ', r.prenom, r.nom, r.ville;
  END LOOP;
END;
$$;
SELECT tele_employee();
```

## Exo 2

### Question 1 qst

```sql
CREATE OR REPLACE FUNCTION employees() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
  r RECORD;
BEGIN
  FOR r IN SELECT prenom , nom, poste , preferences ->> 'langue' AS langue FROM public.employe LOOP     
    RAISE NOTICE 'le nom:% - le prenom % : le poste :% ,langue: %', r.prenom, r.nom, r.poste,r.langue;
  END LOOP;
END;
$$;
SELECT employees();
```

### Question 2qst

```sql
CREATE OR REPLACE FUNCTION inser() RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
  update public.employe  SET preferences = '{"langue":"fr","teletravail":true}'::json WHERE id_employe=108 ;  
    RAISE NOTICE 'done ';
END;
$$;
SELECT inser()();
```

> bah tconfirmiw

```sql
SELECT * FROM public.employe WHERE id_employe=108;
```

### Question 3 qst

```sql
CREATE OR REPLACE FUNCTION inser2() RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
  update  public.employe  SET preferences = (preferences::jsonb || '{"hybride" :false}'::jsonb)::json WHERE id_employe=102 ;  
    RAISE NOTICE 'done ';
END;
$$;
SELECT inser2();
```

> bah tconfirmiw

```sql
SELECT * FROM public.employe WHERE id_employe=102;
```

### Question 4 qst

```sql
CREATE OR REPLACE FUNCTION inser3() RETURNS void
LANGUAGE plpgsql AS $$
BEGIN
  update  public.employe  SET preferences = (preferences::jsonb ||  CASE
      WHEN (preferences ->> 'teletravail')::boolean IS TRUE
        THEN '{"hybride": true}'::jsonb
      ELSE '{"hybride": false}'::jsonb
    END
  )::json;   
    RAISE NOTICE 'done ';
END;
$$;
SELECT inser3();
```

> bah tconfirmiw

```sql
SELECT * FROM public.employe;
```

## Exo 3

### Question qst1

```sql
CREATE OR REPLACE FUNCTION affiche() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
r RECORD;
BEGIN
  FOR r IN SELECT nom , cardinality(competences) AS nbr_c FROM public.employe LOOP     
    RAISE NOTICE 'le nom:% - le nbr de competences : % ', r.nom, r.nbr_c;
  END LOOP;
END;
$$;
SELECT affiche();
```

### Question qst 2

```sql
CREATE OR REPLACE FUNCTION affiche() RETURNS void
LANGUAGE plpgsql AS $$

BEGIN
   UPDATE public.employe
  SET competences = array_append(competences, 'Docker')WHERE id_employe = 104;  
 	RAISE NOTICE 'done ';
END;
$$;
SELECT affiche();
```

> bah tconfirmiw

```sql
SELECT * FROM public.employe WHERE id_employe=104 ;
```

### Question qst3

```sql
CREATE OR REPLACE FUNCTION affiche2() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE 
r RECORD;
BEGIN
 FOR r IN SELECT nom, prenom, unnest(competences) AS competence
FROM public.employe
WHERE id_employe = 102 LOOP
RAISE NOTICE 'le nom:% - le prenom : %  - la competence : %', r.nom, r.prenom, r.competence;
END LOOP ;
END;
$$;
SELECT affiche2();
```

### Question qst 4

```sql
CREATE OR REPLACE FUNCTION filterr() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
r RECORD;
BEGIN
  FOR r IN SELECT nom , prenom ,competences,preferences ->> 'langue' AS langue FROM public.employe  WHERE preferences ->>'langue'='fr'  AND 'SQL' =ANY(competences) AND 'Python' =ANY(competences) LOOP     
    RAISE NOTICE 'le nom:% - le prenom:% -les competences : %  - langue : %', r.nom,r.prenom, r.competences,r.langue;
  END LOOP;
END;
$$;
SELECT filterr();
```

## Exo 4

### Question 1qst

```sql
CREATE OR REPLACE FUNCTION addd() RETURNS void
LANGUAGE plpgsql AS $$

BEGIN
  ALTER TABLE public.employe ADD contacts TEXT[];     
    RAISE NOTICE 'contacts ajouté ';
	UPDATE public.employe SET contacts = ARRAY['haj moussa', 'moussa lhaj'] WHERE id_employe = 101;
	RAISE NOTICE 'contacts ajouté a l’employé 101 ';
END;
$$;
SELECT addd();
```

> bah tconfirmiw

```sql
SELECT * FROM public.employe WHERE id_employe=101;
```

### Question 2 qst

```sql
CREATE OR REPLACE FUNCTION filterrr() RETURNS void
LANGUAGE plpgsql AS $$
DECLARE
r RECORD;
BEGIN
  FOR r IN SELECT e.nom , e.prenom ,(adresse).ville AS ville , competences ,preferences ->> 'langue' AS langue FROM public.employe AS e  JOIN public.departement AS d ON e.id_departement=d.id_departement WHERE d.nom='Informatique'  LOOP     
    RAISE NOTICE 'le nom:% - le prenom:% -les competences : %  - langue : %', r.nom,r.prenom, r.competences,r.langue;
  END LOOP;
END;
$$;
SELECT filterrr();
```

### Question 3qst

```sql
CREATE TYPE public.infos_professionnel AS (
    poste        TEXT,
    salaire      NUMERIC(10,2),
    date_embauche DATE
);
```

### ziyada question

```sql
ALTER TABLE employe
    ADD COLUMN infos_professionnel public.infos_professionnel;
	
UPDATE employe
SET infos_professionnel = ROW(poste, salaire, date_embauche)::public.infos_professionnel;

ALTER TABLE employe
    DROP COLUMN poste,
    DROP COLUMN salaire,
    DROP COLUMN date_embauche;
	
SELECT * from employe;
```

> le type composite sert a representer une information composée de plusieurs champs liés entre eux

![[important_note.jpg]]
# **ya rabi zwj abdou w 3tih token t3 fortnite + rabi y3tih wsh ytmana amiiiiiiiine**

![[important_note_down.png]]

# Partie 2
### exo1

```sql
SELECT current_user, session_user;
SELECT * FROM departement;
```

```sql
CREATE ROLE responsable_rh NOLOGIN;
CREATE ROLE gestionnaire_finance NOLOGIN;
CREATE ROLE chef_projet NOLOGIN;
CREATE ROLE stagiaire NOLOGIN;
```

```sql
GRANT USAGE ON SCHEMA public TO responsable_rh, gestionnaire_finance, chef_projet, stagiaire;
```

### exo2

```sql
GRANT SELECT ON employe, departement TO responsable_rh;
GRANT UPDATE (poste, date_embauche) ON employe TO responsable_rh;
```

```sql
GRANT SELECT (id_employe, nom, prenom, salaire) ON employe TO gestionnaire_finance;
GRANT SELECT ON departement, projet TO gestionnaire_finance;`
GRANT UPDATE (budget) ON projet TO gestionnaire_finance;
```

```sql
GRANT SELECT ON projet, affectation TO chef_projet;
GRANT SELECT (id_employe, nom, prenom) ON employe TO chef_projet;
GRANT UPDATE (heures) ON affectation TO chef_projet;
```

```sql
GRANT SELECT ON departement, projet TO stagiaire;
```

### exo3
```sql
SET ROLE responsable_rh;
UPDATE employe SET poste = 'bilal' WHERE id_employe = 101; 


UPDATE employe SET salaire = 200000 WHERE id_employe = 101;


RESET ROLE;
```

```sql
SET ROLE gestionnaire_finance;
SELECT nom, salaire FROM employe;                                
UPDATE projet SET budget = budget + 10000 WHERE id_projet = 202;

  
UPDATE employe SET poste = 'Chef comptable' WHERE id_employe = 103;  


RESET ROLE;
```

```sql
SET ROLE chef_projet;
UPDATE affectation SET heures = 120 WHERE id_employe = 109 AND id_projet = 201;  
SELECT salaire FROM employe WHERE id_employe = 101;                           
RESET ROLE;
```

```sql
SET ROLE stagiaire;
SELECT * FROM projet;                               
SELECT * FROM employe;                                
UPDATE projet SET budget = 0 WHERE id_projet = 201;  
RESET ROLE;
```
### exo4
```sql
REVOKE UPDATE (heures) ON affectation FROM chef_projet;
SET ROLE chef_projet;
UPDATE affectation SET heures = 120 WHERE id_employe = 109 AND id_projet = 201;  
RESET ROLE;
```

```sql
REVOKE SELECT ON projet FROM stagiaire;
SET ROLE stagiaire;
SELECT * FROM projet;                               
SELECT * FROM departement;                                
RESET ROLE;
```

```sql
REVOKE SELECT (nom, prenom) ON employe FROM gestionnaire_finance;


SET ROLE gestionnaire_finance;
SELECT nom,prenom FROM employe; 
SELECT salaire FROM employe;   

RESET ROLE;
```

```sql
REVOKE UPDATE (date_embauche) ON employe FROM responsable_rh;
SET ROLE responsable_rh;
UPDATE employe SET date_embauche = CURRENT_DATE WHERE id_employe = 101;

RESET ROLE;
```