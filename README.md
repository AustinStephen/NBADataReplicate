# NBADataReplicate
Author: Austin Stephen  

Date: 3/6/2022

## Purpose 
Hosts the data and scripts used to aggregate data used in the MLR3 gallery post "Modeling NBA Game Outcome".

## Instructions
To access the data simply read the csv files into your R enviornment.

To those interested in adding new feature columns, or adding more recent games the 
scripts directory contains the code used to scrape the data from nba.com curtosey 
of the nbaR and nbaStatR packages.

To replicate

1) Aggregate each season and write the results by running the scripts titled data_make_team_*.R

This can easily be extended to future season by creating a new script and changing the dates.

2) run manipulate.R to aggregate the data and create the feature columns.

## Column Specification

*_id: Unique identifier for what is replacd by the star.

agg_*: The rolling season average of the following statistic.  

agg_*Team: The rolling season average of the following statistic with respect to the whole team.
              
plusminusTeam: number of points the team won by (pos) or lost by (neg)