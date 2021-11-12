
## Permet l'organisation du dashboard ##

ui <- dashboardPage(
  
  ## Affiche le titre du dashboard ##
  dashboardHeader(title = "Les meilleurs airBnB"),
  
  ## Permet de creer plusieurs onglets pour le dashboard ##
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("AirBnB les plus rentables", tabName = "cheapest_value"),
      menuItem("AirBnB les mieux notes", tabName = "better_place"),
      menuItem("Localisation des airBnB", tabName = "localisation")
    )
  ),
  
  ## Organisation des differentes fenetres ##
  dashboardBody(
    
    tabItems(
      
      ## Premier onglet qui contiendra nos input (ville, nombre de locataires, nombre de chambre) ##
      ## ainsi que l'histogramme des dix arrondissements les moins cher de la ville en plus de la  ##
      ## liste des cinq etablissements les moins chers ##
      tabItem("cheapest_value",
              fluidRow(box(selectInput("v_city", "Ville", selected = "Paris",
                                       choices = airBnB_data %>%
                                         select(city) %>%
                                         distinct() %>%
                                         arrange(city)))),
              fluidRow(box(sliderInput("v_accommodates", "Nombre de locataires", 1, 15, value = 2)),
                       box(sliderInput("v_bedrooms", "Nombre de chambre", 1, 10, value = 1))),
              fluidRow(box(plotOutput("mean_price_by_neighbourhood")), 
                       box(dataTableOutput("cheapest_airBnB"), "Les 5 etablissements les moins chers")),
      ),
      
      ## Deuxieme onglet qui contiendra les differents scores des hotes puis la moyenne des scores ##
      ## par quartier ##
      tabItem("better_place",
              fluidRow(box(plotOutput("a_city_compare_to_the_world")),
                       box(dataTableOutput("list_of_score_by_neighbourhood"), "Moyennes de scores par quartier"))
              ),
      
      ## Troisieme onglet, la carte ##
      tabItem("localisation",
              fluidPage(
                titlePanel("Les cinq AirBnB les plus rentables"),
                mainPanel(leafletOutput("map"))
              )
      )
    )
  )
)