## Author: Austin Stephen
## Date: 3/6/2022
## Purpose: Takes in a single seasons of data at the player level, summarizes the
#          data into features that are potentially useful for model building, 
#          joins all of the seasons into a single table, saves it as a csv.


library(tidyverse)
library(nbastatR)
library(NBAr)

# Single Seasons of Player Summaries ----------------------------------------
p14 <- read.csv("data/2014_by_player.csv")
p15 <- read.csv("../data/2015_by_player.csv")
p16 <- read.csv("../data/2016_by_player.csv")
p17 <- read.csv("../data/2017_by_player.csv")
p18 <- read.csv("../data/2018_by_player.csv")
p19 <- read.csv("../data/2019_by_player.csv")

main_frame <- rbind(p14,p15,p16,p17,p18,p19)

# Functions ----------------------------------------------------------------

## 1. vectorized function that computes cumulative average less the observation 
running_total <- function(vector){
  (cumsum(vector) - vector)/ (row_number()-1) 
}

## 2. Joins with game outcome and team information

macro_joins <- function(data,year)
{
  team_14 <- game_logs(
    seasons = c(year),
    result_types = "team") %>% 
    select(idGame,idTeam,plusminusTeam,ptsTeam,pctFG3Team,
           pctFG2Team,astTeam,stlTeam,blkTeam,tovTeam,pfTeam)
  
  merge(data, 
        team_14,
        by.x = c("game_id","team_id"),
        by.y = c("idGame","idTeam"))
}

## 3. input a dataframe of the extact structure given by the web scraper and
#   return the aggregated version of that dataframe 
aggregate <- function(dataframe){
  
  dataframe %>% 
    group_by(player_id) %>%
    transmute(
      ## Identity mapping 
      game_id = game_id,
      team_id = team_id,
      start_position = as.factor(start_position),
      ## season aggregation 
      agg_points = running_total(pts),
      agg_fgm =  running_total(fgm),
      agg_fga =  running_total(fga),
      agg_fg_pct =  running_total(fg_pct),
      agg_fg3m =  running_total(fg3m),
      agg_fg3a =  running_total(fg3a),
      agg_fg3_pct =  running_total(fg3_pct),
      agg_ft_pct =  running_total(ft_pct),
      agg_oreb =  running_total(oreb),
      agg_dreb =  running_total(dreb),
      agg_reb =  running_total(reb),
      agg_ast =  running_total(ast),
      agg_stl =  running_total(stl),
      agg_to =  running_total(to),
      agg_plus_minus =  running_total(plus_minus),
      agg_pts_off_tov =  running_total(pts_off_tov),
      agg_pts_2nd_chance =  running_total(pts_2nd_chance),
      agg_pts_fb = running_total(pts_2nd_chance),
      agg_pts_paint = running_total(pts_paint),
      agg_opp_pts_off_tov = running_total(opp_pts_off_tov),
      agg_opp_pts_2nd_chance = running_total(opp_pts_2nd_chance),
      agg_opp_pts_fb = running_total(opp_pts_fb),
      agg_opp_pts_paint = running_total(opp_pts_paint),
      agg_blka = running_total(blka),
      agg_ast_ratio = running_total(ast_ratio),
      agg_off_rating = running_total(off_rating),
      agg_net_rating = running_total(net_rating),
      agg_def_rating = running_total(def_rating),
      agg_pace_per40 = running_total(pace_per40),
      agg_pie = running_total(pie),
      agg_pos = running_total(poss),
      ## team level aggregation
      agg_plusminusTeam = running_total(plusminusTeam),
      agg_ptsTeam = running_total(ptsTeam),
      agg_pctFG3Team = running_total(pctFG3Team),
      agg_pctFG2Team = running_total(pctFG2Team),
      agg_astTeam = running_total(astTeam),
      agg_stlTeam = running_total(stlTeam),
      agg_blkTeam = running_total(blkTeam),
      agg_tovTeam = running_total(tovTeam),
      agg_pfTeam = running_total(pfTeam),
      ## team level identity
      plusminusTeam = plusminusTeam
    )%>%
    filter(!is.na(agg_points))
}


# Building main dataset ---------------------------------------------------

## getting highlevel team data for each year
p14 <- macro_joins(p14,2014)
p15 <- macro_joins(p15,2015)
p16 <- macro_joins(p16,2016)
p17 <- macro_joins(p17,2017)
p18 <- macro_joins(p18,2018)
p19 <- macro_joins(p19,2019)

## aggregating season stats for each year
mod_p14 <- aggregate(p14)

mod_p15 <- aggregate(p15)

mod_p16 <- aggregate(p16)

mod_p17 <- aggregate(p17)

mod_p18 <- aggregate(p18)

mod_p19 <- aggregate(p19)


full_data <- rbind(mod_p14,mod_p15,mod_p16,mod_p17,mod_p18,mod_p19)

write.csv(full_data,"data/full_data.csv",row.names = FALSE)
