\c dnd

 -- replace with whatever is your own file
\cd /Users/oscarplaisant/devoirs/informatique/projets/L2/L2ProjetBDD/BD_creation/

COPY Player
FROM 'output/player.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY Place
FROM 'output/place.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY Spell
FROM 'output/spell.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerComesFrom
FROM 'output/player_comes_from.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerVisitedPlace
FROM 'output/player_visited_place.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY PlayerKnowsSpell
FROM 'output/player_knows_spell.tsv'
DELIMITER E'\t'
CSV HEADER;

COPY CompanionOf
FROM 'output/companion_of.tsv'
DELIMITER E'\t'
CSV HEADER;

