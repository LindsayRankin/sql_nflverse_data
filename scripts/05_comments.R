source(here::here("R", "utils.R")); con <- connect_nflverse()

comment_on <- function(object, text) {
  dbExecute(con, sprintf("COMMENT ON %s IS %s", object, dbQuoteString(con, text)))
}

# Next Gen Stats data structure (season and weeks in same raw table)
comment_on("TABLE ngs_passing",
           "Next Gen Stats passing. Grain: player-week. Rows with week = 0 are season totals.")
comment_on("TABLE ngs_rushing",
           "Next Gen Stats rushing. Grain: player-week. Rows with week = 0 are season totals.")
comment_on("TABLE ngs_receiving",
           "Next Gen Stats receiving. Grain: player-week. Rows with week = 0 are season totals.")

comment_on("COLUMN ngs_passing.week",
           "Week 0 = season aggregate row. Never sum together with weeks 1+.")
comment_on("COLUMN ngs_rushing.week",
           "Week 0 = season aggregate row. Never sum together with weeks 1+.")
comment_on("COLUMN ngs_receiving.week",
           "Week 0 = season aggregate row. Never sum together with weeks 1+.")

comment_on("VIEW ngs_passing_weekly", "ngs_passing without the week 0 season-total rows.")
comment_on("VIEW ngs_rushing_weekly", "ngs_rushing without the week 0 season-total rows.")
comment_on("VIEW ngs_receiving_weekly", "ngs_receiving without the week 0 season-total rows.")

# Other

comment_on("TABLE nflverse_pbp", "Play-by-play. Grain: play. Key: (game_id, play_id).")
comment_on("TABLE ftn_charting", "Charting play. Grain: play. Key: (nflverse_game_id, nflverse_play_id).")

dbDisconnect(con, shutdown = TRUE)
