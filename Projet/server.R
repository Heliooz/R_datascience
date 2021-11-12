
server <- function(input, output){
  
  ## Dataframe de la map qui nous permet de filtrer avec nos input ##
  data_for_map <-  reactive({
    airBnB_data %>%
      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms,
             host_is_superhost == "t") %>%
      arrange(price) %>%
      head()
  })
  
  ## Affichage de la carte du monde ##
  output$map <- renderLeaflet({
    leaflet(airBnB_data) %>%
      addTiles() %>%
      fitBounds(~min(longitude), ~min(latitude), ~max(longitude), ~max(latitude))
  })
  
  ## Place les curseurs des cinq airBnB les moins cher sur la carte ##
  ## la ville, le nombre de chambre et le nombre de locataires sont connus ##
  observe({
    leafletProxy("map", data = data_for_map()) %>%
      clearShapes() %>%
      addMarkers(label = ~listing_id)
  })
  
  ## Met dans un graphe les moyenne des prix par arrondissements ##
  ## On gardera les 10 premiers ##
  ## la ville, le nombre de chambre et le nombre de locataires sont connus ##
  output$mean_price_by_neighbourhood <- renderPlot({
    airBnB_data %>%
      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms) %>%
      select(price, city, neighbourhood) %>%
      group_by(neighbourhood) %>%
      summarise(price = mean(price)) %>%
      ungroup() %>%
      arrange(price) %>%
      slice(1:10) %>%
      ggplot(aes(x = price, y = neighbourhood)) + geom_col() + 
      xlab("prix par nuit") + 
      ylab("arrondissement") +
      labs(title = "Prix moyen pour les 10 arrondissement les moins chers")
  })
  
  ## Classe les moyenne des scores par arrondissements ##
  ## On gardera les 10 premiers ##
  ## la ville, le nombre de chambre et le nombre de locataires sont connus ##
  output$list_of_score_by_neighbourhood <- renderDataTable({
    airBnB_data %>%
      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms) %>%
      select(city, neighbourhood, review_scores_rating) %>%
      drop_na() %>%
      group_by(neighbourhood) %>%
      summarise(review_scores_rating = mean(review_scores_rating)) %>%
      arrange(desc(review_scores_rating)) %>%
      slice(1:10)
  })
  
  ## Ici, on va utiliser les outils de la librairie broom afin de faire des calculs statistiques ##
  ## pour ainsi comparer chacun des scores des airBnB d'une ville a ceux des autres villes ##
  ## La ville est connue ##
  output$a_city_compare_to_the_world <- renderPlot({
    airBnB_data %>%
      select(city, review_scores_accuracy:review_scores_value) %>%
      mutate(highlight = if_else(city == input$v_city, "Highlight", "No-Highlight")) %>%
      select(-city) %>%
      gather(key = "key", value = "value", -highlight)%>%
      group_by(key) %>%
      do(t_test = t.test(value~highlight, data = .) %>% tidy()) %>%
      unnest(t_test) %>%
      ggplot(aes(x=key, y=estimate, color = key)) +
      geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
      xlab("Review score") + ylab("Estimations") +
      labs(title = "Comment les scores sont differents entre ici et le reste du monde en moyenne")
  })
  
  
  ## Affiche les 5 AirBnB les moins cher de la ville ##
  ## la ville, le nombre de chambre et le nombre de locataires sont connus ##
  output$cheapest_airBnB <- renderDataTable ({
    airBnB_data %>%
      filter(city == input$v_city, accommodates == input$v_accommodates, bedrooms == input$v_bedrooms,
             host_is_superhost == "t")%>%
      select(listing_id, neighbourhood, price) %>%
      arrange(price)%>%
      head()
  })
}