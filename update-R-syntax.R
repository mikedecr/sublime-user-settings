setwd("/Users/michaeldecrescenzo/Library/Application Support/Sublime Text 3/Packages/R")


library(stringr)

packages <- c(
    "base",
    "purrr",
    "graphics",
    "grDevices",
    "methods",
    "stats",
    "utils",
    "tidyverse",
    "magrittr",
    "ggplot2",
    "forcats",
    "stringr",
    "tidyr",
    "skimr",
    "dplyr",
    "tibble",
    "rstan",
    "rjags",
    "ggridges",
    "doParallel",
    "broom",
    "xtable",
    "stargazer",
    "ggmcmc",
    "ggjoy",
    "plyr",
    "haven",
    "caTools",
    "viridis",
    "viridisLite",
    "extrafont",
    "boxr",
    "latex2exp",
    "readr",
    "curl"
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
