from os import getcwd

# This file generates the correct copy query for the current directory.
# It is mandatory to update it for every system, because psql's COPY queries
# don't support relative addresses.
# This program updates the `load_database_contents.sql` file with the correct
# absolute path for the tsv files

DATA = """
\c dnd

 -- replace with whatever is your own file
\cd {CWD}

COPY Player
FROM '{CWD}/output/player.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY Place
FROM '{CWD}/output/place.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY Spell
FROM '{CWD}/output/spells.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY PlayerComesFrom
FROM '{CWD}/output/player_comes_from.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY PlayerVisitedPlace
FROM '{CWD}/output/player_visited_place.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY PlayerKnowsSpell
FROM '{CWD}/output/player_knows_spell.tsv'
DELIMITER E'\\t'
CSV HEADER;

COPY CompanionOf
FROM '{CWD}/output/companion_of.tsv'
DELIMITER E'\\t'
CSV HEADER;
""".format(
        CWD=getcwd()
        )

print(DATA, file=open("load_database_contents.sql", 'w'))



