# README for SQL nflverse data

🚧 👷‍♀️Active work in progress, late November 2026... 

## Purpose

This repo was setup to be run in RStudio, using DuckDB to set up a database from some of the nflverse data. 

The primary aims were to learn how to set up a local analytic database, to practice writing SQL queries (DuckDB's SQL dialect) while using this data, and perhaps to (later) write a blog post about this that may be used to help when teaching others about using SQL.

At the moment, only some data (the ones I have been using the most frequently) are being used. This can be updated across all scripts to add more.\
Currently:\
Play by play, PFR passing, PFR rushing, FTN charting, Next Gen Stats passing, Next Gen Stats rushing, Next Gen Stats receiving, Schedule, Players

## Repo Steps for Building and Updating Database

**Initial build:** The script 01 initially builds the database, and then scripts 03-06 should be run for dictionaries and "metadata".

- Script 02 is for batch updates and would be unnecessary when initially building the database (but idempotent).

**Batch updates throughout the NFL season:** Script 02 will do batch or incremental updates (such as updating the data after another week within the season).

- Running script 02 will then also trigger a run of the "metadata scripts" 04, 05, and 06 as views and comments and checks, respectively. 

  - Note: technically, some parts of these may not need to be re-run in all circumstances, but they are short and idempotent, so easiest to just re-run all rather than pick and choose. For example, comments are wiped when a table is replaced and some tables are replaced whereas some are just updated.)
- Dictionaries (script 03) are stored in the package nflreadr, and should be updated if and when that package has an update; but otherwise, it is not necessary to update this with each batch update, as the data dictionary (the columns in the data) will (likely) not change in season. 

**Re-build between seasons:** Script 01 could also be used to entirely refresh the database (such as between NFL seasons, when prior year errors may be updated or new columns may be added), followed by scripts 03-06 (again, during a build script 02 would be idempotent).

### Metadata

#### Views and Comments

Many of the data tables are weekly summaries. 

Next Gen Stats (separate tables for assing, rushing, and receiving) loads week and season data (season indicated as week = 0) all together.
Views are created to distinguish weekly data or season data, i.e., ngs_passing_weekly, ngs_passing_season. (SQL reminder: Views sit above the raw tables that can be queried to create an analysis-ready version, and short comments are added to the table objects as reminders.) 

The main play-level data are the play-by-play (pbp) and the FTN charting. A view is set up to join these.

🚧 👷‍♀️
BELOW IN PARTICULAR IS STILL UNDER CONSTRUCTION, NOVEMBER 2026...



#### Checks

Some manual checks were included. \
pbp_key_unique.sql checks that (game_id, play_id) uniquely identifies one row in nflverse_pbp, meaning no play appears twice. DuckDB would not have forced this, but PostgreSQL would have forced us to declare these two as PRIMARY KEY and would have rejected duplicates. Also helps address if any errors occur during script 02 trying to update. Note that it ignores NULL values, which is fine (some rows may not contain a play_id if they indicate other aspects of a game)
ngs_views_partition.sql checks that splitting Next Gen Stats into weekly and season accounts for all rows. 
ftn_without_pbp.sql checks that all FTN charting has a matching play in the pbp data. (The reverse may not be true - charting may not exist for all plays.)




## Repo layout

nflverse-db/\
├── nflverse-db.Rproj\
├── README.md              # what this is, how to run it\
├── .gitignore             # include data/\
├── data/nflverse.duckdb\
├── R/utils.R              # connection + helper functions\
├── scripts/\
│   ├── 01_build_db.R      # initial build or full refresh\
│   ├── 02_update_db.R     # weekly (or when needed) incremental / batch refresh\
│   ├── 03_dictionaries.R  # load data dictionaries from package; re-run after any nflreadr update\
│   ├── 04_views.R         # runs sql/views/\*.sql \
│   ├── 05_comments.R      # COMMENT ON ...\
│   └── 06_checks.R        # runs sql/checks/*.sql\
├── sql/\
│   ├── views/\
│   └── checks/\
├── scratch/\
│   ├── explore.qmd/       # checking the products of the scripts\
│ COMING SOON...  ├── profile.qmd/       # code for how to poke around in the data
└── docs/data-notes.qmd    # human-readable documentation\




