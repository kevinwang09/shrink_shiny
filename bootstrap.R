source("global.R")

n = 500
p = 20
k = 2
rho = 0

set.seed(1)

rows = matrix(rep(c(1:p), p), nrow = p, byrow = F)
cols = t(rows)
sigma = rho^abs(rows - cols)

x = mvtnorm::rmvnorm(
  n = n,
  mean = rep(0, p),
  sigma = sigma)

colnames(x) = sprintf("x%02d", 1:p)


beta = c(rep(1, k), rep(0, p-k))
y = x %*% beta + rnorm(n, 0, 1)

#######################################
n_boot = 100
boot_index = replicate(n_boot, sample(1:n, n, replace = TRUE), simplify = FALSE)
boot_x = purrr::map(boot_index, ~ x[.x,])
boot_y = purrr::map(boot_index, ~ y[.x])

boot_eigen = purrr::map(.x = boot_x, .f = ~ svd(solve(t(.x) %*% .x))$d)
boot_ls = purrr::map2(
  .x = boot_x, 
  .y = boot_y,
  .f = ~ lm.fit(x = cbind(Int = 1, .x), y = .y)$coef) %>% 
  purrr::map(as.matrix) %>% 
  do.call(cbind, .)

dim(boot_ls)


boot_lasso = purrr::map2(
  .x = boot_x, 
  .y = boot_y,
  .f = ~ glmnet::cv.glmnet(
    x = .x,
    y = .y)) %>% 
  purrr::map(coef.cv.glmnet, s = "lambda.min") %>% 
  purrr::map(as.matrix) %>% 
  do.call(cbind, .)

dim(boot_lasso)

boot_ridge = purrr::map2(
  .x = boot_x, 
  .y = boot_y,
  .f = ~ glmnet::cv.glmnet(
    x = .x,
    y = .y, alpha = 0)) %>% 
  purrr::map(coef.cv.glmnet, s = "lambda.min") %>% 
  purrr::map(as.matrix) %>% 
  do.call(cbind, .)

dim(boot_ridge)

boot_plotdf = list(
  least_squares = boot_ls,
  lasso = boot_lasso,
  ridge = boot_ridge) %>% 
  reshape2::melt() %>% 
  as_tibble() %>% 
  dplyr::transmute(
    variables = Var1, 
    value = value, 
    method = L1) %>% 
  dplyr::filter(variables != "Int",
                variables != "(Intercept)")


boot_plotdf %>% 
  ggplot(aes(x = variables, 
             y = value, 
             colour = method)) +
  geom_boxplot() +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = 1) +
  theme(legend.position = "bottom")
