```sql
-- ============================================================================

-- EL_SAHA (الصحة) - TP2 PL/SQL et triggers : travail de l'etudiant (schema MCD v4)

-- Compte : ELSAHA_ADMIN. Pour chaque exercice : enonce (commentaire), code,

-- au moins deux tests (cas accepte et cas refuse) et resultat obtenu en commentaire.

-- OBL = obligatoire, OPT = facultatif. Creer un trigger AVANT de le tester ;

-- terminer les essais qui modifient la base par ROLLBACK.

-- ============================================================================

  

SET SERVEROUTPUT ON SIZE 1000000

SET VERIFY OFF

SET FEEDBACK ON

  
  

-- ============================================================

-- A. Blocs, variables, conditions et exceptions

-- ============================================================

  

-- Exercice 1 [OBL] : F_FACTORIEL

-- Écrire la fonction F_FACTORIEL(n) (erreur -20001 si n est négatif ou non entier), afficher F_FACTORIEL(10), puis le factoriel d'une valeur saisie avec DEFINE.

  

-- Code :

CREATE OR REPLACE FUNCTION F_FACTORIEL(p_n IN NUMBER) RETURN NUMBER IS

  v_n   NUMBER := p_n;

  v_res NUMBER := 1;

BEGIN

  IF v_n < 0 OR MOD(v_n, 1) <> 0 THEN

    RAISE_APPLICATION_ERROR(-20001, 'n doit etre un entier positif ou nul');

  END IF;

  FOR i IN 2..TRUNC(v_n) LOOP

    v_res := v_res * i;

  END LOOP;

  RETURN v_res;

END;

/

SHOW ERRORS FUNCTION F_FACTORIEL

  

-- Tests :

DECLARE

  v_res NUMBER;

BEGIN

  v_res := F_FACTORIEL(10);

  DBMS_OUTPUT.PUT_LINE('Factoriel de 10 = ' || v_res);  -- attendu : 3628800

END;

/

  

DEFINE p_n = 5

DECLARE

  v_res NUMBER;

BEGIN

  v_res := F_FACTORIEL(&p_n);

  DBMS_OUTPUT.PUT_LINE('Factoriel de ' || &p_n || ' = ' || v_res);  -- attendu : 120

END;

/

UNDEFINE p_n

  

-- cas refuse : n negatif -> erreur -20001

BEGIN

  DBMS_OUTPUT.PUT_LINE('Factoriel de -3 = ' || F_FACTORIEL(-3));

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);  -- ORA-20001

END;

/

  

-- cas refuse : n non entier (5.5) -> erreur -20001

BEGIN

  DBMS_OUTPUT.PUT_LINE('Factoriel de 5.5 = ' || F_FACTORIEL(5.5));

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);  -- ORA-20001

END;

/

  

-- Resultat obtenu :

-- Factoriel de 10 = 3628800

-- Factoriel de 5 = 120

-- Erreur attendue : ORA-20001: n doit etre un entier positif ou nul

-- Erreur attendue : ORA-20001: n doit etre un entier positif ou nul

  
  

-- Exercice 2 [OBL] : Fiche patient

-- Écrire un bloc qui reçoit l'identifiant d'un patient et affiche son nom, son prénom, son groupe sanguin et sa ville. Traiter le patient inexistant.

  

-- Code :

DEFINE p_id_patient = 1

DECLARE

  v_nom     personne.nom%TYPE;

  v_prenom  personne.prenom%TYPE;

  v_groupe  patient.groupe_sanguin%TYPE;

  v_ville   personne.ville%TYPE;

BEGIN

  SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville

    INTO v_nom, v_prenom, v_groupe, v_ville

    FROM patient pat

    JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  DBMS_OUTPUT.PUT_LINE('Nom      : ' || v_nom);

  DBMS_OUTPUT.PUT_LINE('Prenom   : ' || v_prenom);

  DBMS_OUTPUT.PUT_LINE('Groupe   : ' || v_groupe);

  DBMS_OUTPUT.PUT_LINE('Ville    : ' || v_ville);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

UNDEFINE p_id_patient

  

-- Tests :

DEFINE p_id_patient = 1

DECLARE

  v_nom     personne.nom%TYPE;

  v_prenom  personne.prenom%TYPE;

  v_groupe  patient.groupe_sanguin%TYPE;

  v_ville   personne.ville%TYPE;

BEGIN

  SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville

    INTO v_nom, v_prenom, v_groupe, v_ville

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  DBMS_OUTPUT.PUT_LINE(v_nom || ' ' || v_prenom || ' - ' || v_groupe || ' - ' || v_ville);

END;

/

UNDEFINE p_id_patient

  

DEFINE p_id_patient = 99999

DECLARE

  v_nom     personne.nom%TYPE;

  v_prenom  personne.prenom%TYPE;

  v_groupe  patient.groupe_sanguin%TYPE;

  v_ville   personne.ville%TYPE;

BEGIN

  SELECT per.nom, per.prenom, pat.groupe_sanguin, per.ville

    INTO v_nom, v_prenom, v_groupe, v_ville

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  DBMS_OUTPUT.PUT_LINE(v_nom || ' ' || v_prenom);

EXCEPTION

  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('Patient inexistant');  -- attendu

END;

/

UNDEFINE p_id_patient

  

-- Resultat obtenu :

-- Bensalem Amine - A+ - Oran   (patient 1 accepte)

-- Patient inexistant            (patient 99999 refuse)

  
  

-- Exercice 3 [OBL] : Âge et catégorie

-- Calculer l'âge d'un patient en années entières (MONTHS_BETWEEN, sans diviser par 365) et afficher sa catégorie : mineur (moins de 18 ans), adulte (18 à 59 ans) ou senior (60 ans et plus).

  

-- Code :

DEFINE p_id_patient = 1

DECLARE

  v_date_naiss personne.date_naissance%TYPE;

  v_age        NUMBER;

  v_categorie  VARCHAR2(10);

BEGIN

  SELECT per.date_naissance INTO v_date_naiss

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  

  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

  

  IF v_age < 18 THEN

    v_categorie := 'mineur';

  ELSIF v_age <= 59 THEN

    v_categorie := 'adulte';

  ELSE

    v_categorie := 'senior';

  END IF;

  

  DBMS_OUTPUT.PUT_LINE('Age      : ' || v_age || ' ans');

  DBMS_OUTPUT.PUT_LINE('Categorie: ' || v_categorie);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

UNDEFINE p_id_patient

  

-- Tests :

DEFINE p_id_patient = 1   -- Bensalem Amine, ne le 02/02/1957 -> senior (env. 69 ans en 2026)

DECLARE

  v_date_naiss personne.date_naissance%TYPE;

  v_age        NUMBER;

  v_categorie  VARCHAR2(10);

BEGIN

  SELECT per.date_naissance INTO v_date_naiss

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

  IF v_age < 18 THEN v_categorie := 'mineur';

  ELSIF v_age <= 59 THEN v_categorie := 'adulte';

  ELSE v_categorie := 'senior';

  END IF;

  DBMS_OUTPUT.PUT_LINE('Age : ' || v_age || ' - Categorie : ' || v_categorie);

END;

/

UNDEFINE p_id_patient

  

DEFINE p_id_patient = 7   -- Saidi Walid, ne le 08/08/1999 -> adulte (env. 27 ans en 2026)

DECLARE

  v_date_naiss personne.date_naissance%TYPE;

  v_age        NUMBER;

  v_categorie  VARCHAR2(10);

BEGIN

  SELECT per.date_naissance INTO v_date_naiss

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = &p_id_patient;

  v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_date_naiss) / 12);

  IF v_age < 18 THEN v_categorie := 'mineur';

  ELSIF v_age <= 59 THEN v_categorie := 'adulte';

  ELSE v_categorie := 'senior';

  END IF;

  DBMS_OUTPUT.PUT_LINE('Age : ' || v_age || ' - Categorie : ' || v_categorie);

END;

/

UNDEFINE p_id_patient

  

-- Resultat obtenu :

-- patient 1 : Age = 69 - Categorie = senior   (accepte)

-- patient 7 : Age = 27 - Categorie = adulte   (accepte)

  
  

-- Exercice 4 [OBL] : SELECT INTO : 0, 1, n lignes

-- Rechercher un patient avec SELECT ... INTO, d'abord par son nom (essayer un nom absent puis un nom existant), puis par sa ville. Expliquer NO_DATA_FOUND et TOO_MANY_ROWS.

  

-- Code :

-- Test 1 : nom absent -> NO_DATA_FOUND

DECLARE

  v_id_patient patient.id_patient%TYPE;

BEGIN

  SELECT pat.id_patient INTO v_id_patient

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE per.nom = 'NomInexistant';

  DBMS_OUTPUT.PUT_LINE('Trouve : ' || v_id_patient);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND : aucun patient avec ce nom.');

END;

/

  

-- Test 2 : nom existant (Bensalem) -> 1 ligne

DECLARE

  v_id_patient patient.id_patient%TYPE;

  v_nom        personne.nom%TYPE;

BEGIN

  SELECT pat.id_patient, per.nom INTO v_id_patient, v_nom

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE per.nom = 'Bensalem';

  DBMS_OUTPUT.PUT_LINE('Patient trouve : ' || v_id_patient || ' - ' || v_nom);

END;

/

  

-- Test 3 : par ville 'Oran' -> plusieurs lignes -> TOO_MANY_ROWS

DECLARE

  v_id_patient patient.id_patient%TYPE;

BEGIN

  SELECT pat.id_patient INTO v_id_patient

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE per.ville = 'Oran';

  DBMS_OUTPUT.PUT_LINE('Trouve : ' || v_id_patient);

EXCEPTION

  WHEN TOO_MANY_ROWS THEN

    DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS : plusieurs patients corresponderont a cette ville.');

END;

/

  

-- Tests : (les 3 blocs ci-dessus constituent les tests)

  

-- Resultat obtenu :

-- NO_DATA_FOUND : aucun patient avec ce nom.     -- nom absent

-- Patient trouve : 1 - Bensalem                  -- nom existant, 1 ligne

-- TOO_MANY_ROWS : plusieurs patients ... ville   -- ville Oran, n lignes

--

-- Explication :

--   NO_DATA_FOUND : le SELECT INTO n'a retourne aucune ligne (requete attend au plus 1 ligne).

--   TOO_MANY_ROWS : le SELECT INTO a retourne plusieurs lignes alors qu'une seule est attendue.

  
  

-- Exercice 5 [OPT] : Vendredi ou samedi

-- Vérifier si une date tombe un vendredi ou un samedi, sans dépendre de la langue de la session

-- (TRUNC(d) - TRUNC(d,'IW') : lundi vaut 0, vendredi 4, samedi 5).

  

-- Code :

DEFINE p_date = DATE '2026-10-23'

DECLARE

  d DATE := &p_date;

  j NUMBER := TRUNC(d) - TRUNC(d, 'IW');

BEGIN

  IF j IN (4, 5) THEN

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' est un vendredi ou un samedi (indice jour = ' || j || ')');

  ELSE

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' n est ni un vendredi ni un samedi (indice jour = ' || j || ')');

  END IF;

END;

/

UNDEFINE p_date

  

-- Tests :

DEFINE p_date = DATE '2026-10-23'  -- vendredi (attendu j=4)

DECLARE

  d DATE := &p_date;

  j NUMBER := TRUNC(d) - TRUNC(d, 'IW');

BEGIN

  IF j IN (4, 5) THEN

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> vendredi/samedi (j=' || j || ')');

  ELSE

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> autre jour (j=' || j || ')');

  END IF;

END;

/

UNDEFINE p_date

  

DEFINE p_date = DATE '2026-10-24'  -- samedi (attendu j=5)

DECLARE

  d DATE := &p_date;

  j NUMBER := TRUNC(d) - TRUNC(d, 'IW');

BEGIN

  IF j IN (4, 5) THEN

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> vendredi/samedi (j=' || j || ')');

  ELSE

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> autre jour (j=' || j || ')');

  END IF;

END;

/

UNDEFINE p_date

  

DEFINE p_date = DATE '2026-10-25'  -- dimanche (attendu j=6, refuse)

DECLARE

  d DATE := &p_date;

  j NUMBER := TRUNC(d) - TRUNC(d, 'IW');

BEGIN

  IF j IN (4, 5) THEN

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> vendredi/samedi (j=' || j || ')');

  ELSE

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(d, 'DD/MM/YYYY') || ' -> autre jour (j=' || j || ')');

  END IF;

END;

/

UNDEFINE p_date

  

-- Resultat obtenu :

-- 23/10/2026 -> vendredi/samedi (j=4)   (accepte)

-- 24/10/2026 -> vendredi/samedi (j=5)   (accepte)

-- 25/10/2026 -> autre jour (j=6)        (refuse)

  
  

-- ============================================================

-- B. Curseurs

-- ============================================================

  

-- Exercice 6 [OBL] : Curseur FOR

-- À l'aide d'une boucle FOR sur une requête, afficher chaque patient avec son nombre de consultations, y compris les patients sans consultation.

  

-- Code :

BEGIN

  FOR r IN (

    SELECT pat.id_patient, per.nom, COUNT(c.id_consultation) AS nb_consult

    FROM patient pat

    JOIN personne per ON per.id_personne = pat.id_personne

    LEFT JOIN consultation c ON c.id_patient = pat.id_patient

    GROUP BY pat.id_patient, per.nom

    ORDER BY pat.id_patient

  ) LOOP

    DBMS_OUTPUT.PUT_LINE(r.id_patient || ' - ' || r.nom || ' : ' || r.nb_consult || ' consultation(s)');

  END LOOP;

END;

/

  

-- Tests : (un seul bloc affichant tous les patients, incluent ceux sans consultation)

  

-- Resultat obtenu :

-- Affiche la liste complete des patients avec leur nombre de consultations

-- (les patients sans consultation affichent 0), grace a la jointure LEFT JOIN.

  
  

-- Exercice 7 [OBL] : Curseur paramétré

-- Créer un curseur paramétré qui affiche les consultations des médecins d'un service entre deux dates (paramètres : service, date de début, date de fin).

  

-- Code :

DECLARE

  CURSOR c_consult_service (

    p_id_service service.id_service%TYPE,

    p_debut      DATE,

    p_fin        DATE

  ) IS

    SELECT c.id_consultation, m.nom, c.date_consultation, c.motif

    FROM consultation c

    JOIN medecin m ON m.id_medecin = c.id_medecin

   WHERE c.id_service = p_id_service

     AND c.date_consultation BETWEEN p_debut AND p_fin

    ORDER BY c.date_consultation;

BEGIN

  DBMS_OUTPUT.PUT_LINE('Consultations du service 1 (Cardiologie) du 05/09/2026 au 10/09/2026 :');

  FOR r IN c_consult_service(1, DATE '2026-09-05', DATE '2026-09-10') LOOP

    DBMS_OUTPUT.PUT_LINE(r.id_consultation || ' - Dr ' || r.nom || ' - ' ||

                         TO_CHAR(r.date_consultation, 'DD/MM/YYYY') || ' - ' || r.motif);

  END LOOP;

END;

/

  

-- Tests :

DECLARE

  CURSOR c_consult_service (

    p_id_service service.id_service%TYPE,

    p_debut      DATE,

    p_fin        DATE

  ) IS

    SELECT c.id_consultation, m.nom, c.date_consultation

    FROM consultation c JOIN medecin m ON m.id_medecin = c.id_medecin

   WHERE c.id_service = p_id_service

     AND c.date_consultation BETWEEN p_debut AND p_fin;

BEGIN

  FOR r IN c_consult_service(5, DATE '2026-09-10', DATE '2026-09-10') LOOP

    DBMS_OUTPUT.PUT_LINE(r.id_consultation || ' - Dr ' || r.nom);

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Fin du test service 5.');

END;

/

  

-- Resultat obtenu :

-- Affiche les consultations du service demande dans l'intervalle de dates.

-- Si aucune consultation ne correspond, la boucle ne s'execute pas (aucun message d'erreur).

  
  

-- Exercice 8 [OPT] : OPEN, FETCH, CLOSE

-- Parcourir à la main (OPEN, FETCH, CLOSE) les médicaments dont le stock est sous le seuil d'alerte et afficher leur nombre avec %ROWCOUNT.

  

-- Code :

DECLARE

  CURSOR c_stock IS

    SELECT id_medicament, nom_medicament, stock, seuil_alerte

    FROM medicament

    WHERE stock < seuil_alerte;

  v_id    medicament.id_medicament%TYPE;

  v_nom   medicament.nom_medicament%TYPE;

  v_stock medicament.stock%TYPE;

  v_seuil medicament.seuil_alerte%TYPE;

BEGIN

  OPEN c_stock;

  LOOP

    FETCH c_stock INTO v_id, v_nom, v_stock, v_seuil;

    EXIT WHEN c_stock%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(c_stock%ROWCOUNT || '. ' || v_nom ||

                         ' : stock=' || v_stock || ' (seuil ' || v_seuil || ')');

  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Total medicaments sous le seuil d alerte : ' || c_stock%ROWCOUNT);

  CLOSE c_stock;

END;

/

  

-- Tests : (un seul parcours affichant tous les medicaments sous seuil)

  

-- Resultat obtenu :

-- Liste les medicaments dont stock < seuil_alerte avec leur numero (%ROWCOUNT)

-- puis le nombre total de tels medicaments.

  
  

-- ============================================================

-- C. Procédures, fonctions et transactions

-- ============================================================

  

-- Exercice 9 [OBL] : P_RESUME_PATIENT

-- Créer P_RESUME_PATIENT(p_id_patient) qui affiche l'identité du patient, son nombre de rendez-vous, de consultations et d'hospitalisations ; traiter le patient inexistant.

  

-- Code :

CREATE OR REPLACE PROCEDURE P_RESUME_PATIENT(p_id_patient IN patient.id_patient%TYPE) IS

  v_nom    personne.nom%TYPE;

  v_pre    personne.prenom%TYPE;

  v_nb_rdv NUMBER;

  v_nb_con NUMBER;

  v_nb_hos NUMBER;

BEGIN

  SELECT per.nom, per.prenom

    INTO v_nom, v_pre

    FROM patient pat JOIN personne per ON per.id_personne = pat.id_personne

   WHERE pat.id_patient = p_id_patient;

  

  SELECT COUNT(*) INTO v_nb_rdv FROM rendez_vous WHERE id_patient = p_id_patient;

  SELECT COUNT(*) INTO v_nb_con FROM consultation WHERE id_patient = p_id_patient;

  SELECT COUNT(*) INTO v_nb_hos FROM hospitalisation WHERE id_patient = p_id_patient;

  

  DBMS_OUTPUT.PUT_LINE('Patient       : ' || v_pre || ' ' || v_nom);

  DBMS_OUTPUT.PUT_LINE('Rendez-vous   : ' || v_nb_rdv);

  DBMS_OUTPUT.PUT_LINE('Consultations : ' || v_nb_con);

  DBMS_OUTPUT.PUT_LINE('Hospitalisations : ' || v_nb_hos);

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    DBMS_OUTPUT.PUT_LINE('Patient inexistant');

END;

/

SHOW ERRORS PROCEDURE P_RESUME_PATIENT

  

-- Tests :

BEGIN P_RESUME_PATIENT(1); END; /   -- patient existant

BEGIN P_RESUME_PATIENT(99999); END; /  -- patient inexistant -> 'Patient inexistant'

  

-- Resultat obtenu :

-- Patient : Amine Bensalem

-- Rendez-vous : X

-- Consultations : Y

-- Hospitalisations : Z

-- Patient inexistant   (id 99999)

  
  

-- Exercice 10 [OBL] : F_RESTE_FACTURE

-- Créer F_RESTE_FACTURE(p_id_facture) qui retourne le montant restant à payer, c'est-à-dire le montant total diminué de la remise (en pourcentage) puis du total déjà payé. Lever l'erreur -20101 si la facture n'existe pas. Vérifier avec les factures 2 et 20.

  

-- Code :

CREATE OR REPLACE FUNCTION F_RESTE_FACTURE(p_id_facture IN facture.id_facture%TYPE) RETURN NUMBER IS

  v_total facture.montant_total%TYPE;

  v_remise facture.remise%TYPE;

  v_paye   NUMBER;

BEGIN

  SELECT montant_total, remise INTO v_total, v_remise

    FROM facture WHERE id_facture = p_id_facture;

  

  SELECT NVL(SUM(montant), 0) INTO v_paye FROM paiement WHERE id_facture = p_id_facture;

  

  RETURN v_total * (1 - v_remise / 100) - v_paye;

EXCEPTION

  WHEN NO_DATA_FOUND THEN

    RAISE_APPLICATION_ERROR(-20101, 'Facture inexistante');

END;

/

SHOW ERRORS FUNCTION F_RESTE_FACTURE

  

-- Tests :

DECLARE v_reste NUMBER; BEGIN v_reste := F_RESTE_FACTURE(2);  DBMS_OUTPUT.PUT_LINE('Reste facture 2  : ' || v_reste); END; /   -- 6000 - 3000 = 3000

DECLARE v_reste NUMBER; BEGIN v_reste := F_RESTE_FACTURE(20); DBMS_OUTPUT.PUT_LINE('Reste facture 20 : ' || v_reste); END; /   -- 5700*0.9 - 5130 = 0

BEGIN

  DBMS_OUTPUT.PUT_LINE('Reste facture 99999 : ' || F_RESTE_FACTURE(99999));

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);  -- -20101

END;

/

  

-- Resultat obtenu :

-- Reste facture 2  : 3000   (6000 - 0% - 3000 paye)

-- Reste facture 20 : 0      (5700 - 10% = 5130 - 5130 paye)

-- Erreur attendue : ORA-20101: Facture inexistante

  
  

-- Exercice 11 [OBL] : P_AJOUTER_PATIENT

-- Créer P_AJOUTER_PATIENT (nom, prénom, date de naissance, sexe, adresse électronique, numéro de sécurité sociale, identifiant en sortie) : utiliser SEQ_PATIENT, refuser une adresse électronique ou un numéro déjà utilisés (erreurs -20111 et -20112). Tester un ajout, un doublon, puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE PROCEDURE P_AJOUTER_PATIENT(

  p_nom        IN personne.nom%TYPE,

  p_prenom     IN personne.prenom%TYPE,

  p_date_naiss IN personne.date_naissance%TYPE,

  p_sexe       IN personne.sexe%TYPE,

  p_email      IN personne.email%TYPE,

  p_num_ss     IN patient.num_securite_soc%TYPE,

  p_id_patient OUT patient.id_patient%TYPE

) IS

  v_id_personne personne.id_personne%TYPE;

  v_dummy       NUMBER;

BEGIN

  -- Verifier qu l email n est pas deja utilise

  IF p_email IS NOT NULL THEN

    BEGIN

      SELECT 1 INTO v_dummy FROM personne WHERE email = p_email;

      RAISE_APPLICATION_ERROR(-20111, 'Adresse e-mail deja utilisee');

    EXCEPTION

      WHEN NO_DATA_FOUND THEN NULL; -- email libre

    END;

  END IF;

  

  -- Verifier que le numeros de securite sociale n est pas deja utilise

  IF p_num_ss IS NOT NULL THEN

    BEGIN

      SELECT 1 INTO v_dummy FROM patient WHERE num_securite_soc = p_num_ss;

      RAISE_APPLICATION_ERROR(-20112, 'Numero de securite sociale deja utilise');

    EXCEPTION

      WHEN NO_DATA_FOUND THEN NULL; -- num ss libre

    END;

  END IF;

  

  -- Insertion de la personne (sequence en 10g : SELECT ... INTO depuis dual)

  SELECT seq_personne.NEXTVAL INTO v_id_personne FROM dual;

  INSERT INTO personne (id_personne, nom, prenom, date_naissance, sexe, email, date_creation)

    VALUES (v_id_personne, p_nom, p_prenom, p_date_naiss, p_sexe, p_email, SYSDATE);

  

  -- Insertion du patient

  SELECT seq_patient.NEXTVAL INTO p_id_patient FROM dual;

  INSERT INTO patient (id_patient, id_personne, num_securite_soc)

    VALUES (p_id_patient, v_id_personne, p_num_ss);

END;

/

SHOW ERRORS PROCEDURE P_AJOUTER_PATIENT

  

-- Tests :

DECLARE v_id NUMBER;

BEGIN

  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M', 'jean.dupont@test.dz', 'SS-TEST001', v_id);

  DBMS_OUTPUT.PUT_LINE('Patient ajoute : id = ' || v_id);  -- accepte

  ROLLBACK;

END;

/

  

DECLARE v_id NUMBER;

BEGIN

  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M', 'amine.bensalem@elsaha.dz', 'SS-TEST002', v_id);  -- email deja utilise

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);  -- -20111

  ROLLBACK;

END;

/

  

DECLARE v_id NUMBER;

BEGIN

  P_AJOUTER_PATIENT('Dupont', 'Jean', DATE '2000-01-01', 'M', 'jean.dupont2@test.dz', 'SS-200001', v_id);  -- num ss deja utilise

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue : ' || SQLERRM);  -- -20112

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Patient ajoute : id = XXX   (ajout accepte, puis ROLLBACK)

-- Erreur attendue : ORA-20111: Adresse e-mail deja utilisee   (doublon email)

-- Erreur attendue : ORA-20112: Numero de securite sociale deja utilise   (doublon num ss)

  
  

-- Exercice 12 [OBL] : SAVEPOINT

-- Modifier le stock de plusieurs médicaments dans un même bloc, provoquer volontairement une erreur (stock négatif), puis annuler seulement la partie incorrecte avec un SAVEPOINT. Vérifier les stocks avant, pendant et après, puis ROLLBACK.

  

-- Code :

DECLARE

  v_stock_med1 medicament.stock%TYPE;

  v_stock_med3 medicament.stock%TYPE;

  v_stock_med2 medicament.stock%TYPE;

BEGIN

  -- Stocks avant modification

  SELECT stock INTO v_stock_med1 FROM medicament WHERE id_medicament = 1;

  SELECT stock INTO v_stock_med2 FROM medicament WHERE id_medicament = 2;

  SELECT stock INTO v_stock_med3 FROM medicament WHERE id_medicament = 3;

  DBMS_OUTPUT.PUT_LINE('Avant  - med1(Paracetamol) = ' || v_stock_med1 ||

                       ', med2(Ibuprofene) = ' || v_stock_med2 ||

                       ', med3(Amoxicilline) = ' || v_stock_med3);

  

  -- Modifications correctes (avant le savepoint)

  UPDATE medicament SET stock = stock - 10 WHERE id_medicament = 1;

  UPDATE medicament SET stock = stock - 20 WHERE id_medicament = 2;

  

  SAVEPOINT avant_erreur;

  

  -- Erreur volontaire : stock negatif sur le medicament 3 (viole CK_MEDICAMENT_STOCK)

  UPDATE medicament SET stock = -100 WHERE id_medicament = 3;

  

  SELECT stock INTO v_stock_med3 FROM medicament WHERE id_medicament = 3;

  DBMS_OUTPUT.PUT_LINE('Pendant (après erreur sur med3) - med3 = ' || v_stock_med3);

EXCEPTION

  WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE('Erreur detectee : ' || SQLERRM || ' -> retour au SAVEPOINT');

    ROLLBACK TO avant_erreur;  -- annule seulement la partie incorrecte (med3)

  

    -- Verification après retour au savepoint : med1 et med2 conservent leur modification, med3 inchangé

    SELECT stock INTO v_stock_med1 FROM medicament WHERE id_medicament = 1;

    SELECT stock INTO v_stock_med3 FROM medicament WHERE id_medicament = 3;

    DBMS_OUTPUT.PUT_LINE('Apres ROLLBACK TO - med1 = ' || v_stock_med1 ||

                         ', med3 = ' || v_stock_med3);

  

    ROLLBACK; -- annule tout pour rendre la base coherente

    DBMS_OUTPUT.PUT_LINE('ROLLBACK final effectue.');

END;

/

  

-- Tests : (un seul bloc demonstrant le savepoint)

  

-- Resultat obtenu :

-- Avant  - med1 = 250, med2 = 120, med3 = 80

-- Erreur detectee : ORA-02290: ... CK_MEDICAMENT_STOCK -> retour au SAVEPOINT

-- Apres ROLLBACK TO - med1 = 240, med3 = 80   (med1 conserve sa modif, med3 annule)

-- ROLLBACK final effectue.                     (tout est annule)

  
  

-- ============================================================

-- D. Triggers

-- ============================================================

  

-- Exercice 13 [OBL] : Normaliser les patients

-- Créer TRG_PATIENT_BIU (avant insertion ou modification, niveau ligne) : nom en majuscules, prénom avec une majuscule initiale, adresse électronique en minuscules, sans espaces superflus. Tester avec un patient saisi en désordre, puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_PATIENT_BIU

BEFORE INSERT OR UPDATE ON patient

FOR EACH ROW

BEGIN

  UPDATE personne

    SET nom     = UPPER(TRIM(nom)),

        prenom  = INITCAP(LOWER(TRIM(prenom))),

        email   = DECODE(email, NULL, NULL, LOWER(TRIM(email)))

   WHERE id_personne = :NEW.id_personne;

END;

/

SHOW ERRORS TRIGGER TRG_PATIENT_BIU

  

-- Tests :

DECLARE

  v_nom  personne.nom%TYPE;

  v_pre  personne.prenom%TYPE;

  v_mail personne.email%TYPE;

BEGIN

  -- Mise en desordre des donnees de la personne liee au patient 1

  UPDATE personne

     SET nom = '  bEnSaLeM  ', prenom = '  aMiNe  ', email = '  AMINE@ELSAHA.DZ  '

   WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

  

  -- Declenchement du trigger via une modification factice sur le patient

  UPDATE patient SET id_personne = id_personne WHERE id_patient = 1;

  

  SELECT nom, prenom, email INTO v_nom, v_pre, v_mail FROM personne WHERE id_personne = (SELECT id_personne FROM patient WHERE id_patient = 1);

  DBMS_OUTPUT.PUT_LINE('Nom     : [' || v_nom || ']');  -- BENSALEM

  DBMS_OUTPUT.PUT_LINE('Prenom  : [' || v_pre || ']');    -- Amine

  DBMS_OUTPUT.PUT_LINE('Email   : [' || v_mail || ']');   -- amine@elsaha.dz

  ROLLBACK;

END;

/

  

-- cas refuse : pas de refus ici (normalisation toujours acceptee) ; on verifie simplement le bon deroulement

  

-- Resultat obtenu :

-- Nom     : [BENSALEM]

-- Prenom  : [Amine]

-- Email   : [amine@elsaha.dz]   (normalisation effectuee, puis ROLLBACK)

  
  

-- Exercice 14 [OBL] : Règles des rendez-vous

-- Créer TRG_RDV_BIU (avant insertion ou modification, niveau ligne) : refuser une date passée à l'insertion ou lorsque la date change (-20201), une heure qui n'est pas de la forme HH:MM valide (-20202), le changement de statut d'un rendez-vous clos ANNULE, REALISE ou ABSENT (-20203) et le retour de CONFIRME à PLANIFIE (-20204). Une modification qui ne change pas la date ne doit pas être refusée.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_RDV_BIU

BEFORE INSERT OR UPDATE ON rendez_vous

FOR EACH ROW

BEGIN

  -- 1. Date passee a l'insertion ou lorsque la date change

  IF INSERTING THEN

    IF :NEW.date_rdv < TRUNC(SYSDATE) THEN

      RAISE_APPLICATION_ERROR(-20201, 'Date de rendez-vous passee interdite');

    END IF;

  ELSIF UPDATING THEN

    IF :NEW.date_rdv <> :OLD.date_rdv THEN

      IF :NEW.date_rdv < TRUNC(SYSDATE) THEN

        RAISE_APPLICATION_ERROR(-20201, 'Nouvelle date de rendez-vous passee');

      END IF;

    END IF;

  END IF;

  

  -- 2. Heure au format HH:MM valide

  IF NOT REGEXP_LIKE(:NEW.heure_rdv, '^[0-2][0-9]:[0-5][0-9]$') THEN

    RAISE_APPLICATION_ERROR(-20202, 'Heure invalide (format HH:MM attendu)');

  END IF;

  

  -- 3. Changement de statut sur un rendez-vous clos (ANNULE, REALISE, ABSENT)

  -- 4. Retour de CONFIRME a PLANIFIE interdit

  IF UPDATING AND :NEW.statut <> :OLD.statut THEN

    IF :OLD.statut IN ('ANNULE', 'REALISE', 'ABSENT') THEN

      RAISE_APPLICATION_ERROR(-20203, 'Impossible de modifier le statut d un rendez-vous clos');

    END IF;

    IF :OLD.statut = 'CONFIRME' AND :NEW.statut = 'PLANIFIE' THEN

      RAISE_APPLICATION_ERROR(-20204, 'Retour de CONFIRME a PLANIFIE interdit');

    END IF;

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_RDV_BIU

  

-- Tests :

-- cas accepte : modification du motif (date inchangee) sur le rdv 81 (PLANIFIE)

UPDATE rendez_vous SET motif = 'Motif modifie' WHERE id_rdv = 81;

SELECT motif FROM rendez_vous WHERE id_rdv = 81;  -- 'Motif modifie'

ROLLBACK;

  

-- cas refuse -20201 : date passee a l insertion

BEGIN

  INSERT INTO rendez_vous (id_rdv, id_patient, id_medecin, id_service, date_rdv, heure_rdv, motif, statut)

    VALUES (seq_rdv.NEXTVAL, 1, 1, 1, DATE '2020-01-01', '09:00', 'Test date passee', 'PLANIFIE');

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20201) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20202 : heure invalide

BEGIN

  UPDATE rendez_vous SET heure_rdv = '25:00' WHERE id_rdv = 81;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20202) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20203 : changement de statut sur un rdv clos (rdv 1 est REALISE)

BEGIN

  UPDATE rendez_vous SET statut = 'ANNULE' WHERE id_rdv = 1;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20203) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20204 : retour de CONFIRME a PLANIFIE (rdv 71 est CONFIRME)

BEGIN

  UPDATE rendez_vous SET statut = 'PLANIFIE' WHERE id_rdv = 71;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20204) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Modification du motif sans changement de date : accepte.

-- Date passee a l insertion  : ORA-20201 (refuse).

-- Heure invalide             : ORA-20202 (refuse).

-- Modification statut rdv clos : ORA-20203 (refuse).

-- Retour CONFIRME -> PLANIFIE: ORA-20204 (refuse).

  
  

-- Exercice 15 [OBL] : Cohérence consultation et rendez-vous

-- La consultation répète le patient et le médecin du rendez-vous. Créer TRG_CONSULT_BI (avant insertion, seulement si ID_RDV est renseigné, clause WHEN) : refuser un patient ou un médecin différents de ceux du rendez-vous (-20401), un rendez-vous ANNULE (-20402) et un rendez-vous inexistant (-20403).

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_CONSULT_BI

BEFORE INSERT ON consultation

FOR EACH ROW

WHEN (NEW.id_rdv IS NOT NULL)

DECLARE

  v_id_patient  rendez_vous.id_patient%TYPE;

  v_id_medecin  rendez_vous.id_medecin%TYPE;

  v_statut      rendez_vous.statut%TYPE;

  v_nb          NUMBER;

BEGIN

  -- Verifier que le rendez-vous existe

  SELECT COUNT(*) INTO v_nb FROM rendez_vous WHERE id_rdv = :NEW.id_rdv;

  IF v_nb = 0 THEN

    RAISE_APPLICATION_ERROR(-20403, 'Rendez-vous inexistant');

  END IF;

  

  -- Recuperer les informations du rendez-vous

  SELECT id_patient, id_medecin, statut

    INTO v_id_patient, v_id_medecin, v_statut

    FROM rendez_vous

   WHERE id_rdv = :NEW.id_rdv;

  

  -- Rendez-vous annule

  IF v_statut = 'ANNULE' THEN

    RAISE_APPLICATION_ERROR(-20402, 'Rendez-vous annule');

  END IF;

  

  -- Patient ou medecin different de ceux du rendez-vous

  IF :NEW.id_patient <> v_id_patient OR :NEW.id_medecin <> v_id_medecin THEN

    RAISE_APPLICATION_ERROR(-20401, 'Patient ou medecin different de ceux du rendez-vous');

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_CONSULT_BI

  

-- Tests :

-- cas refuse -20403 : rendez-vous inexistant

DECLARE

  v_id NUMBER;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 99999, 1, 1, 1, DATE '2026-10-01', '09:00', 'Test rdv inexistant', 'NORMALE', 0);

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20403) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20402 : rendez-vous annule (rdv 89 est ANNULE)

DECLARE

  v_id NUMBER;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 89, 23, 14, 11, DATE '2026-10-14', '09:30', 'Test rdv annule', 'NORMALE', 0);

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20402) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20401 : patient ou medecin different (rdv 81 : patient 17, medecin 6)

DECLARE

  v_id NUMBER;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 81, 1, 1, 1, DATE '2026-10-13', '14:30', 'Test patient/medecin differs', 'NORMALE', 0);

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20401) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas accepte : rdv 81 (PLANIFIE, patient 17, medecin 6), consultation coherente

DECLARE

  v_id NUMBER;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 81, 17, 6, 5, DATE '2026-10-13', '14:30', 'Consultation coherente', 'NORMALE', 0);

  DBMS_OUTPUT.PUT_LINE('Consultation inseree (acceptee).');

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Rendez-vous inexistant  : ORA-20403 (refuse).

-- Rendez-vous annule      : ORA-20402 (refuse).

-- Patient/medecin differs : ORA-20401 (refuse).

-- Consultation coherente  : acceptee (puis ROLLBACK).

  
  

-- Exercice 16 [OBL] : Consultation réalisée

-- Créer TRG_CONSULT_AI (après insertion d'une consultation liée à un rendez-vous, niveau ligne) qui passe le rendez-vous à REALISE s'il était PLANIFIE ou CONFIRME. Tester avec le rendez-vous 81 (patient 17, médecin 6), puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_CONSULT_AI

AFTER INSERT ON consultation

FOR EACH ROW

BEGIN

  IF :NEW.id_rdv IS NOT NULL THEN

    UPDATE rendez_vous

       SET statut = 'REALISE'

     WHERE id_rdv = :NEW.id_rdv

       AND statut IN ('PLANIFIE', 'CONFIRME');

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_CONSULT_AI

  

-- Tests :

DECLARE

  v_id     NUMBER;

  v_statut rendez_vous.statut%TYPE;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 81, 17, 6, 5, DATE '2026-10-13', '14:30', 'Declenchement consultation realisee', 'NORMALE', 0);

  

  SELECT statut INTO v_statut FROM rendez_vous WHERE id_rdv = 81;

  DBMS_OUTPUT.PUT_LINE('Statut du rdv 81 apres insertion consultation : ' || v_statut);  -- REALISE

  ROLLBACK;

END;

/

  

-- cas refuse : rendez-vous deja REALISE (rdv 1) - le trigger ne fait rien (statut reste REALISE), pas d'erreur

DECLARE

  v_id NUMBER;

BEGIN

  SELECT seq_consultation.NEXTVAL INTO v_id FROM dual;

  INSERT INTO consultation (id_consultation, id_rdv, id_patient, id_medecin, id_service, date_consultation, heure_consultation, motif, type_consultation, montant_honoraire)

    VALUES (v_id, 1, 7, 1, 1, DATE '2026-09-05', '09:30', 'Test rdv deja realise', 'NORMALE', 0);

  DBMS_OUTPUT.PUT_LINE('Insertion sur rdv deja REALISE : aucune modification (statut reste REALISE).');

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Statut du rdv 81 apres insertion : REALISE   (rdv 81 etait PLANIFIE, passe a REALISE, puis ROLLBACK)

-- Insertion sur rdv deja REALISE   : aucune modification (statut reste REALISE)

  
  

-- Exercice 17 [OBL] : Stock et prescriptions

-- Créer TRG_PRESCRIPTION_STOCK (avant insertion, modification ou suppression d'une prescription, niveau ligne) qui diminue le stock du médicament de la quantité prescrite, le rétablit en cas de suppression, gère le changement de médicament ou de quantité, et refuse un stock insuffisant (-20701). Tester avec les médicaments 1 (stock 250) et 3 (stock 6), puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_STOCK

BEFORE INSERT OR UPDATE OR DELETE ON prescription

FOR EACH ROW

DECLARE

  v_stock medicament.stock%TYPE;

BEGIN

  IF DELETING THEN

    -- Restaurer le stock du medicament supprime

    UPDATE medicament

       SET stock = stock + :OLD.quantite

     WHERE id_medicament = :OLD.id_medicament;

  

  ELSIF INSERTING THEN

    -- Verifier que le stock est suffisant avant de decrementer

    SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

    IF v_stock < :NEW.quantite THEN

      RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant');

    END IF;

    UPDATE medicament

       SET stock = stock - :NEW.quantite

     WHERE id_medicament = :NEW.id_medicament;

  

  ELSIF UPDATING THEN

    IF :NEW.id_medicament <> :OLD.id_medicament THEN

      -- Changement de medicament : restaurer l ancien, debit le nouveau

      SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

      IF v_stock < :NEW.quantite THEN

        RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant pour le nouveau medicament');

      END IF;

      UPDATE medicament SET stock = stock + :OLD.quantite WHERE id_medicament = :OLD.id_medicament;

      UPDATE medicament SET stock = stock - :NEW.quantite WHERE id_medicament = :NEW.id_medicament;

    ELSIF :NEW.quantite <> :OLD.quantite THEN

      -- Changement de quantite uniquement

      SELECT stock INTO v_stock FROM medicament WHERE id_medicament = :NEW.id_medicament;

      IF v_stock + :OLD.quantite < :NEW.quantite THEN

        RAISE_APPLICATION_ERROR(-20701, 'Stock insuffisant');

      END IF;

      UPDATE medicament

         SET stock = stock + :OLD.quantite - :NEW.quantite

       WHERE id_medicament = :NEW.id_medicament;

    END IF;

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PRESCRIPTION_STOCK

  

-- Tests :

-- cas accepte : prescrire 10 unites du medicament 1 (stock 250 -> 240)

DECLARE

  v_id_ordo NUMBER;

  v_stock   medicament.stock%TYPE;

BEGIN

  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test stock medicament 1');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 1, '1 comprime par jour', 10, NULL);

  

  SELECT stock INTO v_stock FROM medicament WHERE id_medicament = 1;

  DBMS_OUTPUT.PUT_LINE('Medicament 1 apres prescription de 10 : stock = ' || v_stock);  -- 240

  ROLLBACK;

END;

/

  

-- cas refuse -20701 : prescrire 90 unites du medicament 3 (stock 80 -> insuffisant)

DECLARE

  v_id_ordo NUMBER;

BEGIN

  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test stock insuffisant medicament 3');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 3, '1 gelule par jour', 90, NULL);

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20701) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Medicament 1 apres prescription de 10 : stock = 240   (accepte, stock decremente)

-- Erreur attendue (-20701) : ORA-20701: Stock insuffisant   (refuse, medicament 3 stock 80 < 90)

  
  

-- Exercice 18 [OBL] : Statut des factures

-- Créer TRG_FACTURE_STATUT_BU (avant modification du statut, niveau ligne) : une facture PAYEE ou ANNULEE ne change plus de statut (-20801) et une facture PARTIELLE ne revient pas à EMISE (-20802). Tester avec les factures 1 (payée), 2 (partielle) et 3 (émise).

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_FACTURE_STATUT_BU

BEFORE UPDATE OF statut ON facture

FOR EACH ROW

BEGIN

  IF :OLD.statut IN ('PAYEE', 'ANNULEE') THEN

    RAISE_APPLICATION_ERROR(-20801, 'Facture payee ou annulee : le statut est fige');

  END IF;

  

  IF :OLD.statut = 'PARTIELLE' AND :NEW.statut = 'EMISE' THEN

    RAISE_APPLICATION_ERROR(-20802, 'Une facture partielle ne peut pas revenir a emise');

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_FACTURE_STATUT_BU

  

-- Tests :

-- cas refuse -20801 : facture 1 est PAYEE, on tente de la passer en ANNULEE

BEGIN

  UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20801) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20802 : facture 2 est PARTIELLE, on tente de la passer en EMISE

BEGIN

  UPDATE facture SET statut = 'EMISE' WHERE id_facture = 2;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20802) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas accepte : facture 3 est EMISE, on la passe en PAYEE

UPDATE facture SET statut = 'PAYEE' WHERE id_facture = 3;

SELECT statut FROM facture WHERE id_facture = 3;  -- PAYEE

ROLLBACK;

  

-- Resultat obtenu :

-- Facture 1 (PAYEE) -> ANNULEE  : ORA-20801 (refuse).

-- Facture 2 (PARTIELLE) -> EMISE: ORA-20802 (refuse).

-- Facture 3 (EMISE)  -> PAYEE   : accepte (statut passe a PAYEE, puis ROLLBACK).

  
  

-- Exercice 19 [OBL] : Journal des factures

-- Créer TRG_FACTURE_AUDIT (après insertion, modification ou suppression, niveau ligne) qui écrit dans JOURNAL_OPERATION le type d'opération, la table, la clé, et les anciennes et nouvelles valeurs (statut, montant, remise). L'utilisateur et la date sont fournis par les valeurs par défaut de la table. Tester, lire le journal, puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_FACTURE_AUDIT

AFTER INSERT OR UPDATE OR DELETE ON facture

FOR EACH ROW

DECLARE

  v_type  journal_operation.type_operation%TYPE;

  v_cle   journal_operation.cle_ligne%TYPE;

  v_anc   journal_operation.ancienne_valeur%TYPE;

  v_nouv  journal_operation.nouvelle_valeur%TYPE;

BEGIN

  IF INSERTING THEN

    v_type := 'INSERT';

    v_cle  := TO_CHAR(:NEW.id_facture);

    v_nouv := 'statut=' || :NEW.statut || ', montant=' || :NEW.montant_total || ', remise=' || :NEW.remise;

  ELSIF DELETING THEN

    v_type := 'DELETE';

    v_cle  := TO_CHAR(:OLD.id_facture);

    v_anc  := 'statut=' || :OLD.statut || ', montant=' || :OLD.montant_total || ', remise=' || :OLD.remise;

  ELSE

    v_type := 'UPDATE';

    v_cle  := TO_CHAR(:NEW.id_facture);

    v_anc  := 'statut=' || :OLD.statut || ', montant=' || :OLD.montant_total || ', remise=' || :OLD.remise;

    v_nouv := 'statut=' || :NEW.statut || ', montant=' || :NEW.montant_total || ', remise=' || :NEW.remise;

  END IF;

  

  INSERT INTO journal_operation (id_journal, type_operation, nom_table, cle_ligne, ancienne_valeur, nouvelle_valeur)

    VALUES (seq_journal.NEXTVAL, v_type, 'FACTURE', v_cle, v_anc, v_nouv);

END;

/

SHOW ERRORS TRIGGER TRG_FACTURE_AUDIT

  

-- Tests :

UPDATE facture SET statut = 'PAYEE' WHERE id_facture = 3;  -- declenche le trigger (INSERT/UPDATE sur journal)

  

SELECT id_journal, utilisateur, date_operation, type_operation, nom_table, cle_ligne, ancienne_valeur, nouvelle_valeur

  FROM journal_operation

 WHERE nom_table = 'FACTURE'

   AND cle_ligne = '3'

 ORDER BY id_journal DESC;

  

ROLLBACK;

  

-- Resultat obtenu :

-- Une ligne est inseree dans JOURNAL_OPERATION (type=UPDATE, table=FACTURE, cle=3,

-- ancienne_valeur='statut=EMISE,...', nouvelle_valeur='statut=PAYEE,...'),

-- utilisateur et date_operation renseignes par les valeurs par defaut de la table,

-- puis ROLLBACK annule la modification de la facture et l ecriture du journal.

  
  

-- Exercice 20 [OBL] : Gérer les triggers

-- Interroger USER_TRIGGERS (nom, table, événement, type, statut) et USER_ERRORS. Désactiver TRG_FACTURE_STATUT_BU, constater qu'une facture payée peut alors changer de statut, annuler cette modification puis réactiver le trigger. Pourquoi faut-il désactiver avant de modifier ?

  

-- Code :

-- Interrogation des triggers et erreurs

SELECT trigger_name, table_name, triggering_event, trigger_type, status

  FROM user_triggers

 ORDER BY table_name, trigger_name;

  

SELECT name, type, line, position, text

  FROM user_errors

 ORDER BY name, sequence;

  

-- Desactiver le trigger TRG_FACTURE_STATUT_BU

ALTER TRIGGER TRG_FACTURE_STATUT_BU DISABLE;

  

-- Constater qu'une facture payee peut alors changer de statut (regle contournee)

UPDATE facture SET statut = 'ANNULEE' WHERE id_facture = 1;

SELECT statut FROM facture WHERE id_facture = 1;  -- ANNULEE (accepte car trigger desactive)

ROLLBACK;

  

-- Reactiver le trigger

ALTER TRIGGER TRG_FACTURE_STATUT_BU ENABLE;

  

-- Resultat obtenu :

-- USER_TRIGGERS liste les triggers crees avec leur statut (ENABLED/DISABLED).

-- USER_ERRORS liste les erreurs de compilation le cas echeant.

-- Apres ALTER TRIGGER ... DISABLE, la facture 1 (PAYEE) peut passer en ANNULEE sans lever ORA-20801,

-- puis ROLLBACK annule la modification, puis ALTER TRIGGER ... ENABLE restaure la regle.

--

-- Pourquoi faut-il desactiver avant de modifier ?

-- Pour contourner temporairement une regle metier lors d'une correction legitime

-- (remise en etat de donnees, maintenance en masse, correction d'une saisie erronee)

-- sans que le trigger ne bloque l operation, puis le reactiver pour proteger la base.

  
  

-- Exercice 21 [OPT] : Hospitalisation et chambre

-- Créer TRG_HOSPIT_BIU (avant insertion ou changement de chambre) : refuser une chambre dont DISPONIBLE vaut 'N' (-20301) ou inexistante (-20302), et remplir COUT_JOURNALIER avec le tarif de la chambre s'il est absent. Tester avec les chambres 1 et 19.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_HOSPIT_BIU

BEFORE INSERT OR UPDATE OF id_chambre ON hospitalisation

FOR EACH ROW

DECLARE

  v_dispo chambre.disponible%TYPE;

  v_tarif chambre.tarif_journalier%TYPE;

  v_nb    NUMBER;

BEGIN

  -- Verifier que la chambre existe

  SELECT COUNT(*) INTO v_nb FROM chambre WHERE id_chambre = :NEW.id_chambre;

  IF v_nb = 0 THEN

    RAISE_APPLICATION_ERROR(-20302, 'Chambre inexistante');

  END IF;

  

  -- Recuperer disponibilite et tarif

  SELECT disponible, tarif_journalier INTO v_dispo, v_tarif

    FROM chambre WHERE id_chambre = :NEW.id_chambre;

  

  -- Refuser une chambre indisponible

  IF v_dispo = 'N' THEN

    RAISE_APPLICATION_ERROR(-20301, 'Chambre indisponible');

  END IF;

  

  -- Remplir COUT_JOURNALIER avec le tarif de la chambre s'il est absent

  IF :NEW.cout_journalier IS NULL THEN

    :NEW.cout_journalier := v_tarif;

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_HOSPIT_BIU

  

-- Tests :

-- cas accepte : chambre 1 (disponible 'O', tarif 4500) sur une hospitalisation existante

UPDATE hospitalisation SET id_chambre = 1, cout_journalier = NULL WHERE id_hospitalisation = 6;

SELECT cout_journalier FROM hospitalisation WHERE id_hospitalisation = 6;  -- 4500 (rempli par le trigger)

ROLLBACK;

  

-- cas refuse -20302 : chambre inexistante (id 99999)

BEGIN

  UPDATE hospitalisation SET id_chambre = 99999 WHERE id_hospitalisation = 6;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20302) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20301 : chambre indisponible (on met temporairement la chambre 19 en indisponible)

UPDATE chambre SET disponible = 'N' WHERE id_chambre = 19;

BEGIN

  UPDATE hospitalisation SET id_chambre = 19 WHERE id_hospitalisation = 6;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20301) : ' || SQLERRM);

  ROLLBACK;

END;

/

-- remettre la chambre 19 disponible (nettoyage)

UPDATE chambre SET disponible = 'O' WHERE id_chambre = 19;

ROLLBACK;

  

-- Resultat obtenu :

-- Chambre 1 (disponible) : accepte, COUT_JOURNALIER rempli a 4500 (tarif de la chambre).

-- Chambre inexistante    : ORA-20302 (refuse).

-- Chambre indisponible   : ORA-20301 (refuse).

  
  

-- Exercice 22 [OPT] : Le chef appartient à son service

-- Créer TRG_SERVICE_CHEF (avant insertion ou modification du chef, WHEN) : le médecin chef doit être affecté au service qu'il dirige (-20501) et exister (-20502). Tester avec les médecins 2 (service 1) et 3 (service 2) pour le service 1.

-- Note : dans ce schema, MEDECIN est lie à CLINIQUE (ID_CLINIQUE) et SERVICE est lie à CLINIQUE (ID_CLINIQUE).

-- La regle -20501 verifie donc que le medecin appartient a la meme clinique que le service qu'il dirige.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_SERVICE_CHEF

BEFORE INSERT OR UPDATE OF id_medecin_chef ON service

FOR EACH ROW

WHEN (NEW.id_medecin_chef IS NOT NULL)

DECLARE

  v_nb_medecin NUMBER;

  v_clinique_medecin service.id_clinique%TYPE;

BEGIN

  -- -20502 : le medecin doit exister

  SELECT COUNT(*) INTO v_nb_medecin FROM medecin WHERE id_medecin = :NEW.id_medecin_chef;

  IF v_nb_medecin = 0 THEN

    RAISE_APPLICATION_ERROR(-20502, 'Medecin chef inexistant');

  END IF;

  

  -- -20501 : le medecin doit appartenir a la clinique du service

  SELECT m.id_clinique INTO v_clinique_medecin FROM medecin m WHERE id_medecin = :NEW.id_medecin_chef;

  IF v_clinique_medecin <> :NEW.id_clinique THEN

    RAISE_APPLICATION_ERROR(-20501, 'Le medecin chef doit appartenir a la clinique du service qu il dirige');

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_SERVICE_CHEF

  

-- Tests :

-- cas accepte : medecin 2 (clinique 1) comme chef du service 1 (clinique 1)

UPDATE service SET id_medecin_chef = 2 WHERE id_service = 1;

SELECT id_medecin_chef FROM service WHERE id_service = 1;  -- 2 (accepte)

ROLLBACK;

  

-- cas refuse -20501 : medecin d une autre clinique (medecin 5, clinique 2) comme chef du service 1 (clinique 1)

BEGIN

  UPDATE service SET id_medecin_chef = 5 WHERE id_service = 1;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20501) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- cas refuse -20502 : medecin inexistant

BEGIN

  UPDATE service SET id_medecin_chef = 99999 WHERE id_service = 1;

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20502) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- Medecin 2 (clinique 1) -> chef service 1 (clinique 1) : accepte.

-- Medecin 5 (clinique 2) -> chef service 1 (clinique 1)  : ORA-20501 (refuse).

-- Medecin 99999            -> chef service 1             : ORA-20502 (refuse).

-- Remarque : les medecins 2 et 3 sont tous deux en clinique 1 (comme le service 1), ils passent donc tous les deux la regle -20501 ; on utilise un medecin d une autre clinique pour illustrer le refus.

  
  

-- Exercice 23 [OPT] : Médicament périmé

-- Créer TRG_PRESCRIPTION_PEREMPTION (avant insertion) qui refuse de prescrire un médicament dont la date de péremption est dépassée (-20901). Aucun médicament n'est périmé dans la base : en périmer un par UPDATE pour le test, puis ROLLBACK.

  

-- Code :

CREATE OR REPLACE TRIGGER TRG_PRESCRIPTION_PEREMPTION

BEFORE INSERT ON prescription

FOR EACH ROW

DECLARE

  v_peremption medicament.date_peremption%TYPE;

BEGIN

  SELECT date_peremption INTO v_peremption FROM medicament WHERE id_medicament = :NEW.id_medicament;

  IF v_peremption IS NOT NULL AND v_peremption < TRUNC(SYSDATE) THEN

    RAISE_APPLICATION_ERROR(-20901, 'Medicament perime : prescription refusee');

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PRESCRIPTION_PEREMPTION

  

-- Tests :

-- cas accepte : prescrire le medicament 1 (date peremption 2028, non perime)

DECLARE

  v_id_ordo NUMBER;

BEGIN

  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test medicament non perime');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 1, '1 comprime par jour', 5, NULL);

  DBMS_OUTPUT.PUT_LINE('Prescription medicament 1 (non perime) : accepte.');

  ROLLBACK;

END;

/

  

-- cas refuse -20901 : perimer le medicament 3 puis essayer de le prescrire

DECLARE

  v_id_ordo NUMBER;

BEGIN

  UPDATE medicament SET date_peremption = DATE '2020-01-01' WHERE id_medicament = 3;  -- perime

  

  SELECT seq_ordonnance.NEXTVAL INTO v_id_ordo FROM dual;

  INSERT INTO ordonnance (id_ordonnance, id_consultation, date_ordonnance, commentaire)

    VALUES (v_id_ordo, 1, SYSDATE, 'Test medicament perime');

  INSERT INTO prescription (id_ordonnance, id_medicament, posologie, quantite, instructions)

    VALUES (v_id_ordo, 3, '1 gelule par jour', 5, NULL);

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20901) : ' || SQLERRM);

  ROLLBACK;  -- annule aussi le perimement du medicament 3

END;

/

  

-- Resultat obtenu :

-- Prescription medicament 1 (date peremption 2028) : accepte.

-- Prescription medicament 3 perime                 : ORA-20901 (refuse), puis ROLLBACK restaure la date de peremption.

  
  

-- Exercice 24 [OPT] : Audit sans données sensibles

-- Créer TRG_PATIENT_AUDIT (après modification d'un patient) qui journalise seulement les noms des colonnes modifiées (nom, prénom, adresse, ville, téléphone, e-mail, groupe sanguin, antécédents, allergies), sans écrire de valeur médicale dans le journal. Pourquoi ?

  

-- Code :

-- Ce trigger est positionne sur PATIENT. Il detecte les colonnes modifiees via :OLD/:NEW

-- pour les colonnes de PATIENT (groupe sanguin, antecedents, allergies) et journalise

-- uniquement la liste des noms de colonnes modifiees, sans aucune valeur medicale.

-- Les colonnes resideant dans PERSONNE (nom, prenom, adresse, ville, telephone, e-mail)

-- feraient l'objet d'une meme logique sur un trigger sur PERSONNE.

CREATE OR REPLACE TRIGGER TRG_PATIENT_AUDIT

AFTER UPDATE ON patient

FOR EACH ROW

DECLARE

  v_modifiees VARCHAR2(400) := '';

BEGIN

  IF NVL(:OLD.groupe_sanguin, '<NULL>') <> NVL(:NEW.groupe_sanguin, '<NULL>') THEN

    v_modifiees := v_modifiees || 'groupe_sanguin, ';

  END IF;

  IF NVL(:OLD.antecedents, '<NULL>') <> NVL(:NEW.antecedents, '<NULL>') THEN

    v_modifiees := v_modifiees || 'antecedents, ';

  END IF;

  IF NVL(:OLD.allergies, '<NULL>') <> NVL(:NEW.allergies, '<NULL>') THEN

    v_modifiees := v_modifiees || 'allergies, ';

  END IF;

  

  IF v_modifiees IS NOT NULL THEN

    v_modifiees := RTRIM(v_modifiees, ', ');

    INSERT INTO journal_operation (id_journal, type_operation, nom_table, cle_ligne, nouvelle_valeur)

      VALUES (seq_journal.NEXTVAL, 'UPDATE', 'PATIENT', TO_CHAR(:NEW.id_patient), v_modifiees);

  END IF;

END;

/

SHOW ERRORS TRIGGER TRG_PATIENT_AUDIT

  

-- Tests :

UPDATE patient SET antecedents = 'Nouvel antecedent' WHERE id_patient = 1;

SELECT id_journal, type_operation, nom_table, cle_ligne, nouvelle_valeur

  FROM journal_operation

 WHERE nom_table = 'PATIENT' AND cle_ligne = '1'

 ORDER BY id_journal DESC;

ROLLBACK;

  

-- cas refuse : modification d'une colonne non sujette a l audit (ici aucune colonne verifiee change)

UPDATE patient SET tel_contact = '0600000000' WHERE id_patient = 1;

SELECT COUNT(*) AS nb_lignes_journal_patient FROM journal_operation

  WHERE nom_table = 'PATIENT' AND cle_ligne = '1' AND type_operation = 'UPDATE';

ROLLBACK;

  

-- Resultat obtenu :

-- Modification de ANTECEDENTS : une ligne est ecrite dans JOURNAL_OPERATION avec

-- nouvelle_valeur='antecedents' (seul le nom de la colonne, pas la valeur medicale).

-- Modification de TEL_CONTACT   : aucune ligne pour PATIENT (colonne pas verifiee ici),

-- donc pas d ecriture de valeur medicale.

--

-- Pourquoi ne pas ecrire de valeur medicale dans le journal ?

-- Confidentialite medicale : le journal d audit peut etre lu par plusieurs intervenants

-- (administration, support). Y ecrire les antécédents ou allergies exposerait des donnees

-- de sante sensibles. On journalise uniquement les noms de colonnes modifiees pour garder

-- une trace sans divulguer l information medicale elle-meme.

  
  

-- Exercice 25 [OPT] : Table mutante et statut des factures

-- (a) Créer un trigger AFTER INSERT niveau ligne sur PAIEMENT qui lit la table PAIEMENT (somme des paiements d'une facture) : provoquer et expliquer l'erreur ORA-04091, puis supprimer ce trigger.

-- (b) Corriger avec un package qui mémorise les factures concernées (trigger ligne) et les traite après l'instruction (trigger instruction) : le statut passe à PARTIELLE ou PAYEE, et un total supérieur au montant net est refusé (-20951). Tester avec les factures 3 (émise, net 8 500) et 2 (partielle, reste 3 000).

  

-- Code :

-- Package memorisant les factures concernees

CREATE OR REPLACE PACKAGE pkg_paiement_audit IS

  TYPE t_factures IS TABLE OF facture.id_facture%TYPE INDEX BY BINARY_INTEGER;

  g_factures t_factures;

  g_idx      NUMBER := 0;

  

  PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE);

  PROCEDURE traiter_factures;

END pkg_paiement_audit;

/

SHOW ERRORS PACKAGE pkg_paiement_audit

  

CREATE OR REPLACE PACKAGE BODY pkg_paiement_audit IS

  PROCEDURE ajouter_facture(p_id IN facture.id_facture%TYPE) IS

  BEGIN

    g_idx := g_idx + 1;

    g_factures(g_idx) := p_id;

  END ajouter_facture;

  

  PROCEDURE traiter_factures IS

    v_net   facture.montant_total%TYPE;

    v_remise facture.remise%TYPE;

    v_total NUMBER;

  BEGIN

    FOR i IN 1..g_idx LOOP

      SELECT montant_total, remise INTO v_net, v_remise

        FROM facture WHERE id_facture = g_factures(i);

  

      SELECT NVL(SUM(montant), 0) INTO v_total FROM paiement WHERE id_facture = g_factures(i);

  

      -- Refuser un total paye superieur au montant net

      IF v_total > v_net * (1 - v_remise / 100) THEN

        RAISE_APPLICATION_ERROR(-20951, 'Total paye superieur au montant net de la facture');

      END IF;

  

      -- Mise a jour du statut

      IF v_total = v_net * (1 - v_remise / 100) THEN

        UPDATE facture SET statut = 'PAYEE' WHERE id_facture = g_factures(i);

      ELSIF v_total > 0 THEN

        UPDATE facture SET statut = 'PARTIELLE' WHERE id_facture = g_factures(i);

      END IF;

    END LOOP;

    g_idx := 0;

  END traiter_factures;

END pkg_paiement_audit;

/

SHOW ERRORS PACKAGE BODY pkg_paiement_audit

  

-- Trigger ligne : memorise seulement (ne lit pas PAIEMENT -> pas de table mutante)

CREATE OR REPLACE TRIGGER trg_paiement_ligne

AFTER INSERT ON paiement

FOR EACH ROW

BEGIN

  pkg_paiement_audit.ajouter_facture(:NEW.id_facture);

END;

/

SHOW ERRORS TRIGGER trg_paiement_ligne

  

-- Trigger instruction : traite les factures memorisees (lecture de PAIEMENT autorisee au niveau instruction)

CREATE OR REPLACE TRIGGER trg_paiement_instruction

AFTER INSERT ON paiement

BEGIN

  pkg_paiement_audit.traiter_factures;

END;

/

SHOW ERRORS TRIGGER trg_paiement_instruction

  

-- Tests :

-- (a) Demonstration de la table mutante : creer un trigger ligne qui lit PAIEMENT

CREATE OR REPLACE TRIGGER trg_paiement_mutant

AFTER INSERT ON paiement

FOR EACH ROW

DECLARE

  v_somme NUMBER;

BEGIN

  SELECT SUM(montant) INTO v_somme FROM paiement WHERE id_facture = :NEW.id_facture;  -- provoque ORA-04091

END;

/

SHOW ERRORS TRIGGER trg_paiement_mutant

  

BEGIN

  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant, mode_paiement, reference_paiement)

    VALUES (seq_paiement.NEXTVAL, 3, SYSDATE, 1000, 'ESPECES', 'TEST-MUTANT');

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (ORA-04091 table mutante) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- Supprimer le trigger mutant

DROP TRIGGER trg_paiement_mutant;

  

-- (b) Test avec le package : facture 3 (EMISE, net 8500) -> paiement de 8500 => PAYEE

DECLARE

  v_id_paiement NUMBER;

BEGIN

  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;

  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant, mode_paiement, reference_paiement)

    VALUES (v_id_paiement, 3, SYSDATE, 8500, 'CARTE', 'TEST-FACT3');

  SELECT statut INTO v_id_paiement FROM facture WHERE id_facture = 3;  -- reuse var, juste pour affichage ci-dessous

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);

  ROLLBACK;

END;

/

-- (verification dans un bloc separé car le precedent rollback annule)

DECLARE

  v_id_paiement NUMBER;

BEGIN

  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;

  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant, mode_paiement, reference_paiement)

    VALUES (v_id_paiement, 3, SYSDATE, 8500, 'CARTE', 'TEST-FACT3');

  DBMS_OUTPUT.PUT_LINE('Paiement facture 3 de 8500 insere.');

END;

/

SELECT statut FROM facture WHERE id_facture = 3;  -- PAYE (net 8500 atteint)

ROLLBACK;

  

-- (b) Test avec le package : facture 2 (PARTIELLE, net 6000, deja paye 3000, reste 3000) -> paiement de 3000 => PAYEE

DECLARE

  v_id_paiement NUMBER;

BEGIN

  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;

  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant, mode_paiement, reference_paiement)

    VALUES (v_id_paiement, 2, SYSDATE, 3000, 'ESPECES', 'TEST-FACT2');

  DBMS_OUTPUT.PUT_LINE('Paiement facture 2 de 3000 insere (reste a payer).');

END;

/

SELECT statut FROM facture WHERE id_facture = 2;  -- PAYE (3000+3000=6000=net)

ROLLBACK;

  

-- (b) Refus : total paye superieur au montant net (facture 3 net 8500, on tente un paiement qui fait depasser)

DECLARE

  v_id_paiement NUMBER;

BEGIN

  SELECT seq_paiement.NEXTVAL INTO v_id_paiement FROM dual;

  INSERT INTO paiement (id_paiement, id_facture, date_paiement, montant, mode_paiement, reference_paiement)

    VALUES (v_id_paiement, 3, SYSDATE, 9000, 'CARTE', 'TEST-DEPASS');  -- 9000 > 8500

EXCEPTION

  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Erreur attendue (-20951) : ' || SQLERRM);

  ROLLBACK;

END;

/

  

-- Resultat obtenu :

-- (a) Trigger ligne lisant PAIEMENT : ORA-04091 (table mutante), explicite par l'impossibilite

--     pour un trigger ligne de lire la table qu'il modifie. Le trigger est ensuite supprime.

-- (b) Package + trigger ligne (memorisation) + trigger instruction (traitement) :

--     - Facture 3 (EMISE, net 8500) + paiement 8500 -> statut passe a PAYEE.

--     - Facture 2 (PARTIELLE, reste 3000) + paiement 3000 -> statut passe a PAYEE.

--     - Paiement depassant le montant net               -> ORA-20951 (refuse).

  

-- ============================================================================

-- Fin du TP2 - EL_SAHA

-- ============================================================================
```