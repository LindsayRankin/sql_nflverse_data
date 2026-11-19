source(here::here("R", "utils.R")); con <- connect_nflverse()
run_sql_dir(con, here::here("sql", "views"))
dbDisconnect(con, shutdown = TRUE)
