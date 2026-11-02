## 03_exemples_TP2_PLSQL_TRIGGERS_EL_SAHA.sql
- [[BDA_03_exemples_TP2_PLSQL_TRIGGERS_EL_SAHA_ORACLE.sql|script]]
- [[BDA_03_exemples_TP2_PLSQL_TRIGGERS_EL_SAHA_ORACLE|script md file]]

## 04_travail_TP2_PLSQL_TRIGGERS_EL_SAHA.sql
- [[BDA_04_travail_TP2_PLSQL_TRIGGERS_EL_SAHA_ORACLE.sql|script]]
- [[BDA_04_travail_TP2_PLSQL_TRIGGERS_EL_SAHA_ORACLE|script md file]]

## Solution
- [[BDA_TP_2_SOL|script md file]]

## Question de TP2

### 0️⃣ Contrainte vs Procédure vs Trigger

| Critère               | **Contrainte (Constraint)**                     | **Procédure / Fonction**                | **Trigger**                                             |
| --------------------- | ----------------------------------------------- | --------------------------------------- | ------------------------------------------------------- |
| **C'est quoi ?**      | Règle déclarative (CHECK, UNIQUE, FK, NOT NULL) | Bloc PL/SQL nommé, appelé explicitement | Bloc PL/SQL qui se déclenche **automatiquement**        |
| **Quand s'exécute ?** | À chaque INSERT/UPDATE/DELETE                   | Quand on l'appelle (CALL, EXEC, SELECT) | Automatiquement sur un événement (INSERT/UPDATE/DELETE) |
| **Performance**       | ⭐⭐⭐ Excellente (optimisée par Oracle)           | ⭐⭐ Bonne                                | ⭐ Ralentit les opérations                               |
| **Maintenance**       | ⭐⭐⭐ Facile à lire                               | ⭐⭐ Moyenne                              | ⭐ Difficile (code caché)                                |
| **Visibilité**        | Visible dans `USER_CONSTRAINTS`                 | Visible dans `USER_OBJECTS`             | Visible dans `USER_TRIGGERS`                            |
> **Toujours préférer la solution la plus simple : Contrainte > Procédure > Trigger**

### 1️⃣ Curseur implicite vs explicite

### **Curseur implicite**
- **C'est quoi ?** Oracle crée automatiquement un curseur pour chaque instruction SQL (`SELECT`, `INSERT`, `UPDATE`, `DELETE`)
- **Attributs disponibles :** `SQL%FOUND`, `SQL%NOTFOUND`, `SQL%ROWCOUNT`, `SQL%ISOPEN`
- **Exemple du TP :**
```sql
UPDATE rendez_vous SET statut = 'CONFIRME' WHERE statut = 'PLANIFIE';
v_nb := SQL%ROWCOUNT;  -- Oracle compte automatiquement les lignes modifiées
```
- **Avantage :** Simple, pas de code supplémentaire
- **Quand l'utiliser ?** Pour des requêtes qui retournent **0 ou 1 ligne** (`SELECT ... INTO`)

### **Curseur explicite**
- **C'est quoi ?** Le programmeur déclare, ouvre, lit et ferme manuellement le curseur
- **Étapes obligatoires :** `DECLARE` → `OPEN` → `FETCH` → `CLOSE`
- **Exemple du TP (Exercice 8) :**
```sql
DECLARE
    CURSOR c_stock IS SELECT id_medicament, stock FROM medicament WHERE stock < seuil_alerte;
    v_id medicament.id_medicament%TYPE;
BEGIN
    OPEN c_stock;
    LOOP
        FETCH c_stock INTO v_id;
        EXIT WHEN c_stock%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Medicament : ' || v_id);
    END LOOP;
    CLOSE c_stock;
END;
```
- **Avantage :** Contrôle total (vérifier `%ISOPEN`, traiter ligne par ligne)
- **Quand l'utiliser ?** Pour traiter **plusieurs lignes** avec une logique complexe

### **Cas particulier : Boucle FOR implicite**
```sql
FOR r IN (SELECT id_patient, nom FROM patient) LOOP
    DBMS_OUTPUT.PUT_LINE(r.nom);
END LOOP;
```
Oracle gère automatiquement `OPEN`, `FETCH` et `CLOSE`. C'est le **meilleur compromis**.

---

## 2️⃣ Procédure vs Fonction

### **Fonction**
- **Retourne une valeur** avec `RETURN`
- **Utilisable dans un `SELECT` SQL**
- **Pas d'effets de bord** (idéalement pas d'`INSERT`/`UPDATE`/`DELETE`)
- **Exemple du TP (Exercice 10) :**
```sql
CREATE OR REPLACE FUNCTION F_RESTE_FACTURE(p_id_facture IN facture.id_facture%TYPE) 
RETURN NUMBER IS
    v_total facture.montant_total%TYPE;
    v_remise facture.remise%TYPE;
    v_paye NUMBER;
BEGIN
    SELECT montant_total, remise INTO v_total, v_remise FROM facture WHERE id_facture = p_id_facture;
    SELECT NVL(SUM(montant), 0) INTO v_paye FROM paiement WHERE id_facture = p_id_facture;
    RETURN v_total * (1 - v_remise / 100) - v_paye;
END;
/

-- Utilisation dans un SELECT :
SELECT id_facture, F_RESTE_FACTURE(id_facture) AS reste FROM facture;
```
- **Quand l'utiliser ?** Pour des **calculs réutilisables** (factoriel, reste à payer, âge, etc.)

### **Procédure**
- **Ne retourne pas de valeur directement** (utilise des paramètres `OUT`)
- **S'appelle comme une instruction** (`EXEC`, `CALL`, ou dans un bloc `BEGIN ... END`)
- **Peut modifier la base** (`INSERT`, `UPDATE`, `DELETE`)
- **Exemple du TP (Exercice 11) :**
```sql
CREATE OR REPLACE PROCEDURE P_AJOUTER_PATIENT(
    p_nom IN personne.nom%TYPE,
    p_prenom IN personne.prenom%TYPE,
    p_id_patient OUT patient.id_patient%TYPE
) IS
BEGIN
    -- Vérifications, INSERT, etc.
    SELECT seq_patient.NEXTVAL INTO p_id_patient FROM dual;
    INSERT INTO patient (id_patient, ...) VALUES (p_id_patient, ...);
END;
/

-- Appel :
DECLARE v_id NUMBER;
BEGIN
    P_AJOUTER_PATIENT('Dupont', 'Jean', v_id);
    DBMS_OUTPUT.PUT_LINE('Patient créé : ' || v_id);
END;
```
- **Quand l'utiliser ?** Pour des **actions complexes** (ajouter un patient, modifier plusieurs tables, etc.)

---

## 3️⃣ Trigger BEFORE vs AFTER

### **Trigger BEFORE**
- **S'exécute AVANT l'écriture en base**
- **Peut modifier les valeurs** via `:NEW` (`:NEW.nom := UPPER(:NEW.nom)`)
- **Peut refuser l'opération** avec `RAISE_APPLICATION_ERROR`
- **Exemple du TP (Exercice 13) :**
```sql
CREATE OR REPLACE TRIGGER TRG_PATIENT_BIU
BEFORE INSERT OR UPDATE ON patient
FOR EACH ROW
BEGIN
    -- Normaliser les données avant écriture
    UPDATE personne
    SET nom = UPPER(TRIM(nom)),
        prenom = INITCAP(LOWER(TRIM(prenom))),
        email = LOWER(TRIM(email))
    WHERE id_personne = :NEW.id_personne;
END;
```
- **Exemple du TP (Exercice 14) :**
```sql
CREATE OR REPLACE TRIGGER TRG_RDV_BIU
BEFORE INSERT OR UPDATE ON rendez_vous
FOR EACH ROW
BEGIN
    -- Refuser une date passée
    IF :NEW.date_rdv < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20201, 'Date de rendez-vous passée interdite');
    END IF;
END;
```
- **Quand l'utiliser ?**
  - Valider des règles métier (date passée, stock insuffisant)
  - Normaliser des données (MAJUSCULES, trim)
  - Calculer des valeurs par défaut

### **Trigger AFTER**
- **S'exécute APRÈS l'écriture en base**
- **Ne peut PAS modifier `:NEW`** (les données sont déjà écrites)
- **Idéal pour réagir** (journalisation, mise à jour d'autres tables)
- **Exemple du TP (Exercice 16) :**
```sql
CREATE OR REPLACE TRIGGER TRG_CONSULT_AI
AFTER INSERT ON consultation
FOR EACH ROW
BEGIN
    -- Passer le RDV à REALISE après insertion d'une consultation
    IF :NEW.id_rdv IS NOT NULL THEN
        UPDATE rendez_vous SET statut = 'REALISE'
        WHERE id_rdv = :NEW.id_rdv AND statut IN ('PLANIFIE', 'CONFIRME');
    END IF;
END;
```
- **Exemple du TP (Exercice 19) :**
```sql
CREATE OR REPLACE TRIGGER TRG_FACTURE_AUDIT
AFTER INSERT OR UPDATE OR DELETE ON facture
FOR EACH ROW
BEGIN
    -- Journaliser toutes les modifications
    INSERT INTO journal_operation (...)
    VALUES (seq_journal.NEXTVAL, 'UPDATE', 'FACTURE', ...);
END;
```
- **Quand l'utiliser ?**
  - Journalisation d'audit (écrire dans une table de log)
  - Mettre à jour des totaux dans d'autres tables
  - Envoyer des notifications

---

## 4️⃣ Erreur ORA-04091 (Table mutante)

### **C'est quoi ?**
- Erreur qui se produit quand un **trigger niveau ligne** tente de **lire ou modifier la table** qui est en cours de modification par la requête SQL déclenchante
- Oracle bloque pour éviter des incohérences (la table est "instable" pendant la modification)

### **Exemple du TP (Exercice 25a) :**
```sql
-- Trigger qui lit la table PAIEMENT (celle qu'il modifie)
CREATE OR REPLACE TRIGGER trg_paiement_mutant
AFTER INSERT ON paiement
FOR EACH ROW
DECLARE
    v_somme NUMBER;
BEGIN
    SELECT SUM(montant) INTO v_somme 
    FROM paiement  -- ❌ ORA-04091 : table mutante !
    WHERE id_facture = :NEW.id_facture;
END;
/

-- Quand on insère un paiement :
INSERT INTO paiement (...) VALUES (...);
-- → ORA-04091: la table PAIEMENT est en cours de modification
```

### **Solution : Package + 2 triggers**
1. **Package** : mémorise les identifiants des factures concernées
2. **Trigger ligne (AFTER ROW)** : ajoute l'ID au package (pas de lecture de PAIEMENT)
3. **Trigger instruction (AFTER STATEMENT)** : traite toutes les factures mémorisées (lecture de PAIEMENT autorisée)

```sql
-- 1. Package
CREATE OR REPLACE PACKAGE pkg_paiement_audit IS
    TYPE t_factures IS TABLE OF facture.id_facture%TYPE INDEX BY BINARY_INTEGER;
    g_factures t_factures;
    g_idx NUMBER := 0;
    PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE);
    PROCEDURE traiter_factures;
END;
/

-- 2. Trigger ligne (mémorise seulement)
CREATE OR REPLACE TRIGGER trg_paiement_ligne
AFTER INSERT ON paiement
FOR EACH ROW
BEGIN
    pkg_paiement_audit.ajouter_facture(:NEW.id_facture);  -- ✅ Pas de lecture de PAIEMENT
END;
/

-- 3. Trigger instruction (traite après)
CREATE OR REPLACE TRIGGER trg_paiement_instruction
AFTER INSERT ON paiement
BEGIN
    pkg_paiement_audit.traiter_factures;  -- ✅ Lecture de PAIEMENT autorisée
END;
/
```

### **Pourquoi ça marche ?**
- **Trigger ligne** : s'exécute pendant la modification (table mutante) → ne lit PAS la table
- **Trigger instruction** : s'exécute **après** la modification complète → peut lire la table

---

## 5️⃣ Pourquoi ROLLBACK à la fin ?

### **Raison principale**
- **Ne pas laisser de données de test** dans la base de production
- La base doit rester dans son **état initial** pour les autres étudiants ou pour la prochaine session

### **Exemple du TP :**
```sql
-- Test d'insertion d'un patient
DECLARE v_id NUMBER;
BEGIN
    P_AJOUTER_PATIENT('Dupont', 'Jean', '2000-01-01', 'M', 'jean@test.dz', 'SS-TEST', v_id);
    DBMS_OUTPUT.PUT_LINE('Patient créé : ' || v_id);
    ROLLBACK;  -- ✅ Annule l'insertion, la base revient à l'état initial
END;
```

### **Risques sans ROLLBACK**
- Données de test mélangées avec les données réelles
- Problèmes de cohérence (factures sans paiements, patients sans rendez-vous)
- Erreurs dans les exercices suivants (IDs dupliqués, séquences avancées)

### **Exception : quand faire COMMIT ?**
- Jamais dans un exercice de TP !
- En production : l'application décide quand valider (après validation utilisateur, fin de processus métier, etc.)

---

## 6️⃣ Pourquoi pas de COMMIT dans une procédure ?

### **Principe fondamental**
- **C'est l'appelant (l'utilisateur ou l'application) qui décide** de valider ou annuler la transaction
- La procédure doit être **agnostique** : elle ne sait pas si elle fait partie d'un processus plus large

### **Exemple concret :**
```sql
-- Procédure qui ajoute un patient ET crée un rendez-vous
CREATE OR REPLACE PROCEDURE P_INSCRIPTION_COMPLETE(
    p_nom VARCHAR2,
    p_date_rdv DATE
) IS
    v_id_patient NUMBER;
BEGIN
    P_AJOUTER_PATIENT(p_nom, ..., v_id_patient);  -- Pas de COMMIT ici
    INSERT INTO rendez_vous (id_patient, date_rdv, ...) VALUES (v_id_patient, p_date_rdv, ...);
    -- Pas de COMMIT ici non plus
END;
/

-- Appel :
BEGIN
    P_INSCRIPTION_COMPLETE('Dupont', DATE '2026-12-01');
    COMMIT;  -- ✅ L'appelant valide TOUT (patient + rendez-vous)
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;  -- ✅ L'appelant annule TOUT en cas d'erreur
END;
```

### **Risques avec COMMIT dans une procédure**
- **Transaction partielle** : si la procédure est appelée dans un processus plus large, on ne peut pas annuler en cas d'erreur
- **Perte de contrôle** : l'appelant ne peut pas décider de valider ou annuler
- **Incohérence** : si plusieurs procédures sont appelées, certaines valident, d'autres non
