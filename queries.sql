
----------------------------------------
-- 1) sélection, projection, jointure --
----------------------------------------

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



-----------------------------------------------
-- 2) sélection, projection, jointure, union --
-----------------------------------------------

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



----------------------------------------------------
-- 3) sélection, projection, jointure, différence --
----------------------------------------------------

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



-----------------------------------------------------------
-- 4) sélection, projection, jointure, différence, union --
-----------------------------------------------------------


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


 -- players that have a magic > 42 or that have a non-elf friend whose magic is > 42
SELECT DISTINCT player.name FROM player
INNER JOIN companionof ON player.ID = player_id
INNER JOIN player AS companion ON companion_id = companion.ID
WHERE (player.magic > 42 OR companion.magic > 42)
  AND companion.ID NOT IN (
    SELECT ID FROM player WHERE specie = 'elf'
);


 -- spells owned by people that don't have friends or are hobbits whose magic is > 42
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
WHERE player.specie = 'hobbit' and player.magic > 42
;


-----------------
-- 5) DIVISION --
-----------------

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



 -- players that know all the players with a magic >= 48
 -- you may need to increas this number if ther are no results (or decrease of there are too much) depending on the data you are using
SELECT player.name FROM player
WHERE player.id NOT IN (
    SELECT DISTINCT player_id FROM (
        SELECT player.id as player_id, companion.id
        FROM player, (
            SELECT player.id FROM player WHERE magic >= 48
        ) as companion
        EXCEPT
        SELECT player_id, companion_id FROM companionof
    ) AS X
)
order by player.id
;


 -- spells mastered by every french
SELECT spell.name FROM spell
WHERE spell.id NOT IN (
    SELECT DISTINCT spell_id FROM (
        SELECT spell.id as spell_id, french.id
        FROM spell, (
            SELECT player.id FROM player WHERE specie = 'french'
        ) as french
        EXCEPT
        SELECT spell_id, player_id FROM playerknowsspell
    ) AS X
);


-----------------------------------------------------------------
-- 6) sélection, projection, jointure, groupement, aggrégation --
-----------------------------------------------------------------


 -- number of spells by each player
SELECT player.name, count(spell.id) FROM player
INNER JOIN playerknowsspell ON player.id = player_id
INNER JOIN spell ON spell_id = spell.id
GROUP BY player.name;

 -- number of places visited by each player
SELECT player.name, count(place.id) FROM player
INNER JOIN PlayerVisitedPlace ON player_id = player.id
INNER JOIN place ON place_id = place.id
GROUP BY player.name;

 -- number of companions each player has
 -- this one doesn't really count since it is used as a subquery in the following one
SELECT player.name, count(companion.id) FROM player, player as companion
WHERE (player.id, companion.id) IN (
    SELECT player_id, companion_id FROM companionof
)
GROUP BY player.name;

 -- statistics for the number of companions of each player
SELECT min(comp_count) AS min_companion_count,
       avg(comp_count) AS avg_companion_count,
       max(comp_count) AS max_companions_count
FROM (SELECT player.name, count(companion.id) AS comp_count
    FROM player, player as companion
    WHERE (player.id, companion.id) IN (
        SELECT player_id, companion_id FROM companionof
    )
    GROUP BY player.name) AS X
;

 -- number of spells mastered by players born in each place
SELECT place.name, count(spell.id) FROM spell
INNER JOIN playerknowsspell ON spell.id = spell_id
INNER JOIN player ON player.id = playerknowsspell.player_id
INNER JOIN playercomesfrom ON playercomesfrom.player_id = player.id
INNER JOIN place ON place.id = place_id
GROUP BY place.name;

-----------------------------------------------------------------------------
-- 7) sélection, projection, jointure, groupement, aggrégation, différence --
-----------------------------------------------------------------------------

 -- number of player that are not born in each non-forest place
SELECT place.name, count(player.name) FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
INNER JOIN place ON place_id = place.id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE biome = 'forest')
GROUP BY place.name;

 -- number of players in each place except Blois
SELECT place.name, count(player.name) FROM player
INNER JOIN PlayerVisitedPlace ON player.ID = player_id
INNER JOIN place ON place_id = place.id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE name = 'Blois'
)
GROUP BY place.name
;

 -- players that know spells of level not < 4
 -- number of players that know each spell of level not < 4
SELECT spell.name, count(player.name) FROM player
INNER JOIN PlayerKnowsSpell ON player.ID = player_id
INNER JOIN spell ON spell_id = spell.id
WHERE spell_id NOT IN (
    SELECT ID FROM spell
    WHERE level < 4
)
GROUP BY spell.name
;


 -- players that know a spell of level > 3 and that is not born in a forest
 -- number of players not born in a forests and that know each spell of level > 0
SELECT DISTINCT spell.name, count(player.name) FROM player
INNER JOIN PlayerKnowsSpell ON player.ID = player_id
INNER JOIN spell ON spell_id = spell.ID
WHERE spell.level > 3
  AND player.ID NOT IN (
    SELECT player.ID FROM player
    INNER JOIN PlayerComesFrom ON player.ID = player_id
    INNER JOIN place ON place_id = place.ID
    WHERE place.biome = 'forest'
)
GROUP BY spell.name
;


------------------------------------------------------------------------------------
-- 8) sélection, projection, jointure, groupement, aggrégation, différence, union --
------------------------------------------------------------------------------------

 -- number of players born in each places that not a forests nor mountains
SELECT place.name, count(player.name) FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
INNER JOIN place ON place_id = place.id
WHERE place_id NOT IN (
    SELECT ID FROM place WHERE biome = 'forest' OR biome = 'mountain')
GROUP BY place.name;


 -- spells owned by people that don't have friends or are hobbits whose magic is > 42
 -- number of spells owned by each people that don't have friends or are hobbits whose magic is > 42
SELECT player.name, count(spell.id)
FROM (SELECT spell.name AS spell_name FROM player
    INNER JOIN playerknowsspell ON player.ID = player_id
    INNER JOIN spell ON spell_id = spell.ID
    WHERE player.ID NOT IN (
        SELECT player_id FROM companionof
    )
    UNION
    SELECT spell.name AS spell_name FROM spell
    INNER JOIN playerknowsspell ON spell_id = spell.ID
    INNER JOIN player ON player.ID = player_id
    WHERE player.specie = 'hobbit' and player.magic > 42
) AS X
INNER JOIN spell ON spell_name = spell.name
INNER JOIN PlayerKnowsSpell ON spell.id = spell_id
INNER JOIN player ON player_id = player.id
GROUP BY player.name
;


 -- number of spells mastered by each players not born in a lowland, that have magic > 42 or master at least a spell of level 42
SELECT player.name, count(spell.id) FROM (
    SELECT player.id AS id FROM player
    INNER JOIN playerknowsspell ON player.ID = player_id
    INNER JOIN spell ON spell_id = spell.ID
    WHERE spell.level >= 4 OR player.magic > 42
    EXCEPT
    SELECT player.id AS id FROM player
    INNER JOIN playercomesfrom ON player.id = player_id
    INNER JOIN place ON place_id = place.ID
    WHERE place.biome = 'lowland') as pl
INNER JOIN playerknowsspell ON pl.ID = player_id
INNER JOIN spell ON spell_id = spell.id
INNER JOIN player ON pl.id = player.id
GROUP BY player.name
;



 -- number of players whose companions do not come from seaside or mountains, for each place they come from
SELECT player.name, place.biome
FROM player
INNER JOIN playercomesfrom ON player.ID = player_id
INNER JOIN place ON place_id = place.id
WHERE player.id NOT IN (
    SELECT DISTINCT player.id
    FROM player, (
        SELECT player.id FROM player
        INNER JOIN PlayerComesFrom ON player.id = player_id
        INNER JOIN place ON place_id = place.id
        WHERE place.biome = 'seaside' OR place.biome = 'mountains'
    ) AS companion
)
;


 -- number of players that don't master 49-3 nor Amis, by the place they were born in
 -- only showing places where at least 10 players match the condition
SELECT place.name, count(player.id) FROM player
INNER JOIN PlayerComesFrom ON player.id = player_id
INNER JOIN place ON place_id = place.id
WHERE player.id NOT IN (
    SELECT player.id
    FROM player
    INNER JOIN PlayerKnowsSpell ON player.ID = player_id
    INNER JOIN spell ON spell_id = spell.id
    WHERE spell.name = '49-3' OR spell.name = 'Amis'
)
GROUP BY place.name
HAVING count(player.id) > 10
;


