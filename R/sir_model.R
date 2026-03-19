# ============================================
# SIR Model Core
# ============================================

library(deSolve) #  package to solve ordinary differential equitions

# The SIR system 
# Every function that is given to deSolve must have exactly these three inputs - time, state, parameters (exactly in this order)
sir_equations <- function(time, state, parameters) { 
  
  # unpack current values of S, I, R
  S <- state["S"]
  I <- state["I"]
  R <- state["R"]
  
  # unpack parameters
  a <- parameters["a"]  # infection rate
  b <- parameters["b"]  # recovery rate
  
  # the three ODEs we will be working with
  dS <- -a * S * I
  dI <-  a * S * I - b * I
  dR <-  b * I
  
  return(list(c(dS, dI, dR)))
}

# ============================================
# Initial conditions
# ============================================

N <- 1000000  # total population (1 million)

initial_state <- c(
  S = N - 1,  # almost everyone susceptible
  I = 1,      # one infected person
  R = 0       # nobody recovered yet
)

# ============================================
# Parameters
# ============================================

parameters <- c(
  a = 0.0000003,  # infection rate (we get it from R_0 equation)
  b = 0.1         # recovery rate (average 10 days sick) 
)

# R0 calculation
R0 <- (parameters["a"] * N) / parameters["b"]
cat("R0 =", R0, "\n")

# ============================================
# Time sequence (days)
# ============================================

time <- seq(0, 200, by = 1)  # 200 days, one step per day

# ============================================
# Make it all together
# ============================================

sir_output <- ode(
  y     = initial_state, 
  times = time,
  func  = sir_equations,
  parms = parameters
)

# convert to data frame that shows how S,I and R change every day 
sir_output <- as.data.frame(sir_output)

# look at the data frame that we created
head(sir_output) # start
tail(sir_output) # end

# ============================================
# Plot the epidemic curve
# ============================================
library(ggplot2)
library(tidyr)

# reshape data 
sir_long <- pivot_longer(
  sir_output,
  cols = c(S, I, R),
  names_to = "compartment",
  values_to = "count"
)

# plot
sir_plot <- ggplot(sir_long, aes(x = time, y = count, color = compartment)) +
  geom_line(size = 1.1) +
  scale_color_manual(
    values = c(S = "steelblue", I = "red", R = "darkgreen"),
    labels = c(S = "Susceptible", I = "Infected", R = "Recovered")
  ) +
  labs(
    title    = "SIR Epidemic Model",
    x        = "Days",
    y        = "Number of people",
    color    = "Group"
  ) +
  theme_minimal()

print(sir_plot)

ggsave("report/sir_epidemic_curve.png", plot = sir_plot, width = 10, height = 6)

