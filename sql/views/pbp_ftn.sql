-- sql/views/pbp_ftn.sql
CREATE OR REPLACE VIEW pbp_ftn AS
SELECT p.*, f.* EXCLUDE (season, week, nflverse_game_id, nflverse_play_id)
FROM nflverse_pbp AS p
LEFT JOIN ftn_charting AS f
  ON p.game_id = f.nflverse_game_id AND p.play_id = f.nflverse_play_id
