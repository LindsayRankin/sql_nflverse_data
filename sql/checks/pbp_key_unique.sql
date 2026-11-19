-- sql/checks/pbp_key_unique.sql

SELECT game_id, play_id, COUNT(*) AS n
FROM nflverse_pbp
GROUP BY game_id, play_id
HAVING COUNT(*) > 1;
