library(shiny)
library(deSolve)
library(ggplot2)
library(tidyr)

ui <- fluidPage(
  
  titlePanel("EpiReserve - Epidemic Mortality & Insurance Reserves"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("R0", 
                  label = "Basic Reproduction Number (R0)",
                  min = 1.1, max = 5.0, value = 3.0, step = 0.1),
      
      sliderInput("CFR",
                  label = "Case Fatality Rate (%)",
                  min = 0.1, max = 5.0, value = 1.0, step = 0.1),
      
      sliderInput("n_policies",
                  label = "Number of Policies",
                  min = 1000, max = 50000, value = 10000, step = 1000)
    ),
    
    mainPanel(
      plotOutput("epidemic_plot"),
      plotOutput("deaths_plot"),
      verbatimTextOutput("reserve_summary")
    )
  )
)


server <- function(input, output) {
  
  sir_reactive <- reactive({
    
    N <- 1000000
    b <- 0.1
    a <- (input$R0 * b) / N
    
    sir_equations <- function(time, state, parameters) {
      S <- state["S"]
      I <- state["I"]
      R <- state["R"]
      a <- parameters["a"]
      b <- parameters["b"]
      list(c(-a*S*I, a*S*I - b*I, b*I))
    }
    
    ode(
      y     = c(S = N-1, I = 1, R = 0),
      times = seq(0, 200, by = 1),
      func  = sir_equations,
      parms = c(a = a, b = b)
    ) |> as.data.frame()
  })
  
  output$epidemic_plot <- renderPlot({
    sir_long <- pivot_longer(sir_reactive(), 
                             cols = c(S,I,R),
                             names_to = "compartment",
                             values_to = "count")
    ggplot(sir_long, aes(x=time, y=count, color=compartment)) +
      geom_line(size=1.1) +
      scale_color_manual(
        values = c(S="steelblue", I="red", R="darkgreen"),
        labels = c(S="Susceptible", I="Infected", R="Recovered")
      ) +
      labs(title="SIR Epidemic Model", x="Days", y="People") +
      theme_minimal()
  })
  
  output$deaths_plot <- renderPlot({
    df <- sir_reactive()
    df$daily_deaths <- (input$CFR/100) * 0.1 * df$I
    ggplot(df, aes(x=time, y=daily_deaths)) +
      geom_line(color="darkred", size=1.1) +
      labs(title="Daily Epidemic Deaths", x="Days", y="Deaths") +
      theme_minimal()
  })
  
  output$reserve_summary <- renderText({
    df        <- sir_reactive()
    CFR       <- input$CFR / 100
    epidemic_deaths  <- max(cumsum(CFR * 0.1 * df$I))
    baseline_deaths  <- input$n_policies * 0.004
    extra_claims     <- epidemic_deaths * 100000
    stress_ratio     <- (baseline_deaths * 100000 + extra_claims) / 
      (baseline_deaths * 100000)
    
    paste0(
      "--- SUMMARY ---\n",
      "R0: ", input$R0, "\n",
      "Epidemic deaths: ", round(epidemic_deaths), "\n",
      "Extra claims: € ", format(round(extra_claims), big.mark=","), "\n",
      "Reserve stress ratio: ", round(stress_ratio, 2), "x\n",
      "Extra reserve per policy: € ", 
      format(round(extra_claims/input$n_policies), big.mark=",")
    )
  })
}

shinyApp(ui = ui, server = server)