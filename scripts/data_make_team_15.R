## AUTHOR: Austin Stephen
## Date: 3/6/22
## PURPOSE: Scrapes three categories of statistics on 14/15 season at the 
#           player level from the NBA website, aggregates them, 
#           and writes them to a csv.
# 
# Note: for-loops with sleep calls protect the API from getting bombarded 
#       by multiple calls a second that causes a high percentage of them to 
#       fail, however, this makes the script take longer to collect all of the 
#       data.

library(tidyverse)
library(nbastatR)
library(NBAr)
library(R.utils)

gameIDs15 <- game_logs(
  seasons = c(2015),
  result_types = "team")

## ordering by game 
gameIDs15 <- arrange(gameIDs15,idGame)

## removing duplicate game IDs
gameIDs15 <- gameIDs15$idGame %>% unique()

player_2015_traditional <- c()
player_2015_misc <- c()
player_2015_advanced <- c()

API_calls <- function(type,id)
{
  get_boxscore(game_id= id,
               boxscore_type = type)
}

## traditional data
for(i in gameIDs15){
  Sys.sleep(rnorm(1,mean=1, sd=.1))
  ## timeout the function if the call gets stuck
  tryCatch({
    tmp <- withTimeout(
      {
        API_calls("traditional",i);
      },
      timeout=60,
      onTimeout="warning")
  })
  
  player_2015_traditional <- rbind(tmp,player_2015_traditional)
}


## misc data
for(i in gameIDs15){
  Sys.sleep(rnorm(1,mean=1, sd=.1))
  ## timeout the function if the call gets stuck
  tmp <- withTimeout(
    {
      API_calls("misc",i);
    },
    timeout=60,
    onTimeout="warning")
  
  player_2015_misc <- rbind(tmp,player_2015_misc)
}


## adv. data
for(i in gameIDs15){
  Sys.sleep(rnorm(1,mean=1, sd=.1))
  ## timeout the function if the call gets stuck
  tryCatch({
    tmp <- withTimeout(
      {
        API_calls("advanced",i);
      },
      timeout=60,
      onTimeout="warning")
  })
  
  player_2015_advanced <- rbind(tmp,player_2015_advanced)
}

## joining the 3 tables 
# first 2
team_2015 <- merge(
  x = player_2015_traditional,
  y= player_2015_misc,
  by = c("game_id","player_id")
)

# 3rd and dropping duplicate cols
team_2015 <- merge(
  x = team_2015,
  y= player_2015_advanced,
  by = c("game_id","player_id")) %>% 
  select(-c("team_id.x","team_abbreviation.x","team_city.x","player_name.x",
            "nickname.x","start_position.x","comment.x","blk.x","pf.x",
            "mins.x","secs.x","nickname.y","mins.y","secs.y","blk.y",
            "team_id.y","player_name.y","start_position.y","comment.y",
            "team_abbreviation.y","team_city.y"))

write.csv(team_2015,"player_data_2015.csv",row.names = FALSE)