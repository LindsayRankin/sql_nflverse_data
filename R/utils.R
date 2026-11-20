suppressPackageStartupMessages({ library(DBI); library(duckdb) })

DB_PATH <- here::here("data", "nflverse.duckdb")

connect_nflverse <- function(read_only = FALSE) {
  dbConnect(duckdb(), dbdir = DB_PATH, read_only = read_only)
}

# Updated to run views wit multiple statements, splitting them
run_sql_dir <- function(con, dir) {
  for (f in sort(list.files(dir, pattern = "\\.sql$", full.names = TRUE))) {
    message("Running ", f)
    sql   <- paste(readLines(f, warn = FALSE), collapse = "\n")
    # split on a semicolon that ends a line (or the file)
    stmts <- trimws(strsplit(sql, ";[ \t]*(\r?\n|$)")[[1]])
    # drop pieces that are empty or only comments
    stmts <- stmts[nzchar(trimws(gsub("--[^\n]*", "", stmts)))]
    for (s in stmts) dbExecute(con, s)
  }
}

# Run every check; each file returns zero rows when the check passes
run_checks <- function(con, dir = here::here("sql", "checks")) {
  files <- sort(list.files(dir, pattern = "\\.sql$", full.names = TRUE))
  out <- do.call(rbind, lapply(files, function(f) {
    res <- dbGetQuery(con, paste(readLines(f), collapse = "\n"))
    data.frame(check = basename(f), failing_rows = nrow(res))
  }))
  print(out)
  if (any(out$failing_rows > 0)) warning("Some checks returned rows: investigate.")
  invisible(out)
}

# Simple provenance log: what was loaded, when
log_load <- function(con, table_name, refreshed = NA_character_) {
  dbExecute(con, "CREATE TABLE IF NOT EXISTS meta_load_log (
                    table_name VARCHAR, loaded_at TIMESTAMP,
                    refreshed VARCHAR, total_rows BIGINT)")
  n <- dbGetQuery(con, sprintf("SELECT COUNT(*) AS n FROM %s", table_name))$n
  dbAppendTable(con, "meta_load_log", data.frame(
    table_name = table_name, loaded_at = Sys.time(),
    refreshed = as.character(refreshed), total_rows = n))
}