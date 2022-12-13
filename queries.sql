
-- get all players
SELECT ID FROM player;

-- get all possible (player, spell) couples
SELECT player.id, spell.id FROM player, spell ORDER BY player.id;




SELECT player.id FROM player, spell
    WHERE (player.id, spell.id) NOT IN (
        SELECT player_id, spell_id FROM PlayerKnowsSpell
);


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


