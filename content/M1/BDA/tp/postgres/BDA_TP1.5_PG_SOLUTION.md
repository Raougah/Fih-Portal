# Partie 1
### exo1
```sql
CREATE OR REPLACE PROCEDURE effectuer_retrait(p_compte INTEGER, p_montant NUMERIC)
LANGUAGE plpgsql AS 
$$ 
DECLARE
	s_actif BOOLEAN;
	s_solde NUMERIC;
BEGIN 
	IF p_montant < 0 THEN
		RAISE NOTICE 'MONTANT INSUFFISANT';
		RETURN;
	END IF;
	SELECT actif, solde INTO s_actif, s_solde FROM compte WHERE id_compte=p_compte;

	IF not found THEN
		RAISE NOTICE 'Compte inexistant';
		RETURN;
	END IF;
	
	if not s_actif THEN
		RAISE NOTICE 'Compte inactif';
		RETURN;
	END IF;
	
	if p_montant> s_solde THEN
		RAISE NOTICE 'Fond insufisant';
		RETURN;
	END IF;
	
	UPDATE compte SET solde = solde - p_montant WHERE id_compte = p_compte;
	
	INSERT INTO operation (id_compte, type_operation, montant) 
	VALUES (p_compte,'retrait',p_montant);
	
END; 
$$; 

BEGIN;
CALL effectuer_retrait(106,2000);
SELECT * FROM operation;
SELECT * FROM compte WHERE id_compte=106;
ROLLBACK;

BEGIN;
CALL effectuer_retrait(106,10000);
SELECT * FROM operation;
SELECT * FROM compte WHERE id_compte=106;
ROLLBACK;
```
### exo2
```sql
CREATE OR REPLACE PROCEDURE appliquer_prime_epargne(p_taux NUMERIC)
LANGUAGE plpgsql AS 
$$ 
DECLARE
	nb_compte INTEGER;
BEGIN 
	IF p_taux <= 0 OR p_taux > 5 THEN
		RAISE NOTICE 'Erreur taux';
		RETURN;
	END IF;
	
	UPDATE compte
    SET solde = solde + (solde * p_taux / 100)
    WHERE type_compte = 'epargne' AND actif;
	
	GET DIAGNOSTICS nb_compte = ROW_COUNT;

    RAISE NOTICE '% compte depargne mis a jour', nb_compte;
	
END; 
$$; 

BEGIN;
CALL appliquer_prime_epargne(2);
SELECT * FROM compte WHERE type_compte = 'epargne' ORDER BY id_compte;
ROLLBACK;

CALL appliquer_prime_epargne(0);  
CALL appliquer_prime_epargne(-1);   
CALL appliquer_prime_epargne(6);  
```