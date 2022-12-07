CREATE DATABASE dnd;
\c dnd

CREATE TABLE Player (
    ID INT PRIMARY KEY,
    name VARCHAR(30),
    specie VARCHAR(8),
    strength INT,
    magic INT
);

CREATE TABLE Place (
    ID INT PRIMARY KEY,
    name VARCHAR(30),
    biome VARCHAR(8)
);

CREATE TABLE Spell (
    ID INT PRIMARY KEY,
    name VARCHAR(30),
    level INT,
    duration VARCHAR(20),
    focus BOOLEAN,
    ritual BOOLEAN
);

CREATE TABLE PlayerKnowsSpell (
    Player_ID INT,
    Spell_ID INT,
    mastery INT,
    PRIMARY KEY (Player_ID, Spell_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Spell_ID)  REFERENCES Spell(ID)
);

CREATE TABLE PlayerVisitedPlace (
    Player_ID INT,
    Spell_ID INT,
    number_of_visits INT,
    PRIMARY KEY (Player_ID, Spell_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Spell_ID) REFERENCES Spell(ID)
);

CREATE TABLE PlayerComesFrom (
    Player_ID INT,
    Place_ID INT,
    PRIMARY KEY (Player_ID, Place_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Place_ID) REFERENCES Player(ID)
);

CREATE TABLE CompanionOf (
    Player_ID INT,
    Companion_ID INT,
    years_together INT,
    campaigns_together INT,
    PRIMARY KEY (Player_ID, Companion_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Companion_ID) REFERENCES Player(ID)
);


