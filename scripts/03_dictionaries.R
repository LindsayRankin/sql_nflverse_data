source(here::here("R", "utils.R"))
library(nflreadr)
con <- connect_nflverse()

dicts <- list(
  dict_pbp           = nflreadr::dictionary_pbp,
  dict_ftn_charting  = nflreadr::dictionary_ftn_charting,
  dict_ngs           = nflreadr::dictionary_nextgen_stats,
  dict_pfr_pass      = nflreadr::dictionary_pfr_passing,
  # there is not a dictionary for pfr rushing
  dict_players       = nflreadr::dictionary_players,
  dict_schedules     = nflreadr::dictionary_schedules 
)
for (nm in names(dicts)) {
  d <- as.data.frame(dicts[[nm]])
  names(d) <- tolower(names(d))
  dbWriteTable(con, nm, d, overwrite = TRUE)
}

    # ###  Inspect these
    # str(dicts[[1]])
    # str(dicts[[2]])
    # str(dicts[[3]])
    # str(dicts[[4]])
    # str(dicts[[5]])
    # check <- dbGetQuery(con, "SELECT * FROM dict_ngs WHERE description ILIKE '%week%'")
    # print(check)


dbDisconnect(con, shutdown = TRUE)
