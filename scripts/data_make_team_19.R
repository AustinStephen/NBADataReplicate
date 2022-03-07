## AUTHOR: Austin Stephen
## Date: 3/6/2022
## PURPOSE: Scrapes three categories of statistics on 19/20 season at the 
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

gameIDs19 <- game_logs(
  seasons = c(2019),
  result_types = "team")

## ordering by game 
gameIDs19 <- arrange(gameIDs19,idGame)

## removing duplicate game IDs
gameIDs19 <- gameIDs19$idGame %>% unique()

player_2019_traditional <- c()
player_2019_misc <- c()
player_2019_advanced <- c()

API_calls <- function(type,id)
{
  get_boxscore(game_id= id,
               boxscore_type = type)
}

## traditional data
for(i in gameIDs19){
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
  
  player_2019_traditional <- rbind(tmp,player_2019_traditional)
}


## misc data
for(i in gameIDs19){
  Sys.sleep(rnorm(1,mean=1, sd=.1))
  ## timeout the function if the call gets stuck
  tmp <- withTimeout(
    {
      API_calls("misc",i);
    },
    timeout=60,
    onTimeout="warning")
  
  player_2019_misc <- rbind(tmp,player_2019_misc)
}


## adv. data
for(i in gameIDs19){
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
  
  player_2019_advanced <- rbind(tmp,player_2019_advanced)
}

## joining the 3 tables 
# first 2
team_2019 <- merge(
  x = player_2019_traditional,
  y= player_2019_misc,
  by = c("game_id","player_id")
)

# 3rd and dropping duplicate cols
team_2019 <- merge(
  x = team_2019,
  y= player_2019_advanced,
  by = c("game_id","player_id")) %>% 
  select(-c("team_id.x","team_abbreviation.x","team_city.x","player_name.x",
            "nickname.x","start_position.x","comment.x","blk.x","pf.x",
            "mins.x","secs.x","nickname.y","mins.y","secs.y","blk.y",
            "team_id.y","player_name.y","start_position.y","comment.y",
            "team_abbreviation.y","team_city.y"))

write.csv(team_2019,"player_data_2019.csv",row.names = FALSE)