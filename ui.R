#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
source("propublica.R")


page_one <- tabPanel(
    "About Program",
    titlePanel("A7 Summary Page"),
    h3(strong("Overview:")),
    p("This assignment introduces the concept of API's and JSON files, 
    in combination of functions and dplyr to create a functioning shiny 
    application."),
    br(),
    p("The application consists of three pages, an overview, a page about the 
    state representatives and a summary page. The overview page introduces the 
    programmer to the user, including their name, affiliation, what the 
    program does and some of the struggles the programmer went through in 
    order to complete the application. The state representatives page 
    consists of two working widgets, a drop down the state codes and 
    another with the representative ids, in which the user can select 
    a state or a representative and an table will pop up with the 
    representatives of the state and/or details about the representative."),
    br(),
    p("The final page consists of a program summary, showing one widget that is
    interactive with two bar charts. The user is able to pick a state and the
    bar charts will show the democratic vs. republican state representatives
    and female vs. male representatives. This cis the closing of the 
    application, because it provides the user with a general and base line idea
    with who the state representatives are, where they are located and 
    questions the idea of gender and parties within today’s political arena."),
    br(),
    a(href = "https://www.propublica.org/datastore/api/propublica-congress-api", "Click here for Data Set"),
    h3("Affiliation:"),
    p("Precious Stowers - Freshman - INFO-201A: Technical Foundations of 
      Informatics, The Information School, University of Washington, 
      Autumn 2019. "),
    h3(strong("Reflective Statement:")),
    p("Throughout this assignment, I found thinking a deeper level about a function and the 
      code itself to be continuously hard. For example, creating the bar graphs using ggplot 
      to be interactive using only one widget was one of the functions that took myself multiple
      hours to create, despite it being such a small function. In order to find my solution, 
      I realized that I needed to pay attention to the details and not rush through creating a program. 
      The details can bring a program to the next level without incorporating mass amounts of change. "),
)
    



page_two <- tabPanel(
    "State Representatives",
    titlePanel("Query Page"),
    sidebarLayout(
        sidebarPanel(
            selectInput("state_dropdown", label = h3("Select a state"), 
                        choices = list("states" = states$state), 
                        selected = 1),
            selectInput("rep_dropdown", label = h3("Select a representative"), 
                        choices = list("representatives" = only_members$id), 
                        selected = 1),
                ),
        mainPanel( 
                 DT::dataTableOutput("datatable"),
                 DT::dataTableOutput("reptable")
          )
       )
    )



page_three <- tabPanel(
    "Program Summary",
    titlePanel("Summary Page"),
    sidebarLayout(
      sidebarPanel(
        selectInput("state_gender", label = p("Select a state"), 
                    choices = list("states" = states$state), 
                    selected = 1),
        p("This shows the male vs. female representatives
             per state \n and the democratic vs. republicans per state."),
              ),
        mainPanel(
    h3(" Male vs. Female reps per state:"),
    plotOutput("male_and_female", width = "100%"),
    br(),
    h3("Democrat vs Republican per state:"),
    plotOutput("dem_or_rep", width = "100%"),
         ),
    ),
)


ui <- navbarPage(
    "A7 Assignment",
    page_one,
    page_two,
    page_three
)