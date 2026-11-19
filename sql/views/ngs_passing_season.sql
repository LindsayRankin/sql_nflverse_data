-- sql/views/ngs_passing_season.sql
CREATE OR REPLACE VIEW ngs_passing_season AS
SELECT * FROM ngs_passing WHERE week = 0
