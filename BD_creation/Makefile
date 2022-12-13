# number of players
NUMBER_OF_PLAYERS=1000
# minimum and maximum amount of spells per player (except for french players)
MIN_SPELLS_PER_PLAYER=2
MAX_SPELLS_PER_PLAYER=10
# average percentage of all players that are companions of a giver player
COMPANIONS_PERCENTAGE=10

all: data install


install:
	toilet -f smblock "CREATE DATABASE"
	# DROP ALL TABLES
	toilet -f smbraille "DROP TABLES"
	psql -d dnd -f drop_all_tables.sql
	# CREATE TABLES
	toilet -f smbraille "CREATE TABLES"
	psql -d dnd -f create_database.sql
	# FILL TABLES
	toilet -f smbraille "FILL TABLES"
	python3 generate_database_copy_query.py
	psql -d dnd -f load_database_contents.sql

# phony makes the update work.
# else, make considers that the file is aloready up-to-date
.PHONY: data

data:
	toilet -f smblock "CREATE DATA (.tsv)"
	echo "create the randomized tuples for each relation"
	python3 BD_creation.py \
		--players $(NUMBER_OF_PLAYERS) \
		--spmin $(MIN_SPELLS_PER_PLAYER) \
		--spmax $(MAX_SPELLS_PER_PLAYER) \
		--companions_percentage $(COMPANIONS_PERCENTAGE)


run:
	psql dnd

demo: data install run
