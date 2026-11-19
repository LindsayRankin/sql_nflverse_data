library(DBI)
library(duckdb)
library(nflreadr)
library(nflfastR)


dir.create(here::here("data"), showWarnings = FALSE)

  ## Prior to creating utils.R
  # con <- dbConnect(duckdb(), dbdir = "data/nflverse.duckdb")  # creates the file if absent

source(here::here("R", "utils.R")); con <- connect_nflverse()

# PBP: nflfastR's helper creates/updates the table "nflverse_pbp".
# Start with a few seasons to confirm everything works.
# It asks "create table? (Y/n)" interactively, so run this in the console, not in Quarto.
update_pbp_db(con, seasons = 2022:most_recent_season())


# FTN charting (2022 onward)
dbWriteTable(con, "ftn_charting",
             load_ftn_charting(seasons = 2022:most_recent_season()), overwrite = TRUE)

  # # For reference, pure SQL version...
  # dbExecute(con, "
  #   CREATE OR REPLACE TABLE ftn_charting AS
  #   SELECT * FROM read_parquet(
  #     'https://github.com/nflverse/nflverse-data/releases/download/ftn_charting/ftn_charting_2023.parquet')
  # ")


# PFR advanced passing: weekly and season grain are separate tables
dbWriteTable(con, "pfr_pass_week",
             load_pfr_advstats(2018:most_recent_season(), stat_type = "pass", summary_level = "week"),
             overwrite = TRUE)
dbWriteTable(con, "pfr_pass_season",
             load_pfr_advstats(2018:most_recent_season(), stat_type = "pass", summary_level = "season"),
             overwrite = TRUE)

# PFR rushing passing: weekly and season grain are separate tables
dbWriteTable(con, "pfr_rush_week",
             load_pfr_advstats(2018:most_recent_season(), stat_type = "rush", summary_level = "week"),
             overwrite = TRUE)
dbWriteTable(con, "pfr_rush_season",
             load_pfr_advstats(2018:most_recent_season(), stat_type = "rush", summary_level = "season"),
             overwrite = TRUE)

# Next Gen Stats: different columns per stat type, so one table each
for (st in c("passing", "rushing", "receiving")) {
  dbWriteTable(con, paste0("ngs_", st),
               load_nextgen_stats(seasons = TRUE, stat_type = st), overwrite = TRUE)
}

# Player crosswalk (maps GSIS IDs to PFR IDs)
dbWriteTable(con, "players", load_players(), overwrite = TRUE)


# Schedules (overall win and loss)
dbWriteTable(con, "schedule", load_schedules(), overwrite = TRUE)

# meta log
for (t in c("nflverse_pbp", "ftn_charting", "pfr_pass_week", "pfr_pass_season",
            "pfr_rush_week", "pfr_rush_season",
            "ngs_passing", "ngs_rushing", "ngs_receiving", "players")) {
  log_load(con, t, refreshed = "initial build")
}



dbListTables(con)
dbDisconnect(con, shutdown = TRUE)

