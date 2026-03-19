# EpiReserve

Epidemic mortality modelling and insurance reserve stress testing using the SIR model in R.

## What this project does

This project simulates the spread of an epidemic using the SIR 
(Susceptible-Infected-Recovered) compartmental model and calculates 
the impact on life insurance reserves. It answers the question: 
*how much extra capital does an insurer need during a pandemic?*

## Why it matters for actuaries

During COVID-19, insurers faced unexpected excess mortality that 
dramatically increased claims. This project quantifies that impact 
using the same mathematical framework actuaries use in practice.

## Key results (R0 = 3, CFR = 1%)

| Scenario | Deaths | Total Claims |
|----------|--------|-------------|
| Normal year | 40 | €4,000,000 |
| Epidemic year | 9,445 | €944,500,000 |
| **Reserve stress ratio** | | **236x** |

## Project structure
```
EpiReserve/
├── R/
│   ├── sir_model.R      # SIR ODE system + epidemic simulation
│   ├── mortality.R      # excess mortality extraction
│   └── reserves.R       # actuarial reserve calculation
├── data/
│   └── simulation_parameters.csv
├── report/
│   └── EpiReserve_Report.Rmd
├── tests/
│   └── test_sir.R
└── app.R                # interactive Shiny dashboard
```

## How to run

**1. Clone the repository**
```bash
git clone https://github.com/miraigancheva/EpiReserve.git
```

**2. Install dependencies**
```r
install.packages(c("deSolve", "ggplot2", "tidyr", "shiny", "testthat"))
```

**3. Run the Shiny dashboard**
```r
shiny::runApp("app.R")
```

## The math

The SIR system is governed by three ODEs:

$$\frac{dS}{dt} = -aSI \qquad \frac{dI}{dt} = aSI - bI \qquad \frac{dR}{dt} = bI$$

The basic reproduction number $R_0 = \frac{aN}{b}$ determines epidemic behavior:
- $R_0 > 1$ → epidemic spreads
- $R_0 < 1$ → epidemic dies out

## Tools used

- R 4.5.2
- `deSolve` — numerical ODE solver
- `ggplot2` — visualisation
- `shiny` — interactive dashboard
- `testthat` — unit testing

## Inspiration

The SIR model appears as Example in my Ordinary Differential Equations 
lecture (Prof. Rico Zacher, Universität Ulm). This project was born from the 
idea of connecting the pure mathematics from the lecture to a real actuarial application. 
