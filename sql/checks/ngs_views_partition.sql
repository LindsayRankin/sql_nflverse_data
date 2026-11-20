--sql/checks/ngs_views_partition.sql
-- returns a row only if a stat type’s weekly and season views don’t add up to the raw table

SELECT * FROM (
  SELECT 'passing' AS stat_type,
         (SELECT COUNT(*) FROM ngs_passing) AS n_all,
         (SELECT COUNT(*) FROM ngs_passing_weekly) + (SELECT COUNT(*) FROM ngs_passing_season) AS n_split
  UNION ALL
  SELECT 'rushing',
         (SELECT COUNT(*) FROM ngs_rushing),
         (SELECT COUNT(*) FROM ngs_rushing_weekly) + (SELECT COUNT(*) FROM ngs_rushing_season)
  UNION ALL
  SELECT 'receiving',
         (SELECT COUNT(*) FROM ngs_receiving),
         (SELECT COUNT(*) FROM ngs_receiving_weekly) + (SELECT COUNT(*) FROM ngs_receiving_season)
) AS t
WHERE n_all <> n_split
