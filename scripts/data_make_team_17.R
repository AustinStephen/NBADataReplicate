## AUTHOR: Austin Stephen
## Date: 3/6/22
## PURPOSE: Scrapes three categories of statistics on 16/17 season at the 
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

gameIDs17 <- game_logs(
  seasons = c(2017),
  result_types = "team")

## ordering by game 
gameIDs17 <- arrange(gameIDs17,idGame)

## removing duplicate game IDs
gameIDs17 <- gameIDs17$idGame %>% unique()

player_2017_traditional <- c()
player_2017_misc <- c()
player_2017_advanced <- c()

API_calls <- function(type,id)
{
  get_boxscore(game_id= id,
               boxscore_type = type)
}

## traditional data
for(i in gameIDs17){
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
  
  player_2017_traditional <- rbind(tmp,player_2017_traditional)
}


## misc data
for(i in gameIDs17){
  Sys.sleep(rnorm(1,mean=1, sd=.1))
  ## timeout the function if the call gets stuck
  tmp <- withTimeout(
    {
      API_calls("misc",i);
    },
    timeout=60,
    onTimeout="warning")
  
  player_2017_misc <- rbind(tmp,player_2017_misc)
}


## adv. data
for(i in gameIDs17){
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
  
  player_2017_advanced <- rbind(tmp,player_2017_advanced)
}

## joining the 3 tables 
# first 2
team_2017 <- merge(
  x = player_2017_traditional,
  y= player_2017_misc,
  by = c("game_id","player_id")
)

# 3rd and dropping duplicate cols
team_2017 <- merge(
  x = team_2017,
  y= player_2017_advanced,
  by = c("game_id","player_id")) %>% 
  select(-c("team_id.x","team_abbreviation.x","team_city.x","player_name.x",
            "nickname.x","start_position.x","comment.x","blk.x","pf.x",
            "mins.x","secs.x","nickname.y","mins.y","secs.y","blk.y",
            "team_id.y","player_name.y","start_position.y","comment.y",
            "team_abbreviation.y","team_city.y"))

write.csv(team_2017,"player_data_2017.csv",row.names = FALSE)