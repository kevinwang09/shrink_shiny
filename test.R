source("global.R")

n = 100
p = 20
k = 2
rho = 0.5

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

svd(solve(t(x) %*% x))$d
plot(lm.fit(x = cbind(Int = 1, x), y = y)$coef)


lasso = glmnet::cv.glmnet(
  x = x,
  y = y, 
  lambda = 10^seq(1, -5, length = 100))

ridge = glmnet::cv.glmnet(
  x = x,
  y = y, 
  lambda = 10^seq(3, -5, length = 100),
  alpha = 0)

lasso %>% 
  coef2Df %>% 
  ggplot(aes(x = log(lambda), 
             y = coef,
             colour = variables,
             label = variables)) +
  geom_line() +
  scale_y_continuous(breaks = c(-0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)) +
  geom_vline(xintercept = log(lasso$lambda.min)) +
  geom_dl(method = "angled.boxes") +
  theme(legend.position = "none")


ridge %>% coef2Df %>% 
  ggplot(aes(x = log(lambda), 
             y = coef,
             colour = variables,
             label = variables)) +
  geom_line() +
  scale_y_continuous(breaks = c(-0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)) +
  geom_vline(xintercept = log(ridge$lambda.min)) +
  geom_dl(method = "angled.boxes") +
  theme(legend.position = "none")