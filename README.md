# A R-Shiny app for visualising shrinkage regression methods 

It is known in the statistics literature that the least squares linear regression estimator cannot handle high-dimensional data ($n < p$). A typical solution to this is to use an estimator with shrinkage property, e.g. the Lasso and the Ridge estimator.

This Shiny app will simulate a data with correlated features. The first two columns of the design matrix are generated with coefficient 1 and the rest are 0. By looking at various plots, we can better understand the bahaviour of each of the estimators. 

# Running the app 

You can try using either one of the following three options:
+ This is a [free Shiny app](https://gauss17gon.shinyapps.io/shrink_shiny/) hosted on `shinyapps.io`. It has an usage limit so it is not guaranteed to work.

+ This [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/kevinwang09/shrink_shiny/master?urlpath=shiny/main/) app works by deploying this Shiny app through Google Cloud. It also has an usage limit.

+ Locally running the code below:

```
library(shiny)
library(glmnet)
library(tidyverse)
library(directlabels)
library(mvtnorm)

shiny::runGitHub(
    repo = "shrink_shiny", 
    username = "kevinwang09", 
    ref = "bindr",
    subdir = "main")
```