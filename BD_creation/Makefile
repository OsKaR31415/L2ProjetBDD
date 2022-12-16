# number of players
NUMBER_OF_PLAYERS=3000
# minimum and maximum amount of spells per player (except for french players)
MIN_SPELLS_PER_PLAYER=2
MAX_SPELLS_PER_PLAYER=10
# average percentage of all players that are companions of a giver player
COMPANIONS_PERCENTAGE=30


all: data update


# run first time to install required dependencies
install:
	python3 -m pip install fantasynames
	# if ! type "psql"; then sudo apt install postgresql; fi



update:
	printf "▞▀▖▛▀▖▛▀▘▞▀▖▀▛▘▛▀▘ ▛▀▖▞▀▖▀▛▘▞▀▖▛▀▖▞▀▖▞▀▖▛▀▘\n▌  ▙▄▘▙▄ ▙▄▌ ▌ ▙▄  ▌ ▌▙▄▌ ▌ ▙▄▌▙▄▘▙▄▌▚▄ ▙▄ \n▌ ▖▌▚ ▌  ▌ ▌ ▌ ▌   ▌ ▌▌ ▌ ▌ ▌ ▌▌ ▌▌ ▌▖ ▌▌  \n▝▀ ▘ ▘▀▀▘▘ ▘ ▘ ▀▀▘ ▀▀ ▘ ▘ ▘ ▘ ▘▀▀ ▘ ▘▝▀ ▀▀▘\n"
	# DROP ALL TABLES
	printf "⡏⢱ ⣏⡱ ⡎⢱ ⣏⡱   ⢹⠁ ⣎⣱ ⣏⡱ ⡇  ⣏⡉ ⢎⡑\n⠧⠜ ⠇⠱ ⠣⠜ ⠇    ⠸  ⠇⠸ ⠧⠜ ⠧⠤ ⠧⠤ ⠢⠜\n"
	psql -d dnd -f drop_all_tables.sql
	# CREATE TABLES
	echo "⡎⠑ ⣏⡱ ⣏⡉ ⣎⣱ ⢹⠁ ⣏⡉   ⢹⠁ ⣎⣱ ⣏⡱ ⡇  ⣏⡉ ⢎⡑\n⠣⠔ ⠇⠱ ⠧⠤ ⠇⠸ ⠸  ⠧⠤   ⠸  ⠇⠸ ⠧⠜ ⠧⠤ ⠧⠤ ⠢⠜\n"
	psql -d dnd -f create_database.sql
	# FILL TABLES
	echo "⣏⡉ ⡇ ⡇  ⡇    ⢹⠁ ⣎⣱ ⣏⡱ ⡇  ⣏⡉ ⢎⡑\n⠇  ⠇ ⠧⠤ ⠧⠤   ⠸  ⠇⠸ ⠧⠜ ⠧⠤ ⠧⠤ ⠢⠜\n"
	python3 generate_database_copy_query.py
	psql -d dnd -f load_database_contents.sql


# phony makes the update work.
# else, make considers that the file is aloready up-to-date
.PHONY: data


data:
	printf "▞▀▖▛▀▖▛▀▘▞▀▖▀▛▘▛▀▘ ▛▀▖▞▀▖▀▛▘▞▀▖  ▞  ▐       ▝▖\n▌  ▙▄▘▙▄ ▙▄▌ ▌ ▙▄  ▌ ▌▙▄▌ ▌ ▙▄▌ ▐   ▜▀ ▞▀▘▌ ▌▐\n▌ ▖▌▚ ▌  ▌ ▌ ▌ ▌   ▌ ▌▌ ▌ ▌ ▌ ▌ ▝▖▗▖▐ ▖▝▀▖▐▐ ▞\n▝▀ ▘ ▘▀▀▘▘ ▘ ▘ ▀▀▘ ▀▀ ▘ ▘ ▘ ▘ ▘  ▝▝▘ ▀ ▀▀  ▘▝\n"
	echo "create the randomized tuples for each relation"
	python3 BD_creation.py \
		--players $(NUMBER_OF_PLAYERS) \
		--spmin $(MIN_SPELLS_PER_PLAYER) \
		--spmax $(MAX_SPELLS_PER_PLAYER) \
		--companions_percentage $(COMPANIONS_PERCENTAGE)


run:
	psql dnd


demo: data install run



