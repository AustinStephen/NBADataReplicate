# NBADataReplicate
Author: Austin Stephen  

Date: 3/6/2022

## Purpose 
Hosts the data and scripts used to aggregate data used in the MLR3 gallery post "Modeling NBA Game Outcome".

## Instructions
- Access the data
The CSV files are in the data directory. These can be read into your R enviornment and work out of the box.

- Replicate data collection
Those interested in extending these techniques, or adding more recent games the scripts directory contains 
the code used to scrape the data from nba.com curtosey of the nbaR and nbaStatR packages.

1) Aggregate each season and write the results by running the scripts titled data_make_team_**.R

- This can easily be extended to future season by creating a new script and changing the dates.

2) run manipulate.R to aggregate the data and create the feature columns.

## Column Specification

player_id: unique player id

game_id: unique game id
