![[important_note.jpg]]
# Note
Ida madirch had code:
```sql
SET search_path TO tp1_banque, public;
```
lazem tweli tekteb assem schema 9bel les tables kima heka:
```sql
SELECT * FROM tp1_banque.client
```
![[important_note_down.png]]
# Partie 1

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

# Partie 2

### example
```sql
CREATE OR REPLACE PROCEDURE afficher_solde(p_id INTEGER) 
LANGUAGE plpgsql AS 
$$ 
DECLARE 
	v_solde NUMERIC; 
BEGIN 
	SELECT solde 
	INTO v_solde 
	FROM compte 
	WHERE id_compte = p_id; 
	RAISE NOTICE 'Solde du compte % : % DA', p_id, v_solde; 
	END; 
$$; 
CALL afficher_solde(101);
```

### Exo1
```sql
CREATE OR REPLACE PROCEDURE afficher_compte(id_c INTEGER) 
LANGUAGE plpgsql AS 
$$ 
DECLARE 
	v_solde NUMERIC; 
BEGIN 
	SELECT solde 
	INTO v_solde 
	FROM compte 
	WHERE id_compte = id_c; 
	RAISE NOTICE 'Solde du compte % : % DA', id_c, v_solde; 
	END; 
$$; 
CALL afficher_compte(101);
CALL afficher_compte(105);
```

```sql
CREATE OR REPLACE PROCEDURE afficher_compte(id_c INTEGER) 
LANGUAGE plpgsql AS 
$$ 
DECLARE 
	v_solde NUMERIC; 
	v_type TEXT;
BEGIN 
	SELECT solde,type_compte
	INTO v_solde,v_type
	FROM compte 
	WHERE id_compte = id_c; 
	if not found THEN
		RAISE NOTICE 'Compte existe pas';
		RETURN;
	END IF;
	RAISE NOTICE 'Solde du compte % : % DA et type du compte %', id_c, v_solde,v_type; 
END; 
$$; 
CALL afficher_compte(2000);
CALL afficher_compte(105);
```
### Exo2
```sql
CREATE OR REPLACE PROCEDURE effectuer_depot(c_id INTEGER, d_montant NUMERIC)
LANGUAGE plpgsql AS 
$$ 
BEGIN 
	IF d_montant <= 0 THEN
		RAISE NOTICE 'MONTANT INSUFFISANT';
		RETURN;
	END IF;
	UPDATE compte SET solde = solde + d_montant WHERE id_compte = c_id;
	IF NOT FOUND THEN 
		RAISE NOTICE 'Compte inexistant'; 
		RETURN; 
	END IF;
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_id,'depot',d_montant);
	
END; 
$$; 

CALL effectuer_depot(106,50000);
SELECT * FROM operation;
```
### Exo3
```sql
CREATE OR REPLACE PROCEDURE effectuer_virement(c_source INTEGER, c_destination INTEGER, v_montant NUMERIC)
LANGUAGE plpgsql AS 
$$
DECLARE
	s_actif BOOLEAN;
	d_actif BOOLEAN;
	s_solde NUMERIC;
BEGIN 
	IF c_source = c_destination THEN
		RAISE NOTICE 'MEME COMPTE';
		RETURN;
	END IF;
	
	IF v_montant <= 0 THEN
		RAISE NOTICE 'MONTANT INSUFFISANT';
		RETURN;
	END IF;
	
	SELECT actif, solde INTO s_actif, s_solde FROM compte WHERE id_compte=c_source;
	
	IF not found THEN
		RAISE NOTICE 'Compte source inexistant';
		RETURN;
	END IF;
	
	if not s_actif THEN
		RAISE NOTICE 'Compte source inactif';
		RETURN;
	END IF;
	
	if v_montant> s_solde THEN
		RAISE NOTICE 'Fond insufisant';
		RETURN;
	END IF;

	
	SELECT actif INTO d_actif FROM compte WHERE id_compte=c_destination;

	
	IF not found THEN
		RAISE NOTICE 'Compte destination inexistant';
		RETURN;
	END IF;
	
	if not d_actif THEN
		RAISE NOTICE 'Compte destination inactif';
		RETURN;
	END IF;
	
	UPDATE compte SET solde = solde - v_montant WHERE id_compte = c_source;
	UPDATE compte SET solde = solde + v_montant WHERE id_compte = c_destination;
	
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_source,'virement_sortant',v_montant);
	
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_destination,'virement_entrant',v_montant);
	
END; 
$$; 

CALL effectuer_virement(101,104,2010);
SELECT * FROM operation;
SELECT * FROM compte WHERE id_compte=101 OR id_compte=104;

CALL effectuer_virement(110,103,100000);
SELECT * FROM operation;
SELECT * FROM compte WHERE id_compte=110 OR id_compte=103;

CALL effectuer_virement(200,103,10);
CALL effectuer_virement(101,200,10);

```

### Exo4

**copier/coller**
```sql
BEGIN; 
UPDATE compte SET solde = solde + 1000 WHERE id_compte = 109; 
ROLLBACK; 

SELECT solde FROM compte WHERE id_compte = 109; 

BEGIN; 
UPDATE compte SET solde = solde + 1000 WHERE id_compte = 109; 
COMMIT; 

SELECT solde FROM compte WHERE id_compte = 109
```

```sql
BEGIN; 
UPDATE compte SET solde = solde + 500 WHERE id_compte = 107; 

SAVEPOINT etape1; 
UPDATE compte SET solde = solde + 700 WHERE id_compte = 109; 
ROLLBACK TO SAVEPOINT etape1; 

COMMIT; 

SELECT id_compte, solde FROM compte WHERE id_compte IN (107, 109) ORDER BY id_compte;

```

```sql
BEGIN; 
UPDATE compte SET solde = solde + 200 WHERE id_compte = 105;
```
```sql
SELECT solde FROM compte WHERE id_compte = 105; 
UPDATE compte SET solde = solde + 300 WHERE id_compte = 105;
```

# Partie 3

![[important_note.jpg]]
# **galek lazem t3awed trunni script ta3 creation database ou moraha trecrei les procedures**
![[important_note_down.png]]
```sql
CREATE OR REPLACE PROCEDURE effectuer_virement(c_source INTEGER, c_destination INTEGER, v_montant NUMERIC)
LANGUAGE plpgsql AS 
$$
DECLARE
	s_actif BOOLEAN;
	d_actif BOOLEAN;
	s_solde NUMERIC;
BEGIN 
	IF c_source = c_destination THEN
		RAISE NOTICE 'MEME COMPTE';
		RETURN;
	END IF;
	
	IF v_montant <= 0 THEN
		RAISE NOTICE 'MONTANT INSUFFISANT';
		RETURN;
	END IF;
	
	SELECT actif, solde INTO s_actif, s_solde FROM compte WHERE id_compte=c_source;
	
	IF not found THEN
		RAISE NOTICE 'Compte source inexistant';
		RETURN;
	END IF;
	
	if not s_actif THEN
		RAISE NOTICE 'Compte source inactif';
		RETURN;
	END IF;
	
	if v_montant> s_solde THEN
		RAISE NOTICE 'Fond insufisant';
		RETURN;
	END IF;

	
	SELECT actif INTO d_actif FROM compte WHERE id_compte=c_destination;

	
	IF not found THEN
		RAISE NOTICE 'Compte destination inexistant';
		RETURN;
	END IF;
	
	if not d_actif THEN
		RAISE NOTICE 'Compte destination inactif';
		RETURN;
	END IF;
	
	UPDATE compte SET solde = solde - v_montant WHERE id_compte = c_source;
	UPDATE compte SET solde = solde + v_montant WHERE id_compte = c_destination;
	
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_source,'virement_sortant',v_montant);
	
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_destination,'virement_entrant',v_montant);
	
END; 
$$; 
CREATE OR REPLACE PROCEDURE effectuer_depot(c_id INTEGER, d_montant NUMERIC)
LANGUAGE plpgsql AS 
$$ 
BEGIN 
	IF d_montant <= 0 THEN
		RAISE NOTICE 'MONTANT INSUFFISANT';
		RETURN;
	END IF;
	UPDATE compte SET solde = solde + d_montant WHERE id_compte = c_id;
	IF NOT FOUND THEN 
		RAISE NOTICE 'Compte inexistant'; 
		RETURN; 
	END IF;
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (c_id,'depot',d_montant);
	
END; 
$$; 

CREATE OR REPLACE PROCEDURE afficher_compte(id_c INTEGER) 
LANGUAGE plpgsql AS 
$$ 
DECLARE 
	v_solde NUMERIC; 
	v_type TEXT;
BEGIN 
	SELECT solde,type_compte
	INTO v_solde,v_type
	FROM compte 
	WHERE id_compte = id_c; 
	if not found THEN
		RAISE NOTICE 'Compte existe pas';
		RETURN;
	END IF;
	RAISE NOTICE 'Solde du compte % : % DA et type du compte %', id_c, v_solde,v_type; 
END; 
$$;

```

### Exo1
```sql
CREATE OR REPLACE FUNCTION annoncer_operation() 
RETURNS TRIGGER AS $$ 
BEGIN 
	RAISE NOTICE 'Operation de % a tait raliser sur le compte : %',NEW. type_operation, NEW.id_compte; 
	RETURN NEW; 
END; 
$$ LANGUAGE plpgsql; 
CREATE TRIGGER trg_annoncer_depot AFTER INSERT ON operation FOR EACH ROW EXECUTE FUNCTION annoncer_operation();
```
```sql
CALL effectuer_depot(101,500);
```
![[Pasted image 20261024213403.png]]

- le trigger s'execute 2 fois
### Exo2
```sql
CREATE OR REPLACE FUNCTION historiser_solde() 
RETURNS TRIGGER AS $$ 
BEGIN 
	INSERT INTO historique_solde (id_compte, ancien_solde, nouveau_solde) VALUES (NEW.id_compte,OLD.solde,NEW.solde);
	RETURN NEW; 
END; 
$$ LANGUAGE plpgsql; 
CREATE TRIGGER trg_historique_solde AFTER UPDATE OF solde ON compte FOR EACH ROW EXECUTE FUNCTION historiser_solde();
```
```sql
CALL effectuer_depot(103,500);
CALL effectuer_depot(103,1000);
SELECT * FROM historique_solde;
```
### Exo3
```sql
CREATE OR REPLACE FUNCTION control_inactif() 
RETURNS TRIGGER AS $$ 
BEGIN 
	if not NEW.actif THEN
		RAISE EXCEPTION 'COMPTE INACTIF';
	END IF;
	return NEW;
END; 
$$ LANGUAGE plpgsql; 
CREATE TRIGGER trg_control_inactif BEFORE UPDATE ON compte FOR EACH ROW EXECUTE FUNCTION control_inactif();
```
```sql
UPDATE compte SET solde = solde - 1000 WHERE id_compte = 108;
UPDATE compte SET solde = solde - 1000 WHERE id_compte = 101; 
```
### Exo4
```sql
CALL effectuer_depot(101,1000);
```
- les 3 triggers sont utilisé
```sql
CALL effectuer_virement(101,104,-2000);
```
- Aucun historique est conservé car l'appel UPDATE compte n'est jamais atteint