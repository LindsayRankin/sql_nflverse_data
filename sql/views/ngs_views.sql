-- Next Gen Stats arrive with two kinds of rows in one table:
--   week = 0  -> season totals (one row per player-season)
--   week > 0  -> weekly rows
-- Summing across both double counts. Query these views, not the raw tables.

CREATE OR REPLACE VIEW ngs_passing_weekly AS
SELECT * FROM ngs_passing WHERE week > 0;

CREATE OR REPLACE VIEW ngs_passing_season AS
SELECT * FROM ngs_passing WHERE week = 0;

CREATE OR REPLACE VIEW ngs_rushing_weekly AS
SELECT * FROM ngs_rushing WHERE week > 0;

CREATE OR REPLACE VIEW ngs_rushing_season AS
SELECT * FROM ngs_rushing WHERE week = 0;

CREATE OR REPLACE VIEW ngs_receiving_weekly AS
SELECT * FROM ngs_receiving WHERE week > 0;

CREATE OR REPLACE VIEW ngs_receiving_season AS
SELECT * FROM ngs_receiving WHERE week = 0;