-- sql/views/ngs_passing_weekly.sql
CREATE OR REPLACE VIEW ngs_passing_weekly AS
SELECT * FROM ngs_passing WHERE week > 0
