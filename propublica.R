# propublica.R 

library(httr)
library(jsonlite)
library(stringr)
library(ggplot2)
library(dplyr)
source("api-key.R")
#setwd("~/Desktop/info201/a7--Preciousstowers/App")

# ------ this recievies the whole data frame ----------------

congress = "116"
chamber = "house"
query_params <- list(key = propublica_api_key)
base_uri <- "https://api.propublica.org/congress/v1/"
endpoint <- paste0(base_uri, congress, "/",chamber, "/members.json")
response_data <- GET(endpoint, add_headers('X-API-key' = propublica_api_key))
response_text <- content(response_data, type = "text")
response_data <- fromJSON(response_text)
response_all <- flatten(response_data$results)
all_members <- data.frame(response_all$members)


# ------ creates a function and passes parameters state and chamber to recieve 
# information on a specific state --------------
state <- "WA"
chamber <- "house"

propublica <- function(chamber = "house", state = "WA") {
  query_params <- list(key = propublica_api_key)
  base_uri <- "https://api.propublica.org/congress/v1/members/"
  endpoint <- paste0(base_uri, chamber, "/", state, "/current.json")
  response_data <- GET(endpoint, add_headers('X-API-key' = propublica_api_key))
  response_text <- content(response_data, "text")
  response_data <- fromJSON(response_text)
  results <- as.data.frame(response_data$results)
}

test_one <- propublica(chamber, state)



#----- member age function and data wrangling ---------


get_age <- function(member_id){
  member_age <- member(member_id)
  age = floor(as.numeric(Sys.Date() - as.Date(member_age$date_of_birth))/365)
}

member_test <- get_age(member_id)


full_member <- function(state){
  df <- propublica(chamber, state)
    rep <- df %>%
      mutate(full_name = paste0(first_name, " ", last_name)) %>%
      select(full_name, party, twitter_id, id, facebook_account) %>%
      mutate(age = lapply(id, get_age)) %>%
    select(full_name, age, party, twitter_id, facebook_account)
}

more_stuff <- full_member(state)


#---- filtered function for state data table -------
# --------- these will go into server ----------

default_data <- function(chamber, state){
   df <- propublica(chamber, state) %>%
     mutate(Age = lapply(member_id, get_age)) %>%
     select(name, twitter_id, facebook_account, party)
 }
 
 test123 <- default_data("house", "WA")


#---------- creates function for member ID -----------

#  https://api.propublica.org/congress/v1/members/{member}.json

member_id <- "N000189"

member <- function(member_id = "N000189"){
  base_uri <- "https://api.propublica.org/congress/v1/members/"
  endpoint <- paste0(base_uri, member_id, ".json")
  response_data <- GET(endpoint, add_headers('X-API-key' = propublica_api_key))
  response_text <- content(response_data, "text")
  response_data <- fromJSON(response_text)
  results <- as.data.frame(response_data$results)
}

  
#---------- specific function ---------

default_member <- function(member_id){
  df_two <- member(member_id) %>%
    select(url, in_office, most_recent_vote, date_of_birth)
}

#--------------- calculate the age of the representative ----------

# member_age <- function(member_id){
#   base_uri <- "https://api.propublica.org/congress/v1/members/"
#   endpoint <- paste0(base_uri, member_id, ".json")
#   response_data <- GET(endpoint, add_headers('X-API-key' = propublica_api_key))
#   response_text <- content(response_data, "text")
#   response_data <- fromJSON(response_text)
#   results <- response_data$results
#   age <- floor(as.numeric(Sys.Date() - as.Date(results$date_of_birth))/365)
#   return(age)
# }
# 
# test <- member_age("N000189")
# View(test)

#--------- summary table functions --------------


# states by male of reps
gender <- function(chamber, state){
  df <- propublica(chamber, state)
  gender_data <- df %>%
    select(gender) %>%
    count(gender) %>% 
    setNames(c("gender", "number"))
}

test <- gender("house", "WA")


# states by democrat vs. republican 
party <- function(chamber, state){
  df <- propublica(chamber, state)
  gender_data <- df %>%
    select(party) %>%
    count(party) %>%
    setNames(c("party", "number"))
}

# ------visulization for functions party and gender ---------
plot <- ggplot(party(chamber, state)) +
  geom_col(aes(x = party, y = number, fill = party)) +
  scale_fill_manual(values = c("blue", "red")) +
  ggtitle("Democratic vs. Republican") +
  xlab("party") +
  ylab("number of canidates") +
  coord_flip() 


ggplot(gender(chamber, state)) +
  geom_col(aes(x = gender, y = number, fill = gender)) +
  scale_fill_manual(values = c("pink", "blue")) +
  ggtitle("Gender of Representatives") +
  xlab("Gender") +
  ylab("number of Representatives") +
  coord_flip()

#-------member filtering -----

only_members <- all_members %>%
  select(id)


states <- all_members %>%
  group_by(state) %>%
  summarise()

