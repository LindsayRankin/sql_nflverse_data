-- sql/checks/ftn_without_pbp.sql

SELECT f.nflverse_game_id, f.nflverse_play_id
FROM ftn_charting AS f
LEFT JOIN nflverse_pbp AS p
  ON f.nflverse_game_id = p.game_id AND f.nflverse_play_id = p.play_id
WHERE p.game_id IS NULL;
