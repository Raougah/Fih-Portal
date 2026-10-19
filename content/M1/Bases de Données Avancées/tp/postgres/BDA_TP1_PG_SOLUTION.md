### Note
Ida madirch had code:
```sql
SET search_path TO tp1_banque, public;
```
lazem tweli tekteb assem schema 9bel les tables kima heka:
```sql
SELECT * FROM tp1_banque.client
```
### Example
```sql
DO $$ 
DECLARE
	montant NUMERIC = 12000; 
BEGIN 
	IF montant >= 10000 THEN 
		RAISE NOTICE 'Montant important : %', montant; 
	ELSE RAISE NOTICE 'Montant ordinaire'; 
	END IF; 
END; 
$$ LANGUAGE plpgsql;
```

```sql
CREATE OR REPLACE FUNCTION doubler(valeur NUMERIC) 
RETURNS NUMERIC AS 
$$ 
BEGIN 
	RETURN valeur * 2; 
END; 
$$ LANGUAGE plpgsql; 

SELECT doubler(250);
```

### Exo 1
```sql
DO $$ 
DECLARE
	montant NUMERIC = 7000; 
BEGIN 
	IF montant >= 10000 THEN 
		RAISE NOTICE 'Montant depassant 10000'; 
	ELSE RAISE NOTICE 'Montant ne depassant pas 10000'; 
	END IF; 
END; 
$$ LANGUAGE plpgsql;
```
```sql
DO $$ 
DECLARE
	montant NUMERIC = 4000; 
BEGIN 
	IF montant < 5000 THEN 
		RAISE NOTICE 'moins de 5000'; 
	ELSIF montant<=20000 THEN
		RAISE NOTICE 'entre 5000 et 20000'; 
	ELSE RAISE NOTICE 'plus de 20000'; 
	END IF; 
END; 
$$ LANGUAGE plpgsql;
```
### Exo2
```sql
DO $$ 
BEGIN 
	FOR i IN 1..5 LOOP
		RAISE NOTICE '%',i;
	END LOOP;
END; 
$$ LANGUAGE plpgsql;
```
```sql
DO $$ 
DECLARE
	somme NUMERIC = 0; 
BEGIN 
	FOR i IN 1..10 LOOP
		somme=somme+i;
	END LOOP;
	RAISE NOTICE '%',somme;
END; 
$$ LANGUAGE plpgsql;

```

### Exo3
```sql
CREATE OR REPLACE FUNCTION calculer_bonus(montant NUMERIC)
RETURNS NUMERIC AS 
$$ 
BEGIN 
	RETURN montant * 2/100; 
END; 
$$ LANGUAGE plpgsql; 

SELECT calculer_bonus(10000),calculer_bonus(50000);
```
### Exo4

```sql
CREATE OR REPLACE FUNCTION est_solde_suffisant(id INTEGER, retrait NUMERIC)
RETURNS BOOLEAN AS 
$$ 
DECLARE
	montant NUMERIC=0;
BEGIN 
	SELECT solde 
	INTO montant
	FROM compte AS c 
	WHERE c.id_compte=id;
	RETURN montant>=retrait; 
END; 
$$ LANGUAGE plpgsql; 

SELECT est_solde_suffisant(101,150000),est_solde_suffisant(106,5000);
```