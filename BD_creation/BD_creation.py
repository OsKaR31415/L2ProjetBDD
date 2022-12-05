import fantasynames
import random
from dataclasses import dataclass

AVAILABLE_SPECIES = ['human', 'human',
                     'elf', 'elf', 'elf', 'elf', 'elf',
                     'dwarf', 'dwarf',
                     'hobbit', 'hobbit', 'hobbit', 'hobbit',
                     'french']
AVAILABLE_BIOMES = ['forest', 'mountain', 'lowland', 'seaside']


def random_distributed_int(up_to: int =10) -> int:
    return random.sample(range(up_to), 1, counts=reversed(range(up_to)))[0]


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
        self.magic = random_distributed_int()
        return self

    def __repr__(self) -> str:
        SQL = f'{self.ID}, "{self.name}", "{self.specie}", {self.strength}, {self.magic}'
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
        SQL = f'{self.ID}, "{self.name}", "{self.biome}"'
        return SQL


def load_places():
    # load the list of places as a list[str]
    with open('BD_creation/Places_data.csv') as file_places:
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
        SQL = f'{self.ID}, "{self.name}", {self.level}, "{self.duration}", {self.focus}, {self.ritual}'
        return SQL


def load_spells():
    # load the list of places as a list[str]
    with open('BD_creation/Spell_data.csv') as file_spell:
        # ignore first and last lines
        list_spells = file_spell.read().split('\n')[1:-1]
    # create the list of Spell objects
    instanciated_spells : list[Spell] = []
    for spell_attributes in list_spells:
        spell_attributes = spell_attributes.split(',')
        spell_name, level, school, duration, focus, ritual = spell_attributes
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
        return f'{self.player_ID}, {self.spell_ID}, {self.mastery}'

def random_player_spells_links(players, spells):
    result: list[PlayerKnowsSpell] = []
    for _ in range(10 * len(players)):
        player = random.choice(players)
        if player.specie == "french":
            continue
        known_spells = random.sample(spells, random.randint(2, 10))
        for spell in known_spells:
            mastery: int = 1 + random_distributed_int(9)
            result.append(PlayerKnowsSpell(player.ID, spell.ID, mastery))
    for french in filter(lambda p: p.specie == "french", players):
        for spell in random.sample(spells, random.randint(200, 361)):
            mastery: int = 1 + random_distributed_int(9)
            result.append(PlayerKnowsSpell(french.ID, spell.ID, mastery))
    return result


@dataclass
class PlayerVisitedPlace:
    player: int
    place: int
    number_of_visits: int

    def __repr__(self):
        SQL = f'{self.player}, {self.place}, {self.number_of_visits}'
        return SQL

def random_player_places_links(players: list[Player], places: list[Place]) -> list[PlayerVisitedPlace]:
    result: list[PlayerVisitedPlace] = []
    for _ in range(15 * len(players)):
        player = random.choice(players)
        places_visited = random.sample(places, random.randint(1, 15))
        for place in places_visited:
            result.append(PlayerVisitedPlace(player.ID, place.ID, 1+random_distributed_int(50)))
    return result


@dataclass
class PlayerComesFrom:
    player_ID: int
    place_ID: int
    # TODO: find additionnal property

    def __repr__(self) -> str:
        SQL = f"{self.player_ID}, {self.place_ID}"
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
        SQL = f"{self.player_ID}, {self.companion_ID}, {self.years_together}, {self.campaigns_together}"
        return SQL

def random_companions(players: [Player]) -> [CompanionOf]:
    result: [CompanionOf] = []
    for idx, player in enumerate(players):
        for companion in players[idx+1:]:
            years_together = random_distributed_int(25)
            campaigns_together = random_distributed_int(2 + 5*years_together)
            result.append(CompanionOf(player.ID, companion.ID, years_together, campaigns_together))
            result.append(CompanionOf(companion.ID, player.ID, years_together, campaigns_together))
    return result



players: [Player] = [random_player() for _ in range(20)]
places: [Place] = load_places()
spells: [Spell] = load_spells()
player_knows_spell: [PlayerKnowsSpell] = random_player_spells_links(players, spells)
player_visited_place: [PlayerVisitedPlace] = random_player_places_links(players, places)
player_comes_from: [PlayerComesFrom] = random_players_origins(players, places)
companion_of: [CompanionOf] = random_companions(players)

open("player.tsv", "w").close()  # clear file
print("\nPlayer[ID, specie, name, strength, magic]")
print(*players, sep='\n', file="")

open("place.txv", "w").close()
print("\nPlace[ID, name, biome]")
print(*places[:10], sep='\n')
print("\nSpell[ID, name, level, duration, focus, ritual]")
print(*spells, sep='\n')
print("\nPlayerVisitedPlace[playerID, placeID, number_of_visits]")
print(*player_visited_place, sep='\n')
print("\nPlayerComesFrom[playerID, placeID, ???]")
print(*player_comes_from, sep='\n')
print("\nPlayerKnowsSpell[playerID, placeID, mastery]")
print(*player_knows_spell, sep='\n')
print("\nCompanionOf[playerID, companion_ID, years_together, campaigns_together]")
print(*companion_of, sep='\n')




