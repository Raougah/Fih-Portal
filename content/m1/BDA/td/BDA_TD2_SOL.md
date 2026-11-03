> We will use Oracle 10g syntax !
## Create and Insert into the database

```sql
-- ============ CREATE ============
CREATE TABLE Service (
  id_service  NUMBER       PRIMARY KEY,
  nom_service VARCHAR2(50) NOT NULL
);

CREATE TABLE Medecin (
  id_med     NUMBER      PRIMARY KEY,
  nom        VARCHAR2(50) NOT NULL,
  salaire    NUMBER,
  id_service NUMBER,
  id_chef    NUMBER,
  CONSTRAINT fk_med_service FOREIGN KEY (id_service)
    REFERENCES Service(id_service)
);

CREATE TABLE Consultation (
  id_cons VARCHAR2(10)  PRIMARY KEY,
  motif   VARCHAR2(100) NOT NULL,
  tarif   NUMBER,
  id_med  NUMBER,
  CONSTRAINT fk_med_con FOREIGN KEY (id_med)
    REFERENCES Medecin(id_med)
);

-- ============ INSERT SERVICE ============
INSERT INTO Service (id_service, nom_service) VALUES (10, 'Cardiologie');
INSERT INTO Service (id_service, nom_service) VALUES (20, 'Pédiatrie');
INSERT INTO Service (id_service, nom_service) VALUES (30, 'Radiologie');

-- ============ INSERT MEDECIN ============
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (1, 'Benali',   9000,  10,   NULL);
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (2, 'Haddad',   6000,  10,   1);
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (3, 'Kaci',     7500,  10,   1);
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (4, 'Mansouri', 10000, 20,   NULL);
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (5, 'Saïdi',    5000,  20,   4);
INSERT INTO Medecin (id_med, nom, salaire, id_service, id_chef) VALUES (6, 'Ziani',    6400,  NULL, NULL);

-- ============ INSERT CONSULTATION ============
INSERT INTO Consultation (id_cons, motif, tarif, id_med) VALUES ('C1', 'Bilan cardiaque', 3000, 3);
INSERT INTO Consultation (id_cons, motif, tarif, id_med) VALUES ('C2', 'Vaccination',     1500, 4);
INSERT INTO Consultation (id_cons, motif, tarif, id_med) VALUES ('C3', 'Échographie',     4000, 3);

COMMIT;
```

## Queries (exercies)

```sql
-- EX01 Q01
SELECT nom, nom_service
FROM Medecin m
INNER JOIN Service s
ON s.id_service = m.id_service;

-- EX01 Q02
SELECT nom, nom_service
FROM Medecin m
LEFT JOIN Service s
ON s.id_service = m.id_service;

-- EX01 Q03
SELECT m.nom AS Medecin, c.nom AS Chef
FROM Medecin m
LEFT JOIN Medecin c
ON m.id_chef = c.id_med;

-- EX02 Q01
SELECT id_med, nom, salaire
FROM Medecin
WHERE salaire > (SELECT AVG(salaire) FROM Medecin);

-- EX02 Q02
SELECT DISTINCT m.id_med, m.nom
FROM Medecin m
INNER JOIN Consultation c
ON m.id_med = c.id_med;

-- Another method with EXISTS:
SELECT DISTINCT m.id_med, m.nom
FROM Medecin m
WHERE EXISTS (SELECT 1 FROM Consultation c WHERE c.id_med = m.id_med);


-- EX03 Q01
SELECT s.id_service, nom_service, COUNT(m.id_med) AS nbr_medecin, AVG(m.salaire) AS moy_salaire 
FROM Service s
LEFT JOIN Medecin m
ON m.id_service = s.id_service
GROUP BY s.id_service, nom_service;

-- EX03 Q02
SELECT s.id_service, nom_service, COUNT(m.id_med) AS nbr_medecins, AVG(m.salaire) AS moy_salaires 
FROM Service s
LEFT JOIN Medecin m
ON m.id_service = s.id_service
GROUP BY s.id_service, nom_service
HAVING COUNT(m.id_med) > 2; --  فقط نضيف هافينق

-- EX03 Q03
SELECT m.id_service, nom_service, nom, salaire,
RANK() OVER(
	PARTITION BY m.id_service
	ORDER BY salaire DESC
) AS s7abdraham_kima_abdou
FROM Medecin m
JOIN Service s
ON s.id_service = m.id_service;

-- EX04 Q01
CREATE OR REPLACE VIEW v_med_service AS
SELECT nom, nom_service
FROM Medecin m
LEFT JOIN Service s
ON m.id_service = s.id_service;

SELECT * FROM v_med_service;

-- EX04 Q02
CREATE OR REPLACE FUNCTION prime (p_salaire IN NUMBER)
RETURN NUMBER
IS
	BEGIN
		IF p_salaire >= 8000 THEN
			RETURN p_salaire * 0.05;
		ELSE
			RETURN p_salaire * 0.1;
		END IF;
	END;
/

SELECT nom, salaire, prime(salaire) AS montant_prime
FROM Medecin;

-- EX04 Q03
CREATE PROCEDURE augmenter(p_id IN NUMBER, p_montant IN NUMBER)
IS
	BEGIN
		UPDATE Medecin
			SET salaire = salaire + p_montant
			WHERE id_med = p_id
	END;
/

-- call it:
EXEC augmenter(5, 1000); -- salaire de said = 6000
-- OR
BEGIN
    augmenter(5, 1000);
END;
/

-- EX05 Q01
CREATE TRIGGER trg_check_salaire
BEFORE INSERT OR UPDATE OF salaire 
ON Medecin
FOR EACH ROW
BEGIN
	IF :NEW.salaire IS NOT NULL AND :NEW.salaire < 4000 THEN
		RAISE_APPLICATION_ERROR(-20001, 'Salaire invalid : minimum 4000');
	END IF;
END;
/

-- EXO06 Q01
/*
1. Médecin introuvable
2. Salaire: 9000
*/

-- EXO06 Q02
/*
Benali: 10000
Hadad: 6000 (Because Rollback 3awed wala lil check_point)
*/

-- EXO06 Q03
/*
- In postgres: refuse all transaction 
- In oracle: Accept first query, reject the second
*/

-- EXO06 Q04
BEGIN
    UPDATE Medecin
    SET salaire = salaire + 500
    WHERE id_med = 9;

    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Médecin introuvable');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Salaire augmenté');
    END IF;
END;
/
```