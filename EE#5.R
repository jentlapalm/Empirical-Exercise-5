# loading packages
library(data.table)
library(igraph)
library(tidyverse)
library(lubridate)

# set working directory
setwd("C:\\Users\\Jent\\Documents\\College\\Emory\\Social Network Analytics\\EE#5")

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

'joins approach'
j <- '10013-77'

temp1 <- invdeal[Investor_Id==j] # deals investor is a part of
temp2 <- invdeal[temp1,on='Deal_Id'] # all investors on these deals
d <- temp2[, .N, by=Investor_Id] # N represents total deals with investor j
temp3 <- invdeal[Investor_Id==j & Lead_Investor==1] # lead investor deals
temp4 <- invdeal[temp3, on='Deal_Id'] # all investors on these deals
ld <- temp4[, .N, by=Investor_Id] #number of lead deals between investor j and others
d[ld, on='Investor_Id', status:=i.N/N] #status column between investor j and Investor_id Column

"initial approach"
 
# only need deals with more than one investor to calculate status
codeals <- invdeal[,.N,by=Deal_Id][N>1]

# deals dataset limited to deals with at least 2 investors
subdeals <- invdeal[Deal_Id %in% codeals$Deal_Id]

# grab deals where investor is a lead
j <- '10013-77' # investor with many deals for testing

temp_deals <- subdeals[Investor_Id==j & Lead_Investor==1,Deal_Id]
subdeals[Deal_Id %in% temp_deals]

# looking for a result with multiple deals
for (i in 1:100){
  temp_deals <- subdeals[Investor_Id==unique(subdeals$Investor_Id)[i] & 
                           Lead_Investor==1,Deal_Id]
  if(length(temp_deals)>1){
    print('investor')
    print(unique(subdeals$Investor_Id)[i])
    print('deals')
    print(temp_deals)
  }
}

"Then, each investor’s status can be represented as the Bonacich centrality of this matrix—an investor’s status is represented by its ability to be a leader on deals, as well as to be connected to other firms that lead their own deals. You can calculate Bonacich centrality using power_centrality() with the argument exponent = 0.75 to represent the commonly-used beta parameter. For the analysis, only consider firms that are actually a part of the status hierarchy, i.e., have co-invested with other firms and have non-missing values for status. To allow older ties to weaken over time, you can exclude ties that have not been renewed after five years."