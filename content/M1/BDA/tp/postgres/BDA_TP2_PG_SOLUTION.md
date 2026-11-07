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

> le type composite sert a representer une information composée de plusieurs champs liés entre eux

![[important_note.jpg]]
> ya rabi zwj abdou w 3tih token t3 fortnite + rabi y3tih wsh ytmana amiiiiiiiine

![[important_note_down.png]]