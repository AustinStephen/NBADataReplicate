# NBADataReplicate
Author: Austin Stephen  
Date: 3/6/2022  
Contact: astepehn@uwyo.edu

## Purpose 
The csv files and scripts to aggregate the data used in the mlr3 gallery posts "Modeling NBA Game Outcome" and 
"AutoML System to Predict the Outcome of an NBA Game".

## Instructions
To access the data simply read the csv files in the *data* directory into your R enviornment.

For those interested in examing the code used to collect the data, the directory *scripts* contains the Rscripts used to scrape the data.

To replicate data collection:

1) Aggregate each season and write the results to a csv file by running the scripts titled **data_make_team_*.R** .
This can easily be extended to future seasons by creating a new script via the same naming
conventions and changing the dates in the file.

2) Run **manipulate.R** to aggregate the results in the individual csv files and create the feature columns. 
The function aggregate() contains the feature construction code, and can be extended to add new features.

## Column Specification

*_id: Unique identifier for what is replacd by the star.

agg_*: The rolling season average of statistic replaced by the * with respect to an individual player.  

agg_*Team: The rolling season average of the statistic replaced by the * with respect to the whole team.
              
plusminusTeam: number of points the team won by (pos) or lost by (neg)
