CREATE DATABASE dnd;
\c dnd


CREATE TABLE Player (
    ID NUMERIC PRIMARY KEY,
    name VARCHAR(30),
    specie VARCHAR(8),
    strength INT,
    magic INT
);

CREATE TABLE Place (
    ID NUMERIC PRIMARY KEY,
    name VARCHAR(30),
    biome VARCHAR(8)
);

CREATE TABLE Spell (
    ID NUMERIC PRIMARY KEY,
    name VARCHAR(50),
    level INT,
    duration VARCHAR(20),
    focus BOOLEAN,
    ritual BOOLEAN
);

CREATE TABLE PlayerKnowsSpell (
    Player_ID NUMERIC,
    Spell_ID NUMERIC,
    mastery INT,
    PRIMARY KEY (Player_ID, Spell_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Spell_ID)  REFERENCES Spell(ID)
);

CREATE TABLE PlayerVisitedPlace (
    Player_ID NUMERIC,
    Place_ID NUMERIC,
    number_of_visits INT,
    PRIMARY KEY (Player_ID, Spell_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Place_ID) REFERENCES Place(ID),
);

CREATE TABLE PlayerComesFrom (
    Player_ID NUMERIC,
    Place_ID NUMERIC,
    PRIMARY KEY (Player_ID, Place_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Place_ID) REFERENCES Place(ID)
);

CREATE TABLE CompanionOf (
    Player_ID NUMERIC,
    Companion_ID NUMERIC,
    years_together INT,
    campaigns_together INT,
    PRIMARY KEY (Player_ID, Companion_ID),
    FOREIGN KEY(Player_ID) REFERENCES Player(ID),
    FOREIGN KEY(Companion_ID) REFERENCES Player(ID)
);


