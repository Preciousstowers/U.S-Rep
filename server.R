#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


library(shiny)
source("propublica.R")


# ---- state by representatives dplyr filtering -------
states <- all_members %>%
    group_by(state) %>%
    summarise()

# ---- filtered function for specific columns -----

default_data <- function(chamber, state){
    df <- propublica(chamber, state) %>%
    group_by(first_name, 
             middle_name, last_name, 
             party, twitter_id, facebook_account) %>%
    summarise()
}


# ---- age function ----------

get_age <- function(member_id = "L000560"){
  df <- member(member_id)
  age = as.integer(round(Sys.Date() - as.Date(df$date_of_birth))/365)
}

pro <- function(chamber = "house", state = "WA"){
  df <- propublica(chamber, state)
  rep <- df %>%
    select(name, party, twitter_id, id, facebook_account) %>%
    mutate(age = lapply(member_id, get_age))
  
}
#--------- gender function ---------
gender <- function(chamber, state){
    df <- propublica(chamber, state)
    gender_data <- df %>%
        select(gender) %>%
        count(gender) %>%
        setNames(c("gender", "number"))
}

#-------- party function -------
party <- function(chamber, state){
  df <- propublica(chamber, state)
  gender_data <- df %>%
    select(party) %>%
    count(party) %>%
    setNames(c("party", "number"))
}

# ---- start of the server function ---------
shinyServer(function(input, output) {
 
    output$state_dropdown <- renderPrint({ 
     input$state_dropdown # state drop down widget
     
     })
 
  output$datatable <- DT::renderDataTable( 
     full_member(input$state_dropdown)) #interactive data frame
  
  output$rep_dropdown <- renderPrint({ 
      input$rep_dropdown # representatives drop down widget
  
    })
  
  output$reptable <- DT::renderDataTable(
      default_member(input$rep_dropdown)
      ) #interactive data frame

  output$state_gender <- renderPrint({ 
      input$state_gender # This widget shows the state and changes the 
    # input of both of the ggplot graphs below
      
  })

  output$male_and_female <- renderPlot(
      
      # Renders a male vs. female barplot
      ggplot(gender(chamber, input$state_gender)) +
        geom_col(aes(x = gender, y = number, fill = gender)) +
        scale_fill_manual(values = c( F = "pink", M = "blue")) +
        ggtitle("Gender of Representatives") +
        xlab("Gender") +
        ylab("number of Representatives") +
        coord_flip(),
        height = 400, width = 600
    
  )
  
  output$dem_or_rep <- renderPlot(
      
      # Renders a dem vs.rep bar plot
    ggplot(party(chamber, input$state_gender)) +
      geom_col(aes(x = party, y = number, fill = party)) +
      scale_fill_manual(values = c( D = "blue", R = "red")) +
      ggtitle("Democratic vs. Republican") +
      xlab("party") +
      ylab("number of canidates") +
      coord_flip(),
      height = 400, width = 600
  )
})
 
