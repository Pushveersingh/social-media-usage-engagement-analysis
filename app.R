install.packages(c("shiny", "ggplot2", "dplyr", "DT", "bslib"))

# Social Media Usage and Engagement Analysis
# Interactive dashboard using R Shiny

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(bslib)

# ---------------------------------
# 1. Create sample dataset if needed
# ---------------------------------

file_name <- "social_media_data.csv"
if (!file.exists(file_name)) {
  set.seed(123)
  n <- 150
  platforms <- c("Instagram", "YouTube", "Facebook",
                 "TikTok", "X")
  content_types <- c("Videos", "Images", "Text", "Reels")
  sample_data <- data.frame(
    UserID = 1:n,
    Age = sample(18:45, n, replace = TRUE),
    Gender = sample(c("Female", "Male", "Other"),
                    n, replace = TRUE),
    Platform = sample(platforms, n, replace = TRUE),
    DailyUsageHours = round(runif(n, 0.5, 7), 1),
    PostsPerWeek = sample(0:20, n, replace = TRUE),
    Likes = sample(0:500, n, replace = TRUE),
    Comments = sample(0:100, n, replace = TRUE),
    Shares = sample(0:80, n, replace = TRUE),
    Views = sample(100:10000, n, replace = TRUE),
    ContentType = sample(content_types, n, replace = TRUE)
  )
  write.csv(sample_data, file_name, row.names = FALSE)
}
# Load dataset
social_data <- read.csv(file_name)
# Add age groups
social_data$AgeGroup <- cut(
  social_data$Age,
  breaks = c(17, 24, 34, 45),
  labels = c("18-24", "25-34", "35-45")
)
# Calculate engagement
social_data$Engagement <- with(
  social_data,
  Likes + Comments + Shares
)

# ---------------------------------
# 2. Dashboard user interface
# ---------------------------------

ui <- page_sidebar(
  title = "Social Media Analytics Dashboard",
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly"
  ),
  
  sidebar = sidebar(
    title = "Dashboard Filters",
    
    selectInput(
      "platform",
      "Select Platform",
      choices = c("All", sort(unique(social_data$Platform))),
      selected = "All"
    ),
    
    selectInput(
      "age_group",
      "Select Age Group",
      choices = c("All", levels(social_data$AgeGroup)),
      selected = "All"
    ),
    
    sliderInput(
      "hours",
      "Daily Usage Hours",
      min = 0,
      max = 7,
      value = c(0, 7),
      step = 0.5
    ),
    
    actionButton(
      "reset",
      "Reset Filters",
      class = "btn-primary"
    ),
    
    helpText(
      "Explore social media usage and engagement."
    )
  ),
  
  navset_tab(
    nav_panel(
      "Overview",
      
      h3("Dashboard Overview"),
      p("Summary of social media usage and engagement."),
      
      layout_columns(
        card(
          card_header("Total Users"),
          h2(textOutput("total_users"))
        ),
        card(
          card_header("Average Daily Hours"),
          h2(textOutput("average_hours"))
        ),
        card(
          card_header("Total Likes"),
          h2(textOutput("total_likes"))
        ),
        card(
          card_header("Total Engagement"),
          h2(textOutput("total_engagement"))
        )
      ),
      
      layout_columns(
        card(
          card_header("Users by Platform"),
          plotOutput("platform_plot", height = "300px")
        ),
        card(
          card_header("Average Daily Usage"),
          plotOutput("usage_plot", height = "300px")
        )
      ),
      
      card(
        card_header("Engagement by Platform"),
        plotOutput("engagement_plot", height = "350px")
      )
    ),
    
    nav_panel(
      "Engagement Analysis",
      
      h3("Engagement Analysis"),
      
      card(
        card_header("Daily Usage vs Engagement"),
        plotOutput("scatter_plot", height = "400px")
      ),
      
      card(
        card_header("Engagement by Content Type"),
        plotOutput("content_plot", height = "350px")
      )
    ),
    
    nav_panel(
      "Data Explorer",
      
      h3("Social Media Records"),
      p("The table updates when you change the filters."),
      
      downloadButton(
        "download_data",
        "Download Filtered CSV"
      ),
      
      br(),
      br(),
      
      DTOutput("data_table")
    )
  )
)

# ---------------------------------
# 3. Server calculations and graphs
# ---------------------------------

server <- function(input, output, session) {
  
  # Reset all filters
  observeEvent(input$reset, {
    updateSelectInput(
      session, "platform", selected = "All"
    )
    
    updateSelectInput(
      session, "age_group", selected = "All"
    )
    
    updateSliderInput(
      session, "hours", value = c(0, 7)
    )
  })
  
  # Filter data
  filtered_data <- reactive({
    
    data <- social_data
    
    if (input$platform != "All") {
      data <- data %>%
        filter(Platform == input$platform)
    }
    
    if (input$age_group != "All") {
      data <- data %>%
        filter(AgeGroup == input$age_group)
    }
    
    data %>%
      filter(
        DailyUsageHours >= input$hours[1],
        DailyUsageHours <= input$hours[2]
      )
  })
  
  # Summary cards
  output$total_users <- renderText({
    nrow(filtered_data())
  })
  
  output$average_hours <- renderText({
    data <- filtered_data()
    
    if (nrow(data) == 0) {
      return("0")
    }
    
    paste0(
      round(mean(data$DailyUsageHours), 2),
      " hrs"
    )
  })
  
  output$total_likes <- renderText({
    sum(filtered_data()$Likes)
  })
  
  output$total_engagement <- renderText({
    sum(filtered_data()$Engagement)
  })
  
  # Users by platform
  output$platform_plot <- renderPlot({
    
    data <- filtered_data() %>%
      count(Platform)
    
    ggplot(data, aes(
      x = reorder(Platform, n),
      y = n,
      fill = Platform
    )) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      labs(x = "Platform", y = "Number of Records") +
      theme_minimal()
  })
  
  # Average daily usage by platform
  output$usage_plot <- renderPlot({
    
    data <- filtered_data() %>%
      group_by(Platform) %>%
      summarise(
        AverageHours = mean(DailyUsageHours),
        .groups = "drop"
      )
    
    ggplot(data, aes(
      x = Platform,
      y = AverageHours,
      fill = Platform
    )) +
      geom_col(show.legend = FALSE) +
      labs(
        x = "Platform",
        y = "Average Hours"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(
          angle = 30, hjust = 1
        )
      )
  })
  
  # Engagement by platform
  output$engagement_plot <- renderPlot({
    
    data <- filtered_data() %>%
      group_by(Platform) %>%
      summarise(
        AverageEngagement = mean(Engagement),
        .groups = "drop"
      )
    
    ggplot(data, aes(
      x = Platform,
      y = AverageEngagement,
      fill = Platform
    )) +
      geom_col(show.legend = FALSE) +
      labs(
        x = "Platform",
        y = "Average Likes + Comments + Shares"
      ) +
      theme_minimal()
  })
  
  # Usage hours compared with engagement
  output$scatter_plot <- renderPlot({
    
    ggplot(
      filtered_data(),
      aes(
        x = DailyUsageHours,
        y = Engagement,
        color = Platform
      )
    ) +
      geom_point(size = 3, alpha = 0.7) +
      labs(
        x = "Daily Usage Hours",
        y = "Likes + Comments + Shares",
        color = "Platform"
      ) +
      theme_minimal()
  })
  
  # Engagement by content type
  output$content_plot <- renderPlot({
    
    data <- filtered_data() %>%
      group_by(ContentType) %>%
      summarise(
        AverageEngagement = mean(Engagement),
        .groups = "drop"
      )
    
    ggplot(data, aes(
      x = ContentType,
      y = AverageEngagement,
      fill = ContentType
    )) +
      geom_col(show.legend = FALSE) +
      labs(
        x = "Content Type",
        y = "Average Engagement"
      ) +
      theme_minimal()
  })
  
  # Interactive data table
  output$data_table <- renderDT({
    
    datatable(
      filtered_data(),
      options = list(
        pageLength = 10,
        scrollX = TRUE
      ),
      rownames = FALSE
    )
  })
  
  # Download filtered data
  output$download_data <- downloadHandler(
    
    filename = function() {
      paste0("filtered_social_media_", Sys.Date(), ".csv")
    },
    
    content = function(file) {
      write.csv(
        filtered_data(),
        file,
        row.names = FALSE
      )
    }
  )
}

# ---------------------------------
# 4. Run the dashboard
# ---------------------------------

shinyApp(ui = ui, server = server)
