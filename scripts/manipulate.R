## Author: Austin Stephen
## Date: 3/6/2022
## Purpose: Takes in a single seasons of data at the player level, summarizes the
#          data into features that are potentially useful for model building, 
#          joins all of the seasons into a single table, saves it as a csv.
#   
#          Why not just use the data as it comes? 
#           - The features created by the aggregate functions summarize a teams 
#             performance up to that point in
#             the season while leaving out the observation game. The nba data
#             only comes on a per game basis, not very useful for predicting the
#             outcome of that game.

# get functions macro_joins(), aggregate_player(),aggregate_team()
source("scripts/functions.R")

# Single Seasons of Player Summaries ----------------------------------------
p14 <- read.csv("data/2014_by_player.csv")
p15 <- read.csv("data/2015_by_player.csv")
p16 <- read.csv("data/2016_by_player.csv")
p17 <- read.csv("data/2017_by_player.csv")
p18 <- read.csv("data/2018_by_player.csv")
p19 <- read.csv("data/2019_by_player.csv")

main_frame <- rbind(p14,p15,p16,p17,p18,p19)

# Building player dataset ---------------------------------------------------

## getting highlevel team data for each year
p14 <- macro_joins(p14,2014)
p15 <- macro_joins(p15,2015)
p16 <- macro_joins(p16,2016)
p17 <- macro_joins(p17,2017)
p18 <- macro_joins(p18,2018)
p19 <- macro_joins(p19,2019)

## aggregating season stats for each year
mod_p14 <- aggregate_player(p14)

mod_p15 <- aggregate_player(p15)

mod_p16 <- aggregate_player(p16)

mod_p17 <- aggregate_player(p17)

mod_p18 <- aggregate_player(p18)

mod_p19 <- aggregate_player(p19)


full_data_by_player <- rbind(mod_p14,mod_p15,mod_p16,mod_p17,mod_p18,mod_p19)

tmp3 <- full_data_by_player %>% select(player_id, team_id, game_id, agg_ptsTeam:agg_pfTeam)

write.csv(full_data_by_player,"data/full_data_by_player.csv",row.names = FALSE)


# Building team dataset ---------------------------------------------------------------

## aggregating season stats for each year
mod_p14 <- aggregateTeam(2014)

mod_p15 <- aggregateTeam(2015)

mod_p16 <- aggregateTeam(2016)

mod_p17 <- aggregateTeam(2017)

mod_p18 <- aggregateTeam(2018)

mod_p19 <- aggregateTeam(2019)


full_data_by_team <- rbind(mod_p14,mod_p15,mod_p16,mod_p17,mod_p18,mod_p19)



# Transform with respect to one game
full_data_by_team <- ungroup(full_data_by_team)
team_home <- full_data_by_team %>% filter(locationGame == 'H' )
team_away <- full_data_by_team %>% filter(locationGame == 'A' )
colnames(team_away) <- paste("opp", colnames(team_away), sep = "_")
full_data_by_team <- merge(x = team_home,
              y = team_away,
              by.x = "game_id",
              by.y = "opp_game_id") %>%
  select(-c(opp_team_id,)) %>%
  # combine  information that makes more sense together
  mutate(WL_diff = WL_ratio - opp_WL_ratio,
         rest_diff = daysRest - opp_daysRest)%>%
  select(-c(WL_ratio, opp_WL_ratio, daysRest, opp_daysRest, opp_segSeason,
            opp_locationGame))
  

write.csv(full_data_by_team,"data/full_data_by_team.csv",row.names = FALSE)
