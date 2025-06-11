# make_tr.R
# this should refresh slides for any booked session with the correct dates
library(tidyverse)
# remotes::install_github("https://github.com/bclarke-nes/kindr/", force = T)
library(KINDR)

sessions <- KINDR::training_sessions(output_type = "tibble")

sessions$title

raw_files <- list.files(pattern = "*.qmd")

# live versions ---

active_sessions <- raw_files[tools::file_path_sans_ext(raw_files) %in% sessions$title]
session_dates <- sessions |>
  filter(title %in% tools::file_path_sans_ext(active_sessions)) |>
  pull(start) |>
  floor_date("day") |>
  as.character()

# test versions ----
# active_sessions <- list.files(pattern = "*.qmd")
# session_dates <- "2025-07-01"

active_sessions # full fn with ext

renda <- function(active_sessions, session_dates){
  
  url <- paste0("https://raw.githubusercontent.com/NES-DEW/KIND-training/refs/heads/main/content/",
                URLencode(active_sessions))
  
  destfile <- paste0("content/", active_sessions)
  
  curl::curl_download(url = url, destfile = destfile)
  
  quarto::quarto_render(active_sessions, execute_params = list(date = session_dates, 
                                                               fn = tools::file_path_sans_ext(active_sessions)))
}

walk2(active_sessions, session_dates, renda)
# renda("CSS and Javascript for non-web developers.qmd", "2025-05-06")
# renda("Joining data with dplyr.qmd", format(lubridate::today(), "%Y-%m-%d"))
