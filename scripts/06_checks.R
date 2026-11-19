source(here::here("R", "utils.R")); con <- connect_nflverse(read_only = TRUE); run_checks(con)

dbDisconnect(con, shutdown = TRUE)
