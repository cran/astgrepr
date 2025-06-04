## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(astgrepr)

## -----------------------------------------------------------------------------
src <- "x <- rnorm(100, mean = 2)
any(is.na(y))
plot(x)
any(is.na(x))
any(duplicated(variable))"

## -----------------------------------------------------------------------------
root <- src |>
  tree_new() |>
  tree_root()

root

## -----------------------------------------------------------------------------
ast_rule(id = "any_na", pattern = "any(is.na($VAR))")

## -----------------------------------------------------------------------------
root |> 
  node_find(
    ast_rule(id = "any_na", pattern = "any(is.na($VAR))"),
    ast_rule(id = "any_dup", pattern = "any(duplicated($VAR))")
  )

## -----------------------------------------------------------------------------
found_nodes <- root |> 
  node_find_all(
    ast_rule(id = "any_na", pattern = "any(is.na($VAR))"),
    ast_rule(id = "any_dup", pattern = "any(duplicated($VAR))")
  )

found_nodes

## -----------------------------------------------------------------------------
found_nodes |> 
  node_text_all()
found_nodes |> 
  node_range_all()

## -----------------------------------------------------------------------------
nodes_to_replace <- root |>
  node_find_all(
    ast_rule(id = "any_na", pattern = "any(is.na($VAR))"),
    ast_rule(id = "any_dup", pattern = "any(duplicated($VAR))")
  )

nodes_to_replace
fixes <- nodes_to_replace |>
  node_replace_all(
    any_na = "anyNA(~~VAR~~)",
    any_dup = "anyDuplicated(~~VAR~~) > 0"
  )

fixes

## -----------------------------------------------------------------------------
# original code
cat(src)
# new code
tree_rewrite(root, fixes)

