# A R-Shiny app for visualising shrinkage regression methods 

It is known in the statistics literature that the least squares linear regression estimator cannot handle high-dimensional data ($n < p$). A typical solution to this is to use an estimator with shrinkage, e.g. the Lasso and the Ridge estimator.

This Shiny app will simulate a data with correlated features. The first two columns of the design matrix are generated with coefficient 1 and the rest are 0. By looking at various plots, we can better understand the bahaviour of each of these three estimators. 


This [free Shiny app](https://mybinder.org/v2/gh/kevinwang09/shrink_shiny/bindr?urlpath=shiny/main/) could work, but if it doesn't, you could run the code locally below. 

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