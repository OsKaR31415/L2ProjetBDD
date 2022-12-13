
\c dnd

 -- replace with whatever is your own file
\cd /Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation

COPY Player
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/player.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY Place
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/place.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY Spell
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/spells.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerComesFrom
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/player_comes_from.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerVisitedPlace
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/player_visited_place.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerKnowsSpell
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/player_knows_spell.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY CompanionOf
FROM '/Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/output/companion_of.tsv'
DELIMITER E'\t'
CSV HEADER;

