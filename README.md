R_datascience

 # Heading
 AirBnB data


 ## Heading
 Rapport d'analyse

 
 L'objectif de ce projet est de comprendre comment sont répartis les scores 
 des utilisateurs, mais aussi les prix des airBnB dans l'objectif d'augmenter
 au maximum le rapport qualité/prix.
 Pour cela, nous avons d'abord trié les airBnB par prix, pour avoir les cinq
 moins chers d'une ville. Ensuite, nous les classons par scores (donc avis que
 laissent les utilisateurs).
 Une fois que nous obtenons ces données, il nous est simple de trouver le 
 airBnB voulu parmis cette grande base de donnée. Nous nous sommes également
 intéressé aux différents scores par rapport au reste du monde pour avoir un
 avis sur les points forts des airBnB de la ville.
 Egalement, il est possible de voir sur la map où se situe les cinq airBnB les
 moins chers d'une ville.


 ## Heading
 User Guide


 Il faut télécharger la data car trop volumineuse sur git, lien:
  [Dataset](https://www.kaggle.com/mysarahmadbhat/airbnb-listings-reviews).
    
 packages utilisés: 
 
 	-gapminder
	
	-dplyr 
	
	-ggplot2
	
	-shinydashboard
	
	-broom
	
	-leaflet
	
 Pour lancer l'appliquation, ouvrez main_r.R, et cliquez sur run App.
 Choisissez la ville où vous souhaitez partir ainsi que votre nombre de 
 locataires et de chambre.


 ## Heading
 Developper Guide

 Voici le main_r.R qui lance le programme.
 
  Appel des fichier code 
  
 >source("global.R")
 >source("ui.R")
 >source("server.R")    
 
  demarage de l'application 
  
 >shinyApp(ui, server)

 ### global.R ci-dessous contient les différentes librairies utilisées, la lecture
 ### du fichier .csv ainsi que les colonnes qu'on enlève de notre dataframe.

  librairies utilisees 
  
 >library(tidyverse)
 >library(shiny)
 >library(gapminder)
 >library(dplyr)
 >library(ggplot2)
 >library(shinydashboard)
 >library(tidyr)
 >library(broom)
 >library(leaflet)
 
  lecture du fichier csv 
  
 >airBnB_data <- read.csv("listings.csv")
 
  colonnes que nous n'utilisons pas 
 
 >airBnB_data$amenities <- NULL
 >airBnB_data$host_location <- NULL
 >airBnB_data$host_since <- NULL
 >airBnB_data$host_response_time <- NULL
 >airBnB_data$host_response_rate <- NULL
 >airBnB_data$host_acceptance_rate <- NULL
 >airBnB_data$host_total_listings_count <- NULL
 >airBnB_data$host_has_profile_pic <- NULL
 >airBnB_data$district <- NULL
 >airBnB_data$minimum_nights <- NULL
 >airBnB_data$maximum_nights <- NULL
 >airBnB_data$instant_bookable <- NULL

 ### ui.R va contenir le corps du dashboard, ses graphiques, input, sa carte.

  Permet l'organisation du dashboard 
  
 > ui <- dashboardPage(
 
 
      Affiche le titre du dashboard 

 >   dashboardHeader(title = "Les meilleurs airBnB"),
 
 
    Permet de creer plusieurs onglets pour le dashboard 


 >   dashboardSidebar(
 >    
 >     sidebarMenu(
 >       menuItem("AirBnB les plus rentables", tabName = "cheapest_value"),
 >       menuItem("AirBnB les mieux notes", tabName = "better_place"),
 >       menuItem("Localisation des airBnB", tabName = "localisation")
 >     )
 >   ),


     Organisation des differentes fenetres


 >   dashboardBody(
 >    
 >     tabItems(


   Premier onglet qui contiendra nos input (ville, nombre de locataires, nombre de chambre)
   ainsi que l'histogramme des dix arrondissements les moins cher de la ville en plus de la   
   liste des cinq etablissements les moins chers 
   
   
 >       tabItem("cheapest_value",
 >               fluidRow(box(selectInput("v_city", "Ville", selected = "Paris",
 >                                        choices = airBnB_data %>%
 >                                          select(city) %>%
 >                                          distinct() %>%
 >                                          arrange(city)))),
 >               fluidRow(box(sliderInput("v_accommodates", "Nombre de locataires", 1, 15, value = 2)),
 >                        box(sliderInput("v_bedrooms", "Nombre de chambre", 1, 10, value = 1))),
 >               fluidRow(box(plotOutput("mean_price_by_neighbourhood")), 
 >                        box(dataTableOutput("cheapest_airBnB"), "Les 5 etablissements les moins chers")),
 >       ),
 
 
   Deuxieme onglet qui contiendra les differents scores des hotes puis la moyenne des scores  
   par quartier  
   
   
 >       tabItem("better_place",
 >               fluidRow(box(plotOutput("a_city_compare_to_the_world")),
 >                        box(dataTableOutput("list_of_score_by_neighbourhood"), "Moyennes de scores par quartier"))
 >               ),
 >      
 >       ## Troisieme onglet, la carte ##
 >       tabItem("localisation",
 >               fluidPage(
 >                 titlePanel("Les cinq AirBnB les plus rentables"),
 >                 mainPanel(leafletOutput("map"))
 >               )
 >       )
 >     )
 >   )
 > ) 

 ### server.R qui contient les fonction qui vont faire apparaître ce que
 ### l'on désire sur le graphe

 > server <- function(input, output){
 
 
   Dataframe de la map qui nous permet de filtrer avec nos input  
   
   
 >   data_for_map <-  reactive({
 >     airBnB_data %>%
 >       filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms,
 >              host_is_superhost == "t") %>%
 >       arrange(price) %>%
 >       head()
 >   })

   Affichage de la carte du monde  
   
   
 >   output$map <- renderLeaflet({
 >     leaflet(airBnB_data) %>%
 >       addTiles() %>%
 >       fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
 >   })
 
   Place les curseurs des cinq airBnB les moins cher sur la carte 
   
   
   la ville, le nombre de chambre et le nombre de locataires sont connus  
   
   
 >   observe({
 >     leafletProxy("map", data = data_for_map()) %>%
 >       clearShapes() %>%
 >       addMarkers(label = ~listing_id)
 >   })

   Met dans un graphe les moyenne des prix par arrondissements  
   On gardera les 10 premiers  
   la ville, le nombre de chambre et le nombre de locataires sont connus 
   
   
 >   output$mean_price_by_neighbourhood <- renderPlot({
 >     airBnB_data %>%
 >       filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms) %>%
 >       select(price, city, neighbourhood) %>%
 >       group_by(neighbourhood) %>%
 >       summarise(price = mean(price)) %>%
 >       ungroup() %>%
 >        arrange(price) %>%
 >       slice(1:10) %>%
 >       ggplot(aes(x = price, y = neighbourhood)) + geom_col() + 
 >       xlab("prix par nuit") + 
 >        ylab("arrondissement") +
 >       labs(title = "Prix moyen pour les 10 arrondissement les moins chers")
 >   }) 
 
 
   Classe les moyenne des scores par arrondissements  
   On gardera les 10 premiers  
   la ville, le nombre de chambre et le nombre de locataires sont connus  
   
   
 >  output$list_of_score_by_neighbourhood <- renderDataTable({
 >    airBnB_data %>%
 >      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms) %>%
 >      select(city, neighbourhood, review_scores_rating) %>%
 >      drop_na() %>%
 >      group_by(neighbourhood) %>%
 >      summarise(review_scores_rating = mean(review_scores_rating)) %>%
 >      arrange(desc(review_scores_rating)) %>%
 >      slice(1:10)
 >  })

   Ici, on va utiliser les outils de la librairie broom afin de faire des calculs statistiques  
   pour ainsi comparer chacun des scores des airBnB d'une ville a ceux des autres villes  
   La ville est connue 
   
   
 >  output$a_city_compare_to_the_world <- renderPlot({
 >    airBnB_data %>%
 >      select(city, review_scores_accuracy:review_scores_value) %>%
 >      mutate(highlight = if_else(city == input$v_city, "Highlight", "No-Highlight")) %>%
 >      select(-city) %>%
 >      gather(key = "key", value = "value", -highlight)%>%
 >      group_by(key) %>%
 >      do(t_test = t.test(value~highlight, data = .) %>% tidy()) %>%
 >      unnest(t_test) %>%
 >      ggplot(aes(x=key, y=estimate, color = key)) +
 >      geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
 >      xlab("Review score") + ylab("Estimations") +
 >      labs(title = "Comment les scores sont differents entre ici et le reste du monde en moyenne")
 >  })
 
 
   Affiche les 5 AirBnB les moins cher de la ville  
   la ville, le nombre de chambre et le nombre de locataires sont connus  
   
   
 >  output$cheapest_airBnB <- renderDataTable ({
 >    airBnB_data %>%
 >      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms,
 >             host_is_superhost == "t")%>%
 >      select(listing_id, neighbourhood, price) %>%
 >      arrange(price)%>%
 >      head()
 >  })
 >}
 
   





 

 

 


 
 
