1.
SELECT nom, prenom
FROM etudiant
-- LEFT: afficher les étudiants même sans inscription
LEFT JOIN inscription ON inscription.num_etud = etudiant.num_etud
WHERE id_cours IS NULL
ORDER BY nom

2.
SELECT COUNT(*) AS nb_stud
FROM etudiant

3.
WITH moyennes_cours_semestre1 AS (
    SELECT num_etud, cours.id_cours, intitule, SUM(valeur*coefficient)/SUM(coefficient) AS moy_cours_1, credit
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    WHERE (MONTH(date_exam) BETWEEN 9 AND 12) OR (MONTH(date_exam) = 1) /*semestre 1: septembre à janvier*/
    GROUP BY num_etud, id_cours /*moyenne de chaque etudiant pour chaque cours*/
),

moyennes_cours_semestre2 AS (
	SELECT num_etud, cours.id_cours, intitule, SUM(valeur*coefficient)/SUM(coefficient) AS moy_cours_2, credit
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    WHERE MONTH(date_exam) BETWEEN 2 AND 6 /*semestre 2: février à juin*/
    GROUP BY num_etud, id_cours /*moyenne de chaque etudiant pour chaque cours*/
),

moyenne_generale_semestre1 AS (
    SELECT num_etud, SUM(moy_cours_1*credit)/SUM(credit) AS moy_generale_1
    FROM moyennes_cours_semestre1
    GROUP BY num_etud /*moyenne générale pour chaque étudiant*/
),

moyenne_generale_semestre2 AS (
    SELECT num_etud, SUM(moy_cours_2*credit)/SUM(credit) AS moy_generale_2
    FROM moyennes_cours_semestre2
    GROUP BY num_etud /*moyenne générale pour chaque étudiant*/
)

SELECT M1.num_etud, moy_generale_1, moy_generale_2
FROM moyenne_generale_semestre1 M1
JOIN moyenne_generale_semestre2 M2 ON M2.num_etud = M1.num_etud
WHERE moy_generale_2 > moy_generale_1
GROUP BY num_etud

4.
-- table temporaire moyennes_cours
WITH moyennes_cours AS (
    SELECT num_etud, cours.id_cours, intitule, SUM(valeur*coefficient)/SUM(coefficient) AS moy_cours, credit
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    GROUP BY num_etud, id_cours /*moyenne de chaque etudiant pour chaque cours*/
)

SELECT AVG(moy_cours), intitule
FROM moyennes_cours
GROUP BY intitule
ORDER BY intitule

5.
SELECT enseignant.*, GROUP_CONCAT(examen.nom)
FROM enseignant
JOIN encadre ON encadre.num_ens = enseignant.num_ens
JOIN examen ON examen.id_exam = encadre.id_exam
GROUP BY enseignant.nom

6.
SELECT COUNT(id_exam) AS nb_exam, intitule
FROM examen
JOIN cours ON examen.id_cours = cours.id_cours
GROUP BY intitule
ORDER BY nb_exam DESC

7.
SELECT
    CASE 
    -- TIMESTAMPDIFF: la différence ( CURDATE() - dateNaissance ) est en YEAR
        WHEN TIMESTAMPDIFF(YEAR, dateNaissance, CURDATE()) < 20 THEN 'Moins de 20 ans'
        WHEN TIMESTAMPDIFF(YEAR, dateNaissance, CURDATE()) BETWEEN 20 AND 30 THEN 'Entre 20 et 30 ans'
        ELSE 'Plus de 30 ans'
    END AS tranche_age,
    COUNT(*) AS nb_etudiants
FROM Etudiant
GROUP BY tranche_age;

8.
-- table temporaire moyennes_cours
WITH moyennes_cours AS (
    SELECT num_etud, cours.id_cours, SUM(valeur * coefficient)/SUM(coefficient) AS moy_cours, credit
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    GROUP BY num_etud, id_cours /*moyenne de chaque etudiant pour chaque cours*/
),

-- table temporaire moyenne_generale
moyenne_generale AS (
    SELECT num_etud, SUM(moy_cours*credit)/SUM(credit) AS moy_generale
    FROM moyennes_cours
    GROUP BY num_etud /*moyenne générale pour chaque étudiant*/
)

-- requête
SELECT etudiant.num_etud, nom, prenom, moy_generale
FROM moyenne_generale
JOIN etudiant ON etudiant.num_etud = moyenne_generale.num_etud
WHERE moy_generale > 15
ORDER BY nom

9.
SELECT enseignant.num_ens, nom, prenom
FROM enseignant
LEFT JOIN enseigne ON enseigne.num_ens = enseignant.num_ens
WHERE enseigne.id_cours IS NULL
ORDER BY nom

10.
SELECT cours.*
FROM cours
JOIN enseigne ON enseigne.id_cours = cours.id_cours
JOIN enseignant ON enseignant.num_ens = enseigne.num_ens
WHERE enseignant.nom = 'Giraud';

11.
SELECT cours.id_cours, intitule, COUNT(num_etud) AS total_inscriptions
FROM inscription
LEFT JOIN cours ON cours.id_cours = inscription.id_cours
WHERE statut = 'validé'
GROUP BY intitule
ORDER BY total_inscriptions DESC;

12.
SELECT examen.id_exam, etudiant.nom, etudiant.prenom, MAX(valeur) AS meilleur_note
FROM note
JOIN examen ON examen.id_exam = note.id_exam
JOIN etudiant ON etudiant.num_etud = note.num_etud
GROUP BY examen.id_exam /*meilleur note pour chaque examen*/
ORDER BY examen.id_exam

13.
SELECT *
FROM Inscription
WHERE date_inscription > '2024-09-11'
ORDER BY date_inscription

14.
WITH nombre_inscriptions AS (
    SELECT num_etud, COUNT(*) AS nbr_inscriptions
    FROM inscription
    GROUP BY num_etud
)

SELECT AVG(nbr_inscriptions) AS moy
FROM nombre_inscriptions

15.
SELECT inscription.*
FROM inscription
JOIN etudiant ON etudiant.num_etud = inscription.num_etud
WHERE nom = 'Dupont' AND prenom = 'Marie';

16.
SELECT etudiant.num_etud, nom, prenom
FROM etudiant
JOIN inscription ON inscription.num_etud = etudiant.num_etud
JOIN cours ON cours.id_cours = inscription.id_cours
WHERE intitule = 'Programmation 1'
ORDER BY nom

17.
SELECT MONTH(date_inscription) AS mois, COUNT(*) AS nb_inscriptions
FROM inscription
WHERE YEAR(date_inscription) = 2024 AND statut = 'validé'
GROUP BY mois
ORDER BY mois;

18.
SELECT etudiant.num_etud, etudiant.nom, prenom, intitule, SUM(valeur * coefficient)/SUM(coefficient) AS moy_cours
FROM note
JOIN etudiant ON etudiant.num_etud = note.num_etud
JOIN examen ON examen.id_exam = note.id_exam
JOIN cours ON cours.id_cours = examen.id_cours
GROUP BY num_etud, intitule /*moy g de CHAQUE etudiant dans CHAQUE cours*/
ORDER BY nom

19.
SELECT num_etud, COUNT(*) AS nb_cours
FROM inscription
WHERE statut = 'validé'
GROUP BY num_etud
HAVING nb_cours > 3;
ORDER BY nb_cours DESC

20.
SELECT enseignant.num_ens, nom, prenom, GROUP_CONCAT(cours.id_cours), GROUP_CONCAT(intitule)
FROM enseignant
JOIN enseigne ON enseigne.num_ens = enseignant.num_ens
JOIN cours ON cours.id_cours = enseigne.id_cours
GROUP BY nom
ORDER BY nom

21.
SELECT *
FROM inscription
WHERE statut = 'annulé'
ORDER BY date_inscription DESC;

22.
SELECT enseignant.num_ens, nom, prenom, COUNT(id_cours) AS nb_cours
FROM enseignant
JOIN enseigne ON enseigne.num_ens = enseignant.num_ens
GROUP BY enseignant.num_ens
ORDER BY nb_cours DESC
LIMIT 1;

23.
SELECT num_etud, nom, prenom, dateNaissance, email
FROM etudiant
ORDER BY nom, prenom;

24.
SELECT cours.id_cours, intitule, COUNT(num_etud) AS total_inscriptions
FROM cours
LEFT JOIN inscription ON cours.id_cours = inscription.id_cours
GROUP BY cours.id_cours
ORDER BY total_inscriptions DESC;

25.
SELECT cours.id_cours, intitule, COUNT(num_etud) AS nb_etudiants
FROM inscription
JOIN cours ON cours.id_cours = inscription.id_cours
WHERE statut = 'validé'
GROUP BY cours.id_cours
HAVING nb_etudiants > 50
ORDER BY nb_etudiants DESC;

26.
WITH moyennes_etudiants AS (
    SELECT num_etud, cours.id_cours, intitule, SUM(valeur*coefficient)/SUM(coefficient) AS moy_cours
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    GROUP BY num_etud, cours.id_cours
)

SELECT 
    id_cours,
    intitule,
    COUNT(*) AS nb_etudiants_total,
    SUM(CASE WHEN moy_cours >= 10 THEN 1 ELSE 0 END) AS nb_reussites,
    ROUND((SUM(CASE WHEN moy_cours >= 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS taux_reussite_pct
FROM moyennes_etudiants
GROUP BY id_cours
ORDER BY taux_reussite_pct DESC;

27.
SELECT 
    YEAR(date_inscription) AS annee,
    MONTH(date_inscription) AS mois,
    COUNT(*) AS nb_inscriptions_annulees
FROM inscription
WHERE statut = 'annulé'
GROUP BY annee, mois
ORDER BY annee DESC, mois DESC;

28.
WITH cours_enseignant AS (
    SELECT id_cours
    FROM enseigne
    JOIN enseignant ON enseigne.num_ens = enseignant.num_ens
    WHERE enseignant.nom = 'Giraud'
),

inscriptions_etudiants AS (
    SELECT num_etud, COUNT(DISTINCT inscription.id_cours) AS nb_cours_inscrits
    FROM inscription
    WHERE id_cours IN (SELECT id_cours FROM cours_enseignant)
    GROUP BY num_etud
)

SELECT etudiant.num_etud, nom, prenom, nb_cours_inscrits
FROM inscriptions_etudiants
JOIN etudiant ON etudiant.num_etud = inscriptions_etudiants.num_etud
WHERE nb_cours_inscrits = (SELECT COUNT(*) FROM cours_enseignant)
ORDER BY nom;

29.
SELECT 
    etudiant.num_etud,
    etudiant.nom AS nom_etudiant,
    etudiant.prenom AS prenom_etudiant,
    cours.intitule,
    enseignant.nom AS nom_enseignant,
    enseignant.prenom AS prenom_enseignant,
    inscription.date_inscription,
    inscription.statut
FROM inscription
JOIN etudiant ON etudiant.num_etud = inscription.num_etud
JOIN cours ON cours.id_cours = inscription.id_cours
JOIN enseigne ON enseigne.id_cours = cours.id_cours
JOIN enseignant ON enseignant.num_ens = enseigne.num_ens
ORDER BY etudiant.nom, etudiant.prenom, cours.intitule;

30.
WITH moyennes_cours AS (
    SELECT cours.id_cours, intitule, SUM(valeur*coefficient)/SUM(coefficient) AS moy_cours
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN cours ON cours.id_cours = examen.id_cours
    GROUP BY num_etud, cours.id_cours
)

SELECT id_cours, intitule, AVG(moy_cours) AS moyenne_generale_cours
FROM moyennes_cours
GROUP BY id_cours
HAVING moyenne_generale_cours < 12
ORDER BY moyenne_generale_cours ASC;

31.
SELECT 
    etudiant.num_etud,
    etudiant.nom,
    etudiant.prenom,
    cours.intitule,
    inscription.date_inscription,
    inscription.statut
FROM inscription
JOIN etudiant ON etudiant.num_etud = inscription.num_etud
JOIN cours ON cours.id_cours = inscription.id_cours
ORDER BY etudiant.nom, etudiant.prenom, inscription.date_inscription;

32.
SELECT DISTINCT etudiant.num_etud, nom, prenom, valeur
FROM etudiant
JOIN note ON etudiant.num_etud = note.num_etud
JOIN examen ON examen.id_exam = note.id_exam
WHERE examen.nom = 'Partiel Algo'
ORDER BY valeur DESC;

33.
SELECT 
    etudiant.nom,
    etudiant.prenom,
    examen.nom AS nom_examen,
    examen.type_exam,
    note.valeur
FROM note
JOIN etudiant ON etudiant.num_etud = note.num_etud
JOIN examen ON examen.id_exam = note.id_exam
JOIN cours ON cours.id_cours = examen.id_cours
WHERE cours.intitule = 'Programmation 1'
ORDER BY etudiant.nom, etudiant.prenom, examen.date_exam;

34.
SELECT examen.*
FROM examen
JOIN cours ON cours.id_cours = examen.id_cours
WHERE cours.intitule = 'Programmation 1'
ORDER BY examen.date_exam;

35.
SELECT 
    cours.id_cours,
    cours.intitule,
    cours.niveau,
    cours.credit,
    enseignant.nom AS nom_enseignant,
    enseignant.prenom AS prenom_enseignant
FROM cours
JOIN enseigne ON enseigne.id_cours = cours.id_cours
JOIN enseignant ON enseignant.num_ens = enseigne.num_ens
ORDER BY cours.intitule;

36.
SELECT 
    enseignant.num_ens,
    enseignant.nom,
    enseignant.prenom,
    COUNT(DISTINCT inscription.num_etud) AS nb_etudiants_total
FROM enseignant
JOIN enseigne ON enseigne.num_ens = enseignant.num_ens
LEFT JOIN inscription ON inscription.id_cours = enseigne.id_cours
WHERE inscription.statut = 'validé' OR inscription.statut IS NULL
GROUP BY enseignant.num_ens
ORDER BY nb_etudiants_total DESC;

37.
SELECT cours.id_cours, intitule, niveau
FROM cours
LEFT JOIN inscription ON cours.id_cours = inscription.id_cours
WHERE inscription.num_etud IS NULL
ORDER BY intitule;

38.
WITH notes_par_enseignant AS (
    SELECT 
        enseignant.num_ens,
        enseignant.nom,
        enseignant.prenom,
        note.valeur,
        examen.coefficient
    FROM note
    JOIN examen ON examen.id_exam = note.id_exam
    JOIN encadre ON encadre.id_exam = examen.id_exam
    JOIN enseignant ON enseignant.num_ens = encadre.num_ens
)

SELECT 
    num_ens,
    nom,
    prenom,
    COUNT(*) AS nb_notes,
    ROUND(SUM(valeur*coefficient)/SUM(coefficient), 2) AS moyenne_notes
FROM notes_par_enseignant
GROUP BY num_ens
ORDER BY moyenne_notes DESC;

39.
SELECT 
    etudiant.num_etud,
    etudiant.nom,
    etudiant.prenom,
    examen.nom AS nom_examen,
    note.valeur
FROM note
JOIN etudiant ON etudiant.num_etud = note.num_etud
JOIN examen ON examen.id_exam = note.id_exam
WHERE examen.nom = 'Partiel Algo' AND note.valeur < 10
ORDER BY note.valeur ASC;

40.
SELECT 
    enseignant.num_ens,
    enseignant.nom,
    enseignant.prenom,
    enseignant.specialite,
    COUNT(enseigne.id_cours) AS nb_cours
FROM enseignant
LEFT JOIN enseigne ON enseigne.num_ens = enseignant.num_ens
GROUP BY enseignant.num_ens
ORDER BY nb_cours DESC;

41.
SELECT cours.*
FROM cours
JOIN enseigne ON enseigne.id_cours = cours.id_cours
JOIN enseignant ON enseignant.num_ens = enseigne.num_ens
WHERE enseignant.nom = 'Giraud'
ORDER BY cours.intitule;