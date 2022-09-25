## Author: Austin Stephen
## Date: 3/6/2022
## Purpose: Declares the functions used in manipulate.R
library(tidyverse)
library(nbastatR)

# running_total() ---------------------------------------------------------
# vectorized function that computes cumulative average less the observation 

running_total <- function(vector){
  (cumsum(vector) - vector)
}



# marco_joins() -----------------------------------------------------------
# Joins with game outcome and team information

macro_joins <- function(data,year)
{
  team <- game_logs(
    seasons = c(year),
    result_types = "team") %>% 
    select(idGame,idTeam,plusminusTeam,ptsTeam,pctFG3Team,
           pctFG2Team,astTeam,stlTeam,blkTeam,tovTeam,pfTeam)
  
  merge(data, 
        team,
        by.x = c("game_id","team_id"),
        by.y = c("idGame","idTeam"))
}


# aggregatePlayer() -------------------------------------------------------------
# takes a dataframe with the exact structure given by the web scraper and
# returns the aggregated version of that dataframe.

aggregate_player <- function(dataframe){
  
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
      ## team level identity
      agg_plusminusTeam = running_total(plusminusTeam),
      agg_ptsTeam = running_total(ptsTeam),
      agg_pctFG3Team = running_total(pctFG3Team),
      agg_pctFG2Team = running_total(pctFG2Team),
      agg_astTeam = running_total(astTeam),
      agg_stlTeam = running_total(stlTeam),
      agg_blkTeam = running_total(blkTeam),
      agg_tovTeam = running_total(tovTeam),
      agg_pfTeam = running_total(pfTeam),
      plusminusTeam = plusminusTeam,
      ## identity
      plusminusTeam = plusminusTeam
    )%>%
    filter(!is.na(agg_points))
}

# aggregateTeam() -------------------------------------------------------------
# takes a dataframe with the exact structure given by the web scraper and
# returns the aggregated version of that dataframe.

aggregateTeam <- function(year){
game_logs(
    seasons = c(year),
    result_types = "team") %>% 
    select(idGame,idTeam,plusminusTeam,ptsTeam,pctFG3Team,
           pctFG2Team, astTeam, stlTeam, blkTeam, tovTeam, pfTeam, orebTeam,
           drebTeam, ftmTeam, isB2BSecond, locationGame, countDaysRestTeam) %>%
    group_by(idTeam)%>%
    transmute(
      ## Identity mapping
      game_id = idGame,
      team_id = idTeam,
      # Other
      game = row_number(),
      ## Team stats
      agg_plusminusTeam = running_total(plusminusTeam)/game, # /game scales the sum
      agg_ptsTeam = running_total(ptsTeam)/game,
      agg_pctFG3Team = running_total(pctFG3Team)/game,
      agg_pctFG2Team = running_total(pctFG2Team)/game,
      agg_astTeam = running_total(astTeam)/game,
      agg_stlTeam = running_total(stlTeam)/game,
      agg_blkTeam = running_total(blkTeam)/game,
      agg_tovTeam = running_total(tovTeam)/game,
      agg_pfTeam = running_total(pfTeam)/game,
      agg_orebTeam = running_total(orebTeam)/game,
      agg_drebTeam = running_total(drebTeam)/game,
      agg_ftmTeam = running_total(ftmTeam)/game,
      ## not aggregated
      daysRest = countDaysRestTeam,
      B2BTeam = isB2BSecond,
      locationGame = locationGame,
      plusminusTeam = plusminusTeam,
      # Segment of season 
      segSeason = case_when(
        game < 20 ~ 1,
        game < 40 ~ 2,
        game < 60 ~ 3,
        TRUE ~ 4
      ),
      # count wins
      win = case_when(plusminusTeam > 0 ~ 1,
                      plusminusTeam <= 0  ~ 0 ),
      # compute prior win ratio
      WL_ratio = case_when( game > 1 ~ (cumsum(win)-win) / game,
                              TRUE ~ 0)
    ) %>%
    filter(!is.na(agg_plusminusTeam))
}

