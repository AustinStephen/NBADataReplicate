# NBADataReplicate
Author: Austin Stephen  
Date: 3/6/2022  
Contact: astepehn@uwyo.edu

## Purpose 
The csv files and scripts that aggregate the data used in the mlr3 gallery post "Modeling NBA Game Outcome" and 
"AutoML System to Predict the Outcome of an NBA Game".

## Instructions
To access the data simply read the csv files into your R enviornment.

For those interested in examing the scripts used to collect the data to add new features or 
more recent games the scripts directory contains the Rscripts used to scrape the data.

To replicate:

1) Aggregate each season and write the results by running the scripts titled data_make_team_*.R .
This can easily be extended to future seasons by creating a new script via the same naming
conventions and changing the dates.

2) run manipulate.R to aggregate the data and create the feature columns. 
The function aggregate() contains the feature construction code and can be modified to add new features.

## Column Specification

*_id: Unique identifier for what is replacd by the star.

agg_*: The rolling season average of the following statistic.  

agg_*Team: The rolling season average of the following statistic with respect to the whole team.
              
plusminusTeam: number of points the team won by (pos) or lost by (neg)