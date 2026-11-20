-- sql/checks/pbp_key_unique.sql
-- checks that (game_id, play_id) uniquely identifies one row in nflverse_pbp, meaning no play appears twice

SELECT game_id, play_id, COUNT(*) AS n
FROM nflverse_pbp
GROUP BY game_id, play_id
HAVING COUNT(*) > 1;
