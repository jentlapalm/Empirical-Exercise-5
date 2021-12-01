# loading packages
library(data.table)
library(igraph)
library(tidyverse)
library(lubridate)

# set working directory
setwd("C:\\Users\\jentl\\Documents\\Emory\\Fall 2021\\Social Network Analytics\\EE#5")

# loading data
comp <- fread('company_details.csv')
deals <- fread('deal_details.csv')
invest <- fread('investor_details.csv')
invdeal <- fread('investors_and_deals.csv')

# setting up network for analysis

# getting venture capital investors
invest <- invest[Investor_Type=='Venture Capital']

# deals from 1990 onwards
deals$Deal_Date <- as_date(deals$Deal_Date)

deals <- deals[year(Deal_Date)>=1990]

"We can define a status relationship for a pair of firms (A→B) as the proportion of times that
Firm A has served as a lead investor in deals it has participated in with Firm B"

"Count(Deals with B where A is lead)/total deals with B"

"Let this proportion be the the entries of a matrix representing a relationship between each
of the investors. The diagonals of this matrix should be 0."

# only need deals with more than one investor to calculate status
codeals <- invdeal[,.N,by=Deal_Id][N>1]

# deals dataset limited to deals with at least 2 investors
subdeals <- invdeal[Deal_Id %in% codeals$Deal_Id]



# count how many had A as the lead investor


"Then, each investor’s status can be represented as the Bonacich centrality of this matrix—an investor’s status is represented by its ability to be a leader on deals, as well as to be connected to other firms that lead their own deals. You can calculate Bonacich centrality using power_centrality() with the argument exponent = 0.75 to represent the commonly-used beta parameter. For the analysis, only consider firms that are actually a part of the status hierarchy, i.e., have co-invested with other firms and have non-missing values for status. To allow older ties to weaken over time, you can exclude ties that have not been renewed after five years."