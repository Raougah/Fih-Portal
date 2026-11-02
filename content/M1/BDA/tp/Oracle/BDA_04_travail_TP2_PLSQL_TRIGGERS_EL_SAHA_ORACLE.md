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

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 2 [OBL] : Fiche patient

-- Écrire un bloc qui reçoit l'identifiant d'un patient et affiche son nom, son prénom, son groupe sanguin et sa ville. Traiter le patient inexistant.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 3 [OBL] : Âge et catégorie

-- Calculer l'âge d'un patient en années entières (MONTHS_BETWEEN, sans diviser par 365) et afficher sa catégorie : mineur (moins de 18 ans), adulte (18 à 59 ans) ou senior (60 ans et plus).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 4 [OBL] : SELECT INTO : 0, 1, n lignes

-- Rechercher un patient avec SELECT ... INTO, d'abord par son nom (essayer un nom absent puis un nom existant), puis par sa ville. Expliquer NO_DATA_FOUND et TOO_MANY_ROWS.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 5 [OPT] : Vendredi ou samedi

-- Vérifier si une date tombe un vendredi ou un samedi, sans dépendre de la langue de la session (TRUNC(d) - TRUNC(d,'IW') : lundi vaut 0, vendredi 4, samedi 5).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- ============================================================

-- B. Curseurs

-- ============================================================

  

-- Exercice 6 [OBL] : Curseur FOR

-- À l'aide d'une boucle FOR sur une requête, afficher chaque patient avec son nombre de consultations, y compris les patients sans consultation.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 7 [OBL] : Curseur paramétré

-- Créer un curseur paramétré qui affiche les consultations des médecins d'un service entre deux dates (paramètres : service, date de début, date de fin).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 8 [OPT] : OPEN, FETCH, CLOSE

-- Parcourir à la main (OPEN, FETCH, CLOSE) les médicaments dont le stock est sous le seuil d'alerte et afficher leur nombre avec %ROWCOUNT.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- ============================================================

-- C. Procédures, fonctions et transactions

-- ============================================================

  

-- Exercice 9 [OBL] : P_RESUME_PATIENT

-- Créer P_RESUME_PATIENT(p_id_patient) qui affiche l'identité du patient, son nombre de rendez-vous, de consultations et d'hospitalisations ; traiter le patient inexistant.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 10 [OBL] : F_RESTE_FACTURE

-- Créer F_RESTE_FACTURE(p_id_facture) qui retourne le montant restant à payer, c'est-à-dire le montant total diminué de la remise (en pourcentage) puis du total déjà payé. Lever l'erreur -20101 si la facture n'existe pas. Vérifier avec les factures 2 et 20.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 11 [OBL] : P_AJOUTER_PATIENT

-- Créer P_AJOUTER_PATIENT (nom, prénom, date de naissance, sexe, adresse électronique, numéro de sécurité sociale, identifiant en sortie) : utiliser SEQ_PATIENT, refuser une adresse électronique ou un numéro déjà utilisés (erreurs -20111 et -20112). Tester un ajout, un doublon, puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 12 [OBL] : SAVEPOINT

-- Modifier le stock de plusieurs médicaments dans un même bloc, provoquer volontairement une erreur (stock négatif), puis annuler seulement la partie incorrecte avec un SAVEPOINT. Vérifier les stocks avant, pendant et après, puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- ============================================================

-- D. Triggers

-- ============================================================

  

-- Exercice 13 [OBL] : Normaliser les patients

-- Créer TRG_PATIENT_BIU (avant insertion ou modification, niveau ligne) : nom en majuscules, prénom avec une majuscule initiale, adresse électronique en minuscules, sans espaces superflus. Tester avec un patient saisi en désordre, puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 14 [OBL] : Règles des rendez-vous

-- Créer TRG_RDV_BIU (avant insertion ou modification, niveau ligne) : refuser une date passée à l'insertion ou lorsque la date change (-20201), une heure qui n'est pas de la forme HH:MM valide (-20202), le changement de statut d'un rendez-vous clos ANNULE, REALISE ou ABSENT (-20203) et le retour de CONFIRME à PLANIFIE (-20204). Une modification qui ne change pas la date ne doit pas être refusée.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 15 [OBL] : Cohérence consultation et rendez-vous

-- La consultation répète le patient et le médecin du rendez-vous. Créer TRG_CONSULT_BI (avant insertion, seulement si ID_RDV est renseigné, clause WHEN) : refuser un patient ou un médecin différents de ceux du rendez-vous (-20401), un rendez-vous ANNULE (-20402) et un rendez-vous inexistant (-20403).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 16 [OBL] : Consultation réalisée

-- Créer TRG_CONSULT_AI (après insertion d'une consultation liée à un rendez-vous, niveau ligne) qui passe le rendez-vous à REALISE s'il était PLANIFIE ou CONFIRME. Tester avec le rendez-vous 81 (patient 17, médecin 6), puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 17 [OBL] : Stock et prescriptions

-- Créer TRG_PRESCRIPTION_STOCK (avant insertion, modification ou suppression d'une prescription, niveau ligne) qui diminue le stock du médicament de la quantité prescrite, le rétablit en cas de suppression, gère le changement de médicament ou de quantité, et refuse un stock insuffisant (-20701). Tester avec les médicaments 1 (stock 250) et 3 (stock 6), puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 18 [OBL] : Statut des factures

-- Créer TRG_FACTURE_STATUT_BU (avant modification du statut, niveau ligne) : une facture PAYEE ou ANNULEE ne change plus de statut (-20801) et une facture PARTIELLE ne revient pas à EMISE (-20802). Tester avec les factures 1 (payée), 2 (partielle) et 3 (émise).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 19 [OBL] : Journal des factures

-- Créer TRG_FACTURE_AUDIT (après insertion, modification ou suppression, niveau ligne) qui écrit dans JOURNAL_OPERATION le type d'opération, la table, la clé, et les anciennes et nouvelles valeurs (statut, montant, remise). L'utilisateur et la date sont fournis par les valeurs par défaut de la table. Tester, lire le journal, puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 20 [OBL] : Gérer les triggers

-- Interroger USER_TRIGGERS (nom, table, événement, type, statut) et USER_ERRORS. Désactiver TRG_FACTURE_STATUT_BU, constater qu'une facture payée peut alors changer de statut, annuler cette modification puis réactiver le trigger. Pourquoi faut-il désactiver avant de modifier ?

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 21 [OPT] : Hospitalisation et chambre

-- Créer TRG_HOSPIT_BIU (avant insertion ou changement de chambre) : refuser une chambre dont DISPONIBLE vaut 'N' (-20301) ou inexistante (-20302), et remplir COUT_JOURNALIER avec le tarif de la chambre s'il est absent. Tester avec les chambres 1 et 19.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 22 [OPT] : Le chef appartient à son service

-- Créer TRG_SERVICE_CHEF (avant insertion ou modification du chef, WHEN) : le médecin chef doit être affecté au service qu'il dirige (-20501) et exister (-20502). Tester avec les médecins 2 (service 1) et 3 (service 2) pour le service 1.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 23 [OPT] : Médicament périmé

-- Créer TRG_PRESCRIPTION_PEREMPTION (avant insertion) qui refuse de prescrire un médicament dont la date de péremption est dépassée (-20901). Aucun médicament n'est périmé dans la base : en périmer un par UPDATE pour le test, puis ROLLBACK.

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 24 [OPT] : Audit sans données sensibles

-- Créer TRG_PATIENT_AUDIT (après modification d'un patient) qui journalise seulement les noms des colonnes modifiées (nom, prénom, adresse, ville, téléphone, e-mail, groupe sanguin, antécédents, allergies), sans écrire de valeur médicale dans le journal. Pourquoi ?

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :

  
  

-- Exercice 25 [OPT] : Table mutante et statut des factures

-- (a) Créer un trigger AFTER INSERT niveau ligne sur PAIEMENT qui lit la table PAIEMENT (somme des paiements d'une facture) : provoquer et expliquer l'erreur ORA-04091, puis supprimer ce trigger. (b) Corriger avec un package qui mémorise les factures concernées (trigger ligne) et les traite après l'instruction (trigger instruction) : le statut passe à PARTIELLE ou PAYEE, et un total supérieur au montant net est refusé (-20951). Tester avec les factures 3 (émise, net 8 500) et 2 (partielle, reste 3 000).

  

-- Code :

  

-- Tests :

  

-- Resultat obtenu :
```