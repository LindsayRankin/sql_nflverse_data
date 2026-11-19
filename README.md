# README for SQL nflverse data


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
Note some inherent messiness with the data and how it is addressed here: 
PFR data can be loaded as week or season summaries, so the data is loaded into different tables for week and season (and different tables for pass or rush; could later add in receiving and defense when desired)

In contrast, Next Gen Stats loads week and season data (season indicated as week = 0) all together. 
A view is created to sit above the raw tables that can be queried to create an analysis-ready version, and short comments are added to the table objects as reminders. 

pre-writing common joins
giving stable, readable names"

#### Checks
Checks are some code to try... 





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




