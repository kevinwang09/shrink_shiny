library(shiny)
library(glmnet)
library(tidyverse)
library(directlabels)

theme_set(theme_bw(18) +
            theme(legend.position = "none"))

coef2Df = function(cvglmnetObj){
  coefMat = as.matrix(coef(cvglmnetObj, s = cvglmnetObj$lambda))
  colnames(coefMat) = cvglmnetObj$lambda
  coefDf = reshape2::melt(
    coefMat,
    varnames = c("variables", "lambda"),
    value.name = "coef") %>% 
    tibble::as_tibble() %>% 
    dplyr::filter(variables != "(Intercept)") %>% 
    dplyr::mutate(nLambda = seq_along(lambda)) 
  
  return(coefDf)
}
