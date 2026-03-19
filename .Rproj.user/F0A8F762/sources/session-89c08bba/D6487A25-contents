library(testthat)
library(deSolve)

source("R/sir_model.R")

test_that("population is conserved", {
  total <- sir_output$S + sir_output$I + sir_output$R
  expect_true(all(abs(total - 1000000) < 1))
})

test_that("R0 is correct", {
  expect_equal(unname(round(R0, 0)), 3)
})