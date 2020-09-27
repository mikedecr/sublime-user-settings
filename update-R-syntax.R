# Rscript "/Users/michaeldecrescenzo/Dropbox/Sublime/User/update-R-syntax.R" --no-save 

# R
# source("/Users/michaeldecrescenzo/Dropbox/Sublime/User/update-R-syntax.R", echo = TRUE)

setwd("/Users/michaeldecrescenzo/Library/Application Support/Sublime Text 3/Packages/R")


library(stringr)

packages <- c(
  # Base
    "base",
    "graphics",
    "grDevices",
    "methods",
    "stats",
    "utils",
    "tools",
  # data manipulation
    "readxl",
    "purrr",
    "tidyverse",
    "magrittr",
    "forcats",
    "stringr",
    "tidyr",
    "tidyselect",
    "skimr",
    "dplyr",
    "tibble",
    # "doParallel",
    "labelled",
    "lubridate",
    "plyr",
    "haven",
    "boxr",
    "readr",
    "curl",
    "broom",
 # modeling
    "tidybayes", 
    "bayesplot",
    "rstan",
    # "rjags",
    "ggmcmc",
    "tidymodels",
    "parsnip", 
    "dials", # whatever that does
    "infer", # whatever that does
    "recipes", # whatever that does
    "rsample", # whatever that does
    "tune", # whatever that does
    "workflows", # whatever that does
    "yardstick", # whatever that does
  # graphics
    "ggplot2",
    "ggridges",
    # "caTools",
    "viridis",
    "viridisLite",
    "extrafont",
    "latex2exp",
    "ggforce",
    "dagitty",
    "ggdag",
  # outputting
    "xtable",
    # "stargazer",
    "knitr",
    "rmarkdown",
    "bookdown",
    "blogdown",
    "scales",
    "english"
)

get_functions <- function(pkg) {
    objs <- unclass(lsf.str(envir = asNamespace(pkg)))
    objs[str_detect(objs, "^[a-zA-Z\\._][0-9a-zA-Z\\._]*$")]
}

template <- "
    - match: \\b(foo)\\s*(\\()
      captures:
        1: support.function.r
      push: function-parameters
"

templated_block <- function(pkg){
    content <- paste0(sub("\\.", "\\\\\\\\.", get_functions(pkg)), collapse = "|")
    str_replace(template, "foo", content)
}

dict <- ""
for (pkg in packages){
    dict <- paste0(dict, templated_block(pkg))
}

syntax_file <- "R.sublime-syntax"
content <- readChar(syntax_file, file.info(syntax_file)$size)
begin_pt <- str_locate(content, "builtin-functions:\n")[2]
str_sub(content, begin_pt, str_length(content)) <- dict
cat(content, file = syntax_file)
