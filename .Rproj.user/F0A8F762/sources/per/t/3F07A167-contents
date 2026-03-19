# ============================================
# Reserve Calculation
# ============================================

# Portfolio parameters
n_policies    <- 10000   # number of policyholders
benefit       <- 100000  # death benefit per policy (€)
avg_age       <- 50      # average age of policyholders

# Baseline mortality (normal year, no epidemic)
# q_x = probability of dying in one year for age 50
# from standard German life table (DAV 2008T)
qx_baseline <- 0.004  

# ============================================
# Baseline expected deaths and claims
# ============================================

baseline_deaths <- n_policies * qx_baseline
baseline_claims <- baseline_deaths * benefit

cat("--- BASELINE (no epidemic) ---\n")
cat("Expected deaths:", round(baseline_deaths), "\n")
cat("Expected claims: €", format(baseline_claims, big.mark=",", scientific = FALSE), "\n")

# ============================================
# Epidemic stressed mortality
# ============================================

# excess deaths from our SIR model
epidemic_deaths <- max(sir_output$cumulative_deaths)

# total deaths = baseline + epidemic
total_deaths  <- baseline_deaths + epidemic_deaths
total_claims  <- total_deaths * benefit

# extra claims caused by epidemic
extra_claims  <- total_claims - baseline_claims

cat("\n--- EPIDEMIC STRESSED ---\n")
cat("Epidemic deaths:", round(epidemic_deaths), "\n")
cat("Total deaths:", round(total_deaths), "\n")
cat("Total claims: €", format(total_claims, big.mark=",", scientific=FALSE), "\n")
cat("Extra claims: €", format(extra_claims, big.mark=",", scientific=FALSE), "\n")

# reserve stress ratio
stress_ratio <- total_claims / baseline_claims
cat("Reserve stress ratio:", round(stress_ratio, 2), "x\n")

cat("\n--- SUMMARY ---\n")
cat("Extra reserve needed: €", 
    format(extra_claims, big.mark=",", scientific=FALSE), "\n")
cat("Extra reserve per policy: €", 
    format(round(extra_claims/n_policies), big.mark=","), "\n")
