# ============================================
# Mortality Extraction
# ============================================

# Case Fatality Rate (COVID-19 like scenario)
CFR <- 0.01  # 1% of infected people die

# calculate daily deaths from epidemic
sir_output$daily_deaths <- CFR * parameters["b"] * sir_output$I

# calculate cumulative deaths
sir_output$cumulative_deaths <- cumsum(sir_output$daily_deaths)

# plot daily deaths
deaths_plot <- ggplot(sir_output, aes(x = time, y = daily_deaths)) +
  geom_line(color = "darkred", size = 1.1) +
  labs(
    title    = "Daily Epidemic Deaths",
    subtitle = paste("CFR =", CFR*100, "%  |  R_0 =", round(R0, 2)),
    x        = "Days",
    y        = "Daily deaths"
  ) +
  theme_minimal()

print(deaths_plot)
ggsave("report/daily_deaths.png", plot = deaths_plot, width = 10, height = 6)

# summary statistics
cat("Total epidemic deaths:", round(max(sir_output$cumulative_deaths)), "\n")
cat("Peak daily deaths:", round(max(sir_output$daily_deaths)), "\n")
cat("Peak death day:", which.max(sir_output$daily_deaths), "\n")