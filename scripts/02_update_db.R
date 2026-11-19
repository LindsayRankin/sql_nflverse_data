source(here::here("R", "utils.R"))
library(nflreadr); library(nflfastR)

con <- connect_nflverse()
season <- most_recent_season()

# 1. PBP: nflfastR deletes this season's rows and re-appends them
update_pbp_db(con, seasons = season)

# 2. Tables where we swap just the current season, all-or-nothing
replace_season <- function(table, new_data) {
  dbWithTransaction(con, {
    dbExecute(con, sprintf("DELETE FROM %s WHERE season = ?", table), params = list(season))
    dbAppendTable(con, table, new_data)
  })
}
replace_season("ftn_charting",    load_ftn_charting(season))
replace_season("pfr_pass_week",   load_pfr_advstats(season, stat_type = "pass", summary_level = "week"))
replace_season("pfr_pass_season", load_pfr_advstats(season, stat_type = "pass", summary_level = "season"))
replace_season("pfr_rush_week",   load_pfr_advstats(season, stat_type = "rush", summary_level = "week"))
replace_season("pfr_rush_season", load_pfr_advstats(season, stat_type = "rush", summary_level = "season"))

# 3. Small single-file tables: replace entirely
for (st in c("passing", "rushing", "receiving")) {
  dbWriteTable(con, paste0("ngs_", st),
               load_nextgen_stats(seasons = TRUE, stat_type = st), overwrite = TRUE)
}
dbWriteTable(con, "players", load_players(), overwrite = TRUE)
dbWriteTable(con, "schedule", load_schedules(), overwrite = TRUE)

# 4. Log it
for (t in c("nflverse_pbp", "ftn_charting", "pfr_pass_week", "pfr_pass_season",
            "pfr_rush_week", "pfr_rush_season",
            "ngs_passing", "ngs_rushing", "ngs_receiving", "players", "schedule")) {
  log_load(con, t, refreshed = season)
}

dbDisconnect(con, shutdown = TRUE)

# 5. Rebuild the metadata layers (each opens and closes its own connection)
source(here::here("scripts", "04_views.R")); source(here::here("scripts", "05_comments.R")); source(here::here("scripts", "06_checks.R"))