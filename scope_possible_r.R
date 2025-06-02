library(tidyverse)

ae_activity <- read_csv("data/weekly_ae_activity_20240609.csv")

# little bit of cheating
names(ae_activity) <- c("date", "country", "hb", "loc", "type", "attend", "n_within", "n_4", "perc_4", "n_8", "perc_8", "n_12", "perc_12")

# ae_activity |>
#   filter(loc == "A210H") |>
#   mutate(date = ymd(date)) |>
#   ggplot(aes(x = date, y = n_within/attend)) +
#   geom_line() +
#   geom_smooth(se = F)

ae_activity |>
  # filter(loc == "A210H") |>
  mutate(date = ymd(date)) |>
  filter(date != 2024) |>
  group_by(loc, year = year(date)) |>
  summarise(n_within = sum(n_within),
            attend = sum(attend)) |>
  write_csv("data/summd_group.csv")

hosps <- ae_activity |>
  slice_sample(n = 5) |>
  pull(loc) |>
  unique()

T202H <- ae_activity |>
  filter(loc == "W107H") |>
  mutate(date = ymd(date))

ae_activity |>
  filter(loc %in% hosps) |>
  mutate(date = ymd(date)) |>
  ggplot(aes(x = date, y = n_within/attend, group = loc)) +   geom_line() +
  geom_line(data = T202H, aes(x = date, y = n_within/attend), color = "red") 



