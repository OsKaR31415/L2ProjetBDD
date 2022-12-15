import fantasynames
import random
from dataclasses import dataclass
import argparse
import os

TOTAL_PLACES = 352
TOTAL_SPELLS = 362

AVAILABLE_SPECIES = ['human', 'human',
                     'elf', 'elf', 'elf', 'elf', 'elf',
                     'dwarf', 'dwarf',
                     'hobbit', 'hobbit', 'hobbit', 'hobbit',
                     'french',
                     'anglo']

AVAILABLE_BIOMES = ['forest', 'mountain', 'lowland', 'seaside']





# RANDOM DISTRIBUTION
def random_distributed_int(up_to: int =10) -> int:
    return random.sample(range(up_to), 1, counts=reversed(range(up_to)))[0]


# ┏━╸╻  ┏━┓┏━┓┏━┓┏━╸┏━┓
# ┃  ┃  ┣━┫┗━┓┗━┓┣╸ ┗━┓
# ┗━╸┗━╸╹ ╹┗━┛┗━┛┗━╸┗━┛

Player = "Player"  # for type hinting
@dataclass
class Player:
    @property
    def ID(self):
        return int(str(abs(hash(self.name + str(self.strength) + str(self.magic))))[:])
    specie: str = 'human'
    name: str = ''
    strength: int = 0
    magic: int = 0

    def randomize(self) -> Player:
        self.specie = random.choice(AVAILABLE_SPECIES)
        self.name = getattr(fantasynames, self.specie)()
        self.strength = random_distributed_int()
        self.magic = random_distributed_int(50)
        return self

    def __repr__(self) -> str:
        SQL = f'{self.ID}	"{self.name}"	"{self.specie}"	{self.strength}	{self.magic}'
        return SQL

def random_player():
    return Player().randomize()

@dataclass
class Place:
    @property
    def ID(self):
        return int(str(abs(hash(self.name + self.biome)))[:])
    name: str
    biome: str

    def __repr__(self) -> str:
        SQL = f'{self.ID}	"{self.name}"	"{self.biome}"'
        return SQL


def load_places():
    # load the list of places as a [str]
    with open('data/Places_data.csv') as file_places:
        list_places = file_places.read().split('\n')
    # create the list of Place objects
    instanciated_places = []  # the list of results
    for place_name in list_places:
        # skip empty names
        if len(place_name) == 0:
            continue
        biome = random.choice(AVAILABLE_BIOMES)  # random biome
        new_place = Place(place_name, biome)  # create the place object
        instanciated_places.append(new_place)  # add to the result list
    return instanciated_places


@dataclass
class Spell:
    @property
    def ID(self):
        return int(str(abs(hash(self.name + str(self.level) + self.duration)))[:])
    name: str
    level: int
    duration: str  # duration of the incantation
    focus: bool  # needs focus ? (True/False)
    ritual: bool  # needs a ritual ? (True/False)

    def __repr__(self):
        SQL = f'{self.ID}	"{self.name}"	{self.level}	"{self.duration}"	{self.focus}	{self.ritual}'
        return SQL



def load_spells():
    # load the list of places as a [str]
    with open('data/Spell_data.tsv') as file_spell:
        # ignore first and last lines
        list_spells = file_spell.read().split('\n')[1:-1]
    # create the list of Spell objects
    instanciated_spells : [Spell] = []
    for spell_attributes in list_spells:
        spell_attributes = spell_attributes.split('\t')
        spell_name, level, school, duration, focus, ritual, _ = spell_attributes
        level: int = int(level)
        focus: bool = len(focus) > 1
        ritual: bool = len(ritual) > 1
        instanciated_spells.append(Spell(spell_name, level, duration, focus, ritual))
    return instanciated_spells


@dataclass
class PlayerKnowsSpell:
    player_ID: int
    spell_ID: int
    mastery: int

    def __repr__(self):
        return f'{self.player_ID}	{self.spell_ID}	{self.mastery}'

def random_player_spells_links(players, spells,
                               min_spells_per_player: int = 2,
                               max_spells_per_player: int = 10):
    result: [PlayerKnowsSpell] = []
    for player in players:
        if player.specie == "french":
            number_of_spells = random.randint(TOTAL_SPELLS - 15, TOTAL_SPELLS)
        else:
            number_of_spells = random.randint(int(min_spells_per_player), int(max_spells_per_player))
        for spell in random.sample(spells, number_of_spells):
            mastery = 1 + random_distributed_int(9)
            result.append(PlayerKnowsSpell(player.ID, spell.ID, mastery))
    return result


@dataclass
class PlayerVisitedPlace:
    player: int
    place: int
    number_of_visits: int

    def __repr__(self):
        SQL = f'{self.player}	{self.place}	{self.number_of_visits}'
        return SQL

def random_player_places_links(players: [Player], places: [Place]) -> [PlayerVisitedPlace]:
    result: [PlayerVisitedPlace] = []
    for player in players:
        if player.specie == "french":
            number_of_places = (TOTAL_PLACES - 10, TOTAL_PLACES)
        else:
            number_of_places = (1, 15)
        for place in random.sample(places, random.randint(*number_of_places)):
            result.append(PlayerVisitedPlace(player.ID, place.ID, 1+random_distributed_int(50)))
    return result


@dataclass
class PlayerComesFrom:
    player_ID: int
    place_ID: int
    # TODO: find additionnal property

    def __repr__(self) -> str:
        SQL = f"{self.player_ID}	{self.place_ID}"
        return SQL

def random_players_origins(players: [Player], places: [Place]) -> [PlayerComesFrom]:
    result: [PlayerComesFrom] = []
    for player in players:
        place = random.choice(places)
        result.append(PlayerComesFrom(player.ID, place.ID))
    return result


@dataclass
class CompanionOf:
    player_ID: int
    companion_ID: int
    years_together: int
    campaigns_together: int

    def __repr__(self) -> str:
        SQL = f"{self.player_ID}	{self.companion_ID}	{self.years_together}	{self.campaigns_together}"
        return SQL

def random_companions(players: [Player], companions_percentage: int = 20) -> [CompanionOf]:
    result: [CompanionOf] = []
    players = [player for player in players if player.specie != 'anglo']
    for idx, player in enumerate(players):
        for companion in players[idx+1:]:
            if random.randint(1, 100) <= companions_percentage:
                years_together = random_distributed_int(25)
                campaigns_together = random_distributed_int(2 + 5*years_together)
                result.append(CompanionOf(player.ID, companion.ID, years_together, campaigns_together))
                # make this relation reciprocal
                result.append(CompanionOf(companion.ID, player.ID, years_together, campaigns_together))
    return result



# ┏━┓┏━┓┏━┓┏━┓┏━╸┏━┓
# ┣━┛┣━┫┣┳┛┗━┓┣╸ ┣┳┛
# ╹  ╹ ╹╹┗╸┗━┛┗━╸╹┗╸

parser = argparse.ArgumentParser("Tool to create random tuples for a dnd database")
parser.add_argument("--players", "-p",
                    help="Number of players in the database",
                    type=int, default=200)
parser.add_argument("--min-spells-per-player", "--spmin",
                    help="Minimmum number of spells for a player (except for french players)",
                    type=int, default=2)
parser.add_argument("--max-spells-per-player", "--spmax",
                    help="Maximum number of spells for a player (except for french players)",
                    type=int, default=10)
parser.add_argument("--companions_percentage", "--cp",
                    help="average percentage of people that are companions of a player",
                    type=int, default=20)
args = parser.parse_args()


# ┏━╸┏━┓┏━╸┏━┓╺┳╸┏━╸   ╺┳┓┏━┓╺┳╸┏━┓
# ┃  ┣┳┛┣╸ ┣━┫ ┃ ┣╸     ┃┃┣━┫ ┃ ┣━┫
# ┗━╸╹┗╸┗━╸╹ ╹ ╹ ┗━╸   ╺┻┛╹ ╹ ╹ ╹ ╹

players: [Player] = [random_player() for _ in range(args.players)]
places: [Place] = load_places()
spells: [Spell] = load_spells()
player_knows_spell: [PlayerKnowsSpell] = random_player_spells_links(players, spells,
                                                                    min_spells_per_player=args.min_spells_per_player,
                                                                    max_spells_per_player=args.max_spells_per_player)
player_visited_place: [PlayerVisitedPlace] = random_player_places_links(players, places)
player_comes_from: [PlayerComesFrom] = random_players_origins(players, places)
companion_of: [CompanionOf] = random_companions(players, companions_percentage=args.companions_percentage)


# ╻ ╻┏━┓╻╺┳╸┏━╸   ╺┳╸┏━┓   ┏━╸╻╻  ┏━╸┏━┓
# ┃╻┃┣┳┛┃ ┃ ┣╸     ┃ ┃ ┃   ┣╸ ┃┃  ┣╸ ┗━┓
# ┗┻┛╹┗╸╹ ╹ ┗━╸    ╹ ┗━┛   ╹  ╹┗━╸┗━╸┗━┛

def clear_file(name: str):
    open(str(name), "w").close()

if not os.path.exists("output"):
    os.mkdir("output")

clear_file("output/player.tsv")
print("ID	specie	name	strength	magic", *players, sep='\n', file=open('output/player.tsv', 'w'))

clear_file("output/place.tsv")
print("ID	name	biome", *places, sep='\n', file=open('output/place.tsv', 'w'))

clear_file("output/spells.tsv")
print("ID	name	level	duration	focus	ritual", *spells, sep='\n', file=open('output/spells.tsv', 'w'))

clear_file("output/player_visited_place.tsv")
print("playerID	placeID	number_of_visits", *player_visited_place, sep='\n', file=open('output/player_visited_place.tsv', 'w'))

clear_file("output/player_comes_from.tsv")
print("playerID	placeID	???", *player_comes_from, sep='\n', file=open('output/player_comes_from.tsv', 'w'))

clear_file("output/player_knows_spell.tsv")
print("playerID	placeID	mastery", *player_knows_spell, sep='\n', file=open('output/player_knows_spell.tsv', 'w'))

clear_file("output/companion_of.tsv")
print("nplayerID	companion_ID	years_together	campaigns_together", *companion_of, sep='\n', file=open('output/companion_of.tsv', 'w'))


all_tables = (players, places, spells, player_knows_spell, player_visited_place, player_comes_from, companion_of)
print("total number of tuples :", sum(map(len, all_tables)))
print("number of tuples for each table :", {type(table[0]).__name__: len(table) for table in all_tables})

