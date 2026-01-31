CREATE TABLE etudiant (
    num_etud INT PRIMARY KEY,
    nom VARCHAR(45) NOT NULL,
    prenom VARCHAR(45) NOT NULL,
    dateNaissance DATE NOT NULL,
    adresse VARCHAR(70) NOT NULL,
    num_tel VARCHAR(25) NOT NULL,
    email VARCHAR(45) NOT NULL
);

CREATE TABLE enseignant (
    num_ens INT PRIMARY KEY,
    nom VARCHAR(45) NOT NULL,
    prenom VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    num_tel VARCHAR(25) NOT NULL,
    specialite VARCHAR(25) NOT NULL
);

CREATE TABLE cours (
    id_cours INT PRIMARY KEY,
    intitule VARCHAR(45) NOT NULL,
    credit INT NOT NULL,
    niveau VARCHAR(25) NOT NULL,
    nbr_heures INT NOT NULL,
);

CREATE TABLE examen (
    id_exam INT PRIMARY KEY,
	nom VARCHAR(45) NOT NULL,
    date_exam DATE NOT NULL,
    duree INT NOT NULL,
    coefficient DECIMAL(4,2) NOT NULL,
    type_exam VARCHAR(25) NOT NULL,
    salle VARCHAR(25) NOT NULL,
	
    id_cours INT NOT NULL, -- clé étrangère
    FOREIGN KEY (id_cours) REFERENCES Cours(id_cours)
);

CREATE TABLE inscription (
    num_etud INT NOT NULL, -- clé étrangère
    id_cours INT NOT NULL, -- clé étrangère
    date_inscription DATE NOT NULL,
    statut VARCHAR(25) NOT NULL CHECK (statut IN ('validé', 'annulé')),

    FOREIGN KEY (num_etud) REFERENCES Etudiant(num_etud),
    FOREIGN KEY (id_cours) REFERENCES Cours(id_cours)
);

CREATE TABLE note (
    num_etud INT NOT NULL, -- clé étrangère
    id_exam INT NOT NULL, -- clé étrangère
    valeur DECIMAL(4,2) NOT NULL,

    FOREIGN KEY (num_etud) REFERENCES Etudiant(num_etud),
    FOREIGN KEY (id_exam) REFERENCES Examen(id_exam)
);

CREATE TABLE enseigne (
	id_cours INT NOT NULL, -- clé étrangère
	num_ens INT NOT NULL, -- clé étrangère
	FOREIGN KEY (id_cours) REFERENCES Cours(id_cours),
	FOREIGN KEY (num_ens) REFERENCES Enseignant(num_ens)
);

CREATE TABLE encadre (
	num_ens INT NOT NULL, -- clé étrangère
	id_exam INT NOT NULL, -- clé étrangère
	FOREIGN KEY (num_ens) REFERENCES Enseignant(num_ens),
	FOREIGN KEY (id_exam) REFERENCES Examen(id_exam)
);
