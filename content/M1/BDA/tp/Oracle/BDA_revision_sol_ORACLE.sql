-- TP1 - Revision SQL : base EL_SAHA
-- Oracle 10g

SET ECHO ON
SET FEEDBACK ON
SET VERIFY OFF
SET PAGESIZE 100
SET LINESIZE 220
SET LONG 10000
SET LONGCHUNKSIZE 10000
SET SERVEROUTPUT ON
SET DEFINE OFF
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

SPOOL revision_sol.txt

-- Ex 1 : cliniques triees par ville puis nom
PROMPT --- Exercice 1
SELECT id_clinique, nom_clinique, ville, adresse, telephone, type_clinique
FROM clinique
ORDER BY ville, nom_clinique;

-- Ex 2 : identite et ville des patients
PROMPT --- Exercice 2
SELECT pa.id_patient, pe.nom, pe.prenom, pe.ville
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
ORDER BY pe.nom, pe.prenom;

-- Ex 3 : medicaments au seuil d'alerte ou en dessous
PROMPT --- Exercice 3
SELECT id_medicament, nom_medicament, stock, seuil_alerte
FROM medicament
WHERE stock <= seuil_alerte
ORDER BY stock, nom_medicament;

-- Ex 4 : rdv planifies ou confirmes (annee 2026)
PROMPT --- Exercice 4
SELECT id_rdv, id_patient, id_medecin, date_rdv, heure_rdv, statut
FROM rendez_vous
WHERE statut IN ('PLANIFIE', 'CONFIRME')
  AND date_rdv >= DATE '2026-01-01'
  AND date_rdv <  DATE '2027-01-01'
ORDER BY date_rdv, heure_rdv;

-- Ex 5 : noms contenant "ben"
PROMPT --- Exercice 5
SELECT id_personne, nom, prenom, ville, telephone
FROM personne
WHERE LOWER(nom) LIKE '%ben%'
ORDER BY nom, prenom;

-- Ex 6 : consultations d'urgence > 3000 DA
PROMPT --- Exercice 6
SELECT id_consultation, date_consultation, motif, diagnostic,
       type_consultation, montant_honoraire
FROM consultation
WHERE type_consultation = 'URGENCE'
  AND montant_honoraire > 3000
ORDER BY montant_honoraire DESC;

-- Ex 7 : age des patients
PROMPT --- Exercice 7
SELECT pa.id_patient, pe.nom, pe.prenom, pe.date_naissance,
       FLOOR(MONTHS_BETWEEN(SYSDATE, pe.date_naissance) / 12) AS age_approximatif
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
ORDER BY age_approximatif DESC, pe.nom;

-- Ex 8 : patients sans email ou sans num securite sociale
PROMPT --- Exercice 8
SELECT pa.id_patient, pe.nom, pe.prenom, pe.email, pa.num_securite_soc
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
WHERE pe.email IS NULL
   OR pa.num_securite_soc IS NULL
ORDER BY pe.nom, pe.prenom;

-- Ex 9 : etat du stock
PROMPT --- Exercice 9
SELECT id_medicament, nom_medicament, stock, seuil_alerte,
       CASE
         WHEN stock <= seuil_alerte THEN 'STOCK CRITIQUE'
         WHEN stock <= seuil_alerte * 2 THEN 'STOCK FAIBLE'
         ELSE 'STOCK NORMAL'
       END AS etat_stock
FROM medicament
ORDER BY stock, nom_medicament;

-- Ex 10 : medecins avec specialite et clinique
PROMPT --- Exercice 10
SELECT m.id_medecin, pe.nom, pe.prenom, m.specialite, m.grade,
       c.nom_clinique, c.ville
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne
JOIN clinique c ON c.id_clinique = m.id_clinique
ORDER BY c.nom_clinique, pe.nom, pe.prenom;

-- Ex 11 : services avec clinique et medecin chef
PROMPT --- Exercice 11
SELECT s.id_service, s.nom_service, c.nom_clinique,
       p.nom AS nom_chef, p.prenom AS prenom_chef
FROM service s
JOIN clinique c ON c.id_clinique = s.id_clinique
LEFT JOIN medecin mc ON mc.id_medecin = s.id_medecin_chef
LEFT JOIN personne p ON p.id_personne = mc.id_personne
ORDER BY c.nom_clinique, s.nom_service;

-- Ex 12 : rendez-vous detailles
PROMPT --- Exercice 12
SELECT r.id_rdv,
       pp.nom || ' ' || pp.prenom AS patient,
       pm.nom || ' ' || pm.prenom AS medecin,
       s.nom_service, r.date_rdv, r.heure_rdv, r.statut
FROM rendez_vous r
JOIN patient pa ON pa.id_patient = r.id_patient
JOIN personne pp ON pp.id_personne = pa.id_personne
JOIN medecin m ON m.id_medecin = r.id_medecin
JOIN personne pm ON pm.id_personne = m.id_personne
JOIN service s ON s.id_service = r.id_service
ORDER BY r.date_rdv, r.heure_rdv;

-- Ex 13 : consultations avec patient et medecin
PROMPT --- Exercice 13
SELECT c.id_consultation, c.date_consultation, c.heure_consultation,
       pp.nom || ' ' || pp.prenom AS patient,
       pm.nom || ' ' || pm.prenom AS medecin,
       c.diagnostic, c.type_consultation, c.montant_honoraire
FROM consultation c
JOIN patient pa ON pa.id_patient = c.id_patient
JOIN personne pp ON pp.id_personne = pa.id_personne
JOIN medecin m ON m.id_medecin = c.id_medecin
JOIN personne pm ON pm.id_personne = m.id_personne
ORDER BY c.date_consultation DESC, c.heure_consultation;

-- Ex 14 : contenu des ordonnances
PROMPT --- Exercice 14
SELECT o.id_ordonnance, o.date_ordonnance,
       pp.nom || ' ' || pp.prenom AS patient,
       med.nom_medicament, pr.posologie, pr.quantite, pr.duree_jours
FROM ordonnance o
JOIN consultation c ON c.id_consultation = o.id_consultation
JOIN patient pa ON pa.id_patient = c.id_patient
JOIN personne pp ON pp.id_personne = pa.id_personne
JOIN prescription pr ON pr.id_ordonnance = o.id_ordonnance
JOIN medicament med ON med.id_medicament = pr.id_medicament
ORDER BY o.date_ordonnance DESC, o.id_ordonnance, med.nom_medicament;

-- Ex 15 : actes realises et cout par ligne
PROMPT --- Exercice 15
SELECT ac.id_consultation, a.id_acte, a.nom_acte, ac.quantite,
       a.cout_acte, ac.quantite * a.cout_acte AS cout_ligne,
       ac.resultat
FROM acte_consultation ac
JOIN acte a ON a.id_acte = ac.id_acte
ORDER BY ac.id_consultation, a.nom_acte;

-- Ex 16 : hospitalisations
PROMPT --- Exercice 16
SELECT h.id_hospitalisation,
       pp.nom || ' ' || pp.prenom AS patient,
       s.nom_service, cl.nom_clinique,
       ch.numero_chambre, h.date_entree, h.date_sortie, h.statut
FROM hospitalisation h
JOIN patient pa ON pa.id_patient = h.id_patient
JOIN personne pp ON pp.id_personne = pa.id_personne
JOIN service s ON s.id_service = h.id_service
JOIN clinique cl ON cl.id_clinique = s.id_clinique
JOIN chambre ch ON ch.id_chambre = h.id_chambre
               AND ch.id_service = h.id_service
ORDER BY h.date_entree DESC;

-- Ex 17 : tous les medecins, meme sans consultation
PROMPT --- Exercice 17
SELECT m.id_medecin, pe.nom, pe.prenom, m.specialite,
       COUNT(c.id_consultation) AS nombre_consultations
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne
LEFT JOIN consultation c ON c.id_medecin = m.id_medecin
GROUP BY m.id_medecin, pe.nom, pe.prenom, m.specialite
ORDER BY nombre_consultations DESC, pe.nom;

-- Ex 18 : tous les patients, meme sans rdv
PROMPT --- Exercice 18
SELECT pa.id_patient, pe.nom, pe.prenom,
       COUNT(r.id_rdv) AS nombre_rendez_vous
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
LEFT JOIN rendez_vous r ON r.id_patient = pa.id_patient
GROUP BY pa.id_patient, pe.nom, pe.prenom
ORDER BY nombre_rendez_vous, pe.nom;

-- Ex 19 : analyses demandees
PROMPT --- Exercice 19
SELECT da.id_demande, da.date_demande, a.nom_analyse,
       da.statut, da.date_resultat, da.resultat, da.id_consultation
FROM demande_analyse da
JOIN analyse a ON a.id_analyse = da.id_analyse
ORDER BY da.date_demande DESC, da.id_demande;

-- Ex 20 : patients par ville
PROMPT --- Exercice 20
SELECT NVL(pe.ville, '(ville inconnue)') AS ville,
       COUNT(*) AS nombre_patients
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
GROUP BY NVL(pe.ville, '(ville inconnue)')
ORDER BY nombre_patients DESC, ville;

-- Ex 21 : medecins par clinique et specialite
PROMPT --- Exercice 21
SELECT cl.nom_clinique, m.specialite, COUNT(*) AS nombre_medecins
FROM medecin m
JOIN clinique cl ON cl.id_clinique = m.id_clinique
GROUP BY cl.nom_clinique, m.specialite
ORDER BY cl.nom_clinique, nombre_medecins DESC, m.specialite;

-- Ex 22 : rdv par statut
PROMPT --- Exercice 22
SELECT statut, COUNT(*) AS nombre_rendez_vous
FROM rendez_vous
GROUP BY statut
ORDER BY statut;

-- Ex 23 : consultations et honoraires moyens par medecin
PROMPT --- Exercice 23
SELECT m.id_medecin, pe.nom, pe.prenom,
       COUNT(c.id_consultation) AS nombre_consultations,
       ROUND(AVG(c.montant_honoraire), 2) AS honoraires_moyens
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne
LEFT JOIN consultation c ON c.id_medecin = m.id_medecin
GROUP BY m.id_medecin, pe.nom, pe.prenom
ORDER BY nombre_consultations DESC, pe.nom;

-- Ex 24 : medecins avec au moins 4 consultations
PROMPT --- Exercice 24
SELECT m.id_medecin, pe.nom, pe.prenom, COUNT(*) AS nombre_consultations
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne
JOIN consultation c ON c.id_medecin = m.id_medecin
GROUP BY m.id_medecin, pe.nom, pe.prenom
HAVING COUNT(*) >= 4
ORDER BY nombre_consultations DESC;

-- Ex 25 : chiffre d'affaires par clinique
PROMPT --- Exercice 25
SELECT cl.id_clinique, cl.nom_clinique,
       NVL(SUM(f.montant_total), 0) AS chiffre_affaires_facture
FROM clinique cl
LEFT JOIN service s ON s.id_clinique = cl.id_clinique
LEFT JOIN consultation c ON c.id_service = s.id_service
LEFT JOIN facture f ON f.id_consultation = c.id_consultation
GROUP BY cl.id_clinique, cl.nom_clinique
ORDER BY chiffre_affaires_facture DESC;

-- Ex 26 : duree moyenne par type de consultation
PROMPT --- Exercice 26
SELECT type_consultation, COUNT(*) AS nombre_consultations,
       ROUND(AVG(duree_minutes), 2) AS duree_moyenne_minutes
FROM consultation
GROUP BY type_consultation
ORDER BY type_consultation;

-- Ex 27 : top 5 medicaments (10g : sous-requete + ROWNUM)
PROMPT --- Exercice 27
SELECT id_medicament, nom_medicament, nombre_prescriptions
FROM (
  SELECT m.id_medicament, m.nom_medicament,
         SUM(p.quantite) AS nombre_prescriptions
  FROM medicament m
  JOIN prescription p ON p.id_medicament = m.id_medicament
  GROUP BY m.id_medicament, m.nom_medicament
  ORDER BY SUM(p.quantite) DESC, m.nom_medicament
)
WHERE ROWNUM <= 5;

-- Ex 28 : total paye et reste a payer par facture
PROMPT --- Exercice 28
SELECT f.id_facture, f.id_patient, f.date_facture, f.montant_total,
       NVL(SUM(p.montant), 0) AS total_paye,
       f.montant_total - NVL(SUM(p.montant), 0) AS reste_a_payer,
       f.statut
FROM facture f
LEFT JOIN paiement p ON p.id_facture = f.id_facture
GROUP BY f.id_facture, f.id_patient, f.date_facture, f.montant_total, f.statut
ORDER BY f.date_facture DESC, f.id_facture;

-- Ex 29 : taux d'occupation par service (depuis la premiere entree)
PROMPT --- Exercice 29
SELECT s.id_service, s.nom_service, s.capacite_lits,
       NVL(SUM(NVL(h.date_sortie, TRUNC(SYSDATE)) - h.date_entree), 0)
         AS jours_lits_observes,
       ROUND(
         100 * NVL(SUM(NVL(h.date_sortie, TRUNC(SYSDATE)) - h.date_entree), 0)
         / NULLIF(s.capacite_lits *
             GREATEST(1, TRUNC(SYSDATE) -
               NVL((SELECT MIN(date_entree) FROM hospitalisation), TRUNC(SYSDATE))), 0),
         2) AS taux_occupation_pct
FROM service s
LEFT JOIN hospitalisation h ON h.id_service = s.id_service
GROUP BY s.id_service, s.nom_service, s.capacite_lits
ORDER BY taux_occupation_pct DESC NULLS LAST;

-- Ex 30 : patients avec au moins une consultation
PROMPT --- Exercice 30
SELECT pa.id_patient, pe.nom, pe.prenom
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
WHERE EXISTS (SELECT 1 FROM consultation c WHERE c.id_patient = pa.id_patient)
ORDER BY pe.nom, pe.prenom;

-- Ex 31 : patients jamais hospitalises
PROMPT --- Exercice 31
SELECT pa.id_patient, pe.nom, pe.prenom
FROM patient pa
JOIN personne pe ON pe.id_personne = pa.id_personne
WHERE NOT EXISTS (SELECT 1 FROM hospitalisation h WHERE h.id_patient = pa.id_patient)
ORDER BY pe.nom, pe.prenom;

-- Ex 32 : medecins avec salaire > moyenne
PROMPT --- Exercice 32
SELECT m.id_medecin, pe.nom, pe.prenom, m.specialite, m.salaire
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne
WHERE m.salaire > (SELECT AVG(salaire) FROM medecin)
ORDER BY m.salaire DESC;

-- Ex 33 : consultations au-dessus de la moyenne de leur type
PROMPT --- Exercice 33
SELECT c.id_consultation, c.type_consultation, c.montant_honoraire
FROM consultation c
WHERE c.montant_honoraire > (
  SELECT AVG(c2.montant_honoraire)
  FROM consultation c2
  WHERE c2.type_consultation = c.type_consultation
)
ORDER BY c.type_consultation, c.montant_honoraire DESC;

-- Ex 34 : medicaments dans plusieurs ordonnances
PROMPT --- Exercice 34
SELECT m.id_medicament, m.nom_medicament,
       COUNT(DISTINCT p.id_ordonnance) AS nombre_ordonnances
FROM medicament m
JOIN prescription p ON p.id_medicament = m.id_medicament
GROUP BY m.id_medicament, m.nom_medicament
HAVING COUNT(DISTINCT p.id_ordonnance) > 1
ORDER BY nombre_ordonnances DESC, m.nom_medicament;

-- Ex 35 : patients avec consultation ET hospitalisation
PROMPT --- Exercice 35
SELECT pa.id_patient
FROM patient pa
JOIN consultation c ON c.id_patient = pa.id_patient
INTERSECT
SELECT pa.id_patient
FROM patient pa
JOIN hospitalisation h ON h.id_patient = pa.id_patient
ORDER BY id_patient;

-- Ex 36 : patients avec consultation mais sans hospitalisation
PROMPT --- Exercice 36
SELECT DISTINCT c.id_patient
FROM consultation c
MINUS
SELECT DISTINCT h.id_patient
FROM hospitalisation h
ORDER BY id_patient;

-- Ex 37 : clinique(s) avec le plus de medecins
PROMPT --- Exercice 37
SELECT id_clinique, nom_clinique, nombre_medecins
FROM (
  SELECT cl.id_clinique, cl.nom_clinique, COUNT(m.id_medecin) AS nombre_medecins,
         DENSE_RANK() OVER (ORDER BY COUNT(m.id_medecin) DESC) AS rang
  FROM clinique cl
  LEFT JOIN medecin m ON m.id_clinique = cl.id_clinique
  GROUP BY cl.id_clinique, cl.nom_clinique
)
WHERE rang = 1
ORDER BY nom_clinique;

-- Ex 38 : inserer une personne puis un patient
-- (les variables servent aussi pour les exercices 39 a 45)
PROMPT --- Exercice 38
VARIABLE new_person_id NUMBER
VARIABLE new_patient_id NUMBER
VARIABLE new_rdv_id NUMBER

BEGIN
  SELECT seq_personne.NEXTVAL INTO :new_person_id FROM dual;
  INSERT INTO personne
    (id_personne, nom, prenom, date_naissance, sexe, adresse, ville, telephone, email)
  VALUES
    (:new_person_id, 'MekibesTest', 'BesghireTest', DATE '1995-01-01', 'M',
     'Adresse pedagogique', 'Oran', '0600000000',
     'revision.' || TO_CHAR(:new_person_id) || '@example.invalid');

  SELECT seq_patient.NEXTVAL INTO :new_patient_id FROM dual;
  INSERT INTO patient
    (id_patient, id_personne, num_securite_soc, groupe_sanguin,
     antecedents, allergies, personne_contact, tel_contact)
  VALUES
    (:new_patient_id, :new_person_id,
     'REV-' || TO_CHAR(:new_patient_id), 'O+', NULL, NULL,
     'Contact pedagogique', '0600000001');

  DBMS_OUTPUT.PUT_LINE('Personne de test ID=' || :new_person_id);
  DBMS_OUTPUT.PUT_LINE('Patient de test ID=' || :new_patient_id);
END;
/
SAVEPOINT apres_creation_patient;

-- Ex 39 : ajouter un rdv pour le patient de test
PROMPT --- Exercice 39
BEGIN
  SELECT seq_rdv.NEXTVAL INTO :new_rdv_id FROM dual;

  INSERT INTO rendez_vous
    (id_rdv, id_patient, id_medecin, id_service, date_rdv,
     heure_rdv, motif, statut)
  SELECT :new_rdv_id, :new_patient_id, m.id_medecin, s.id_service,
         TRUNC(SYSDATE) + 60, '23:59',
         'Rendez-vous de test TP1', 'PLANIFIE'
  FROM medecin m
  JOIN service s ON s.id_clinique = m.id_clinique
  WHERE m.id_medecin = (SELECT MIN(id_medecin) FROM medecin)
    AND s.id_service = (
      SELECT MIN(s2.id_service)
      FROM service s2
      WHERE s2.id_clinique = m.id_clinique
    )
    AND ROWNUM = 1;

  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Aucun medecin/service trouve pour le rdv de test.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Rendez-vous de test ID=' || :new_rdv_id);
END;
/
SAVEPOINT apres_creation_rdv;

-- Ex 40 : passer le rdv en CONFIRME
PROMPT --- Exercice 40
UPDATE rendez_vous
SET statut = 'CONFIRME'
WHERE id_rdv = :new_rdv_id;

SELECT id_rdv, id_patient, id_medecin, id_service, date_rdv, heure_rdv, statut
FROM rendez_vous
WHERE id_rdv = :new_rdv_id;

-- Ex 41 : savepoint, modification du stock, rollback partiel
PROMPT --- Exercice 41
SAVEPOINT avant_modification_stock;

UPDATE medicament
SET stock = stock + 1
WHERE id_medicament = (SELECT MIN(id_medicament) FROM medicament);

SELECT id_medicament, nom_medicament, stock
FROM medicament
WHERE id_medicament = (SELECT MIN(id_medicament) FROM medicament);

ROLLBACK TO avant_modification_stock;

PROMPT Stock restaure apres le rollback :
SELECT id_medicament, nom_medicament, stock
FROM medicament
WHERE id_medicament = (SELECT MIN(id_medicament) FROM medicament);

-- Ex 42 : supprimer le rdv de test et valider
PROMPT --- Exercice 42
DELETE FROM rendez_vous
WHERE id_rdv = :new_rdv_id;

COMMIT;

SELECT COUNT(*) AS rendez_vous_test_restants
FROM rendez_vous
WHERE id_rdv = :new_rdv_id;

-- Ex 43 : test de cle etrangere (patient inexistant)
PROMPT --- Exercice 43
DECLARE
  v_medecin medecin.id_medecin%TYPE;
  v_service service.id_service%TYPE;
BEGIN
  SELECT MIN(id_medecin) INTO v_medecin FROM medecin;
  SELECT MIN(id_service) INTO v_service FROM service;

  INSERT INTO rendez_vous
    (id_rdv, id_patient, id_medecin, id_service, date_rdv,
     heure_rdv, motif, statut)
  VALUES
    (seq_rdv.NEXTVAL, -999999, v_medecin, v_service,
     TRUNC(SYSDATE) + 90, '22:58',
     'Test volontaire de cle etrangere', 'PLANIFIE');

  DBMS_OUTPUT.PUT_LINE('Attention : insertion inattendue.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (patient inexistant) : ' || SQLERRM);
END;
/

-- Ex 44 : test de la contrainte sur la quantite negative
PROMPT --- Exercice 44
BEGIN
  INSERT INTO prescription
    (id_ordonnance, id_medicament, posologie, quantite)
  SELECT o.id_ordonnance, m.id_medicament, 'Test pedagogique', -1
  FROM ordonnance o
  CROSS JOIN medicament m
  WHERE NOT EXISTS (
    SELECT 1
    FROM prescription p
    WHERE p.id_ordonnance = o.id_ordonnance
      AND p.id_medicament = m.id_medicament
  )
  AND ROWNUM = 1;

  IF SQL%ROWCOUNT = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Aucune paire ordonnance/medicament disponible pour le test.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur attendue (quantite negative) : ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Contrainte : CK_PRESCRIPTION_QTE (QUANTITE > 0).');
END;
/

-- Ex 45 : difference entre DELETE, ROLLBACK et COMMIT
PROMPT --- Exercice 45
SAVEPOINT avant_demo_transaction;

DELETE FROM patient
WHERE id_patient = :new_patient_id;

PROMPT Patient supprime dans la transaction (pas encore valide).
ROLLBACK TO avant_demo_transaction;

SELECT id_patient, id_personne, num_securite_soc
FROM patient
WHERE id_patient = :new_patient_id;

PROMPT ROLLBACK annule les changements depuis le savepoint.
PROMPT COMMIT rend les changements permanents (cf. exercice 42).

-- Ex 46 : vue detaillee des consultations
PROMPT --- Exercice 46
CREATE OR REPLACE VIEW v_consultations_detail AS
SELECT c.id_consultation, c.date_consultation, c.heure_consultation,
       c.type_consultation, c.motif, c.diagnostic,
       c.montant_honoraire,
       pa.id_patient, pp.nom AS nom_patient, pp.prenom AS prenom_patient,
       m.id_medecin, pm.nom AS nom_medecin, pm.prenom AS prenom_medecin,
       m.specialite, s.id_service, s.nom_service,
       cl.id_clinique, cl.nom_clinique
FROM consultation c
JOIN patient pa ON pa.id_patient = c.id_patient
JOIN personne pp ON pp.id_personne = pa.id_personne
JOIN medecin m ON m.id_medecin = c.id_medecin
JOIN personne pm ON pm.id_personne = m.id_personne
JOIN service s ON s.id_service = c.id_service
JOIN clinique cl ON cl.id_clinique = s.id_clinique;

SELECT * FROM v_consultations_detail
ORDER BY date_consultation DESC, id_consultation;

-- Ex 47 : vue des medicaments en alerte
PROMPT --- Exercice 47
CREATE OR REPLACE VIEW v_stock_alerte AS
SELECT id_medicament, nom_medicament, famille, stock, seuil_alerte,
       prix_unitaire
FROM medicament
WHERE stock <= seuil_alerte;

SELECT * FROM v_stock_alerte
ORDER BY stock, nom_medicament;

-- Ex 48 : texte des vues
PROMPT --- Exercice 48
SELECT view_name, text
FROM user_views
WHERE view_name IN ('V_CONSULTATIONS_DETAIL', 'V_STOCK_ALERTE')
ORDER BY view_name;

-- Ex 49 : vue statistique par medecin
PROMPT --- Exercice 49
CREATE OR REPLACE VIEW v_stats_medecin AS
SELECT m.id_medecin, pe.nom, pe.prenom, m.specialite,
       (SELECT COUNT(*)
        FROM consultation c
        WHERE c.id_medecin = m.id_medecin) AS nombre_consultations,
       (SELECT NVL(SUM(f.montant_total), 0)
        FROM facture f
        JOIN consultation c ON c.id_consultation = f.id_consultation
        WHERE c.id_medecin = m.id_medecin) AS chiffre_affaires_facture
FROM medecin m
JOIN personne pe ON pe.id_personne = m.id_personne;

SELECT * FROM v_stats_medecin
ORDER BY chiffre_affaires_facture DESC, nom;

-- Ex 50 : index sur statut + date rdv (cree seulement s'il n'existe pas)
PROMPT --- Exercice 50
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM user_indexes
  WHERE index_name = 'IDX_RDV_STATUT_DATE';

  IF v_count = 0 THEN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX_RDV_STATUT_DATE ON RENDEZ_VOUS (STATUT, DATE_RDV)';
    DBMS_OUTPUT.PUT_LINE('Index cree.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Index deja existant.');
  END IF;
END;
/

SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE index_name = 'IDX_RDV_STATUT_DATE';

-- Ex 51 : synthese par clinique
-- (sous-requetes pour ne pas multiplier les totaux avec les jointures)
PROMPT --- Exercice 51
SELECT cl.id_clinique, cl.nom_clinique,
       (SELECT COUNT(*)
        FROM service s
        WHERE s.id_clinique = cl.id_clinique) AS nombre_services,
       (SELECT COUNT(*)
        FROM medecin m
        WHERE m.id_clinique = cl.id_clinique) AS nombre_medecins,
       (SELECT COUNT(*)
        FROM consultation c
        JOIN service s ON s.id_service = c.id_service
        WHERE s.id_clinique = cl.id_clinique) AS nombre_consultations,
       (SELECT COUNT(*)
        FROM hospitalisation h
        JOIN service s ON s.id_service = h.id_service
        WHERE s.id_clinique = cl.id_clinique) AS nombre_hospitalisations,
       (SELECT NVL(SUM(f.montant_total), 0)
        FROM facture f
        WHERE f.id_consultation IN (
          SELECT c.id_consultation
          FROM consultation c
          JOIN service s ON s.id_service = c.id_service
          WHERE s.id_clinique = cl.id_clinique
        )
        OR f.id_hospitalisation IN (
          SELECT h.id_hospitalisation
          FROM hospitalisation h
          JOIN service s ON s.id_service = h.id_service
          WHERE s.id_clinique = cl.id_clinique
        )) AS total_facture
FROM clinique cl
ORDER BY cl.nom_clinique;

-- Controle final : nombre de lignes par table
PROMPT --- Controle final
SELECT 'CLINIQUE' AS table_nom, COUNT(*) AS nombre FROM clinique
UNION ALL SELECT 'PERSONNE', COUNT(*) FROM personne
UNION ALL SELECT 'PATIENT', COUNT(*) FROM patient
UNION ALL SELECT 'MEDECIN', COUNT(*) FROM medecin
UNION ALL SELECT 'SERVICE', COUNT(*) FROM service
UNION ALL SELECT 'RENDEZ_VOUS', COUNT(*) FROM rendez_vous
UNION ALL SELECT 'CONSULTATION', COUNT(*) FROM consultation
UNION ALL SELECT 'HOSPITALISATION', COUNT(*) FROM hospitalisation
UNION ALL SELECT 'FACTURE', COUNT(*) FROM facture
UNION ALL SELECT 'PAIEMENT', COUNT(*) FROM paiement
ORDER BY table_nom;

SPOOL OFF
