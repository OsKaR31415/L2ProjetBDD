
 -- 1)

 -- origin of each elf
SELECT player.name, place.name
FROM player
INNER JOIN PlayerComesFrom ON player_id = player.ID
INNER JOIN Place ON place_id = place.ID
WHERE player.specie = 'elf';

 -- show dwarf -> spell association (with names)
SELECT player.name AS dwarf, spell.name AS spell
FROM player
INNER JOIN playerknowsspell ON player.ID = player_id
INNER JOIN spell ON spell_id = spell.ID
WHERE player.specie = 'dwarf'
ORDER BY player.name;

 -- show every companion of every french
SELECT player.name AS player, companion.name AS companion
FROM player
INNER JOIN companionof ON player.ID = player_id
INNER join player AS companion ON companion_id = companion.ID
WHERE player.specie = 'french'
ORDER BY player.name;

 -- show players originating from forests
SELECT DISTINCT player.name AS player
FROM player
INNER JOIN PlayerVisitedPlace ON player.ID = player_id
INNER JOIN place ON place_id = place.ID
WHERE place.biome = 'forest';



 -- 2)

 -- players that originate from that are either in mountains or forests
SELECT player.name, place.name, place.biome FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
INNER JOIN place ON place_id = place.ID
WHERE place.ID IN (SELECT ID FROM place WHERE biome = 'mountain'
                   UNION
                   SELECT ID FROM place WHERE biome = 'forest');


 -- every player that has a strength >= 7 or a companion that has a strength >= 7
SELECT player.name FROM player WHERE player.strength >= 7
UNION
SELECT player.name FROM player
INNER JOIN companionof ON player.ID = player_id
INNER JOIN player AS companion ON companion_id = companion.ID
WHERE companion.strength >= 7;

 -- places where elves or dwarves were born
SELECT player.specie, place.name FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
INNER JOIN place ON place_id = place.ID
WHERE player.specie = 'dwarf' OR player.specie = 'elf';

 -- spells that are mastered either by a dwarf or by a human
SELECT DISTINCT spell.name FROM spell
INNER JOIN playerknowsspell ON spell.ID = spell_ID
INNER JOIN player ON player.ID = player_id
WHERE player.specie = 'dwarf' OR player.specie = 'human'
ORDER BY spell.name;



 -- 3)

 -- players that are not bord in a forest
SELECT player.name FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE biome = 'forest');

 -- players that have not visited Blois
SELECT player.name FROM player
INNER JOIN PlayerVisitedPlace ON player.ID = player_id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE name = 'Blois'
);

 -- players that know spells of level not < 4
SELECT DISTINCT player.name FROM player
INNER JOIN PlayerKnowsSpell ON player.ID = player_id
WHERE spell_id NOT IN (
    SELECT ID FROM spell
    WHERE level < 4
);


 -- players that know a spell of level > 3 and that is not born in a forest
SELECT DISTINCT player.name FROM player
INNER JOIN PlayerKnowsSpell ON player.ID = player_id
INNER JOIN spell ON spell_id = spell.ID
WHERE spell.level > 3
  AND player.ID NOT IN (
    SELECT player.ID FROM player
    INNER JOIN PlayerComesFrom ON player.ID = player_id
    INNER JOIN place ON place_id = place.ID
    WHERE place.biome = 'forest'
);



 -- 4)


 -- players that are born neither in a forest nor in a mountain
SELECT player.name FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE biome = 'forest' OR biome = 'mountain');

 -- players that have not visited Blois nor Apple Castle
SELECT player.name FROM player
INNER JOIN PlayerVisitedPlace ON player.ID = player_id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE name = 'Blois' OR name = 'Apple Castle'
);


 -- players that have a magic > 7 or that have a non-elf friend whose magic is > 7
SELECT DISTINCT player.name FROM player
INNER JOIN companionof ON player.ID = player_id
INNER JOIN player AS companion ON companion_id = companion.ID
WHERE (player.magic > 7 OR companion.magic > 7)
  AND companion.ID NOT IN (
    SELECT ID FROM player WHERE specie = 'elf'
);


 -- spells owned by people that don't have friends or are hobbits whose magic is > 7
SELECT spell.name FROM player
INNER JOIN playerknowsspell ON player.ID = player_id
INNER JOIN spell ON spell_id = spell.ID
WHERE player.ID NOT IN (
    SELECT player_id FROM companionof
)
UNION
SELECT spell.name FROM spell
INNER JOIN playerknowsspell ON spell_id = spell.ID
INNER JOIN player ON player.ID = player_id
WHERE player.specie = 'hobbit' and player.magic > 7
;


 -- 5) DIVISION

 -- players that have all the spells
SELECT player.name FROM player
WHERE player.ID NOT IN (
    SELECT DISTINCT notknowsspell.player_id FROM (
        SELECT player.ID AS player_id, spell.ID FROM player, spell
        EXCEPT
        SELECT player_ID, spell_ID FROM playerknowsspell
    ) AS notknowsspell
);


 -- players that have all the spells of level 4
SELECT player.name FROM player
WHERE player.ID NOT IN (
    SELECT DISTINCT notknowsspell.player_id FROM (
        SELECT player.ID AS player_id, spell.ID FROM player, spell
        WHERE spell.level = 4
        EXCEPT
        SELECT player_ID, spell_ID FROM playerknowsspell
    ) AS notknowsspell
);


 -- players of strength 0 that know every person of strength 8
SELECT player.name, companion.magic, companion.strength FROM player
INNER JOIN companionof ON player.ID = player_id
INNER JOIN player as companion on companion_id = companion.id
WHERE player.ID NOT IN (
    SELECT DISTINCT X.player_id FROM (
        SELECT DISTINCT player.ID as player_id, companion.ID
        FROM player, player AS companion
        WHERE companion.strength = 8
        EXCEPT
        SELECT player_id, companion_id FROM companionof
    ) AS X
)
ORDER BY player.name
;





 -- 
SELECT player.name FROM player
WHERE player.id NOT IN (
    SELECT DISTINCT player_id FROM (
        SELECT player.id as player_id, companion.id
        FROM player, (
            SELECT player.id FROM player WHERE strength >= 8 AND magic >= 40
        ) as companion
        EXCEPT
        SELECT player_id, companion_id FROM companionof
    ) AS X
)
order by player.id
;




--------------------------------------------------
--------------------------------------------------

-- number of spells for each player
SELECT player.name, player.specie, count(spell_id)
FROM playerknowsspell, player
WHERE player_id = ID
GROUP BY player.name, player.specie;




-- number of spells for each french player
SELECT player.name, player.specie, count(spell_id)
FROM playerknowsspell, player
WHERE player_id = ID AND player.specie = 'french'
GROUP BY player.name, player.specie;


