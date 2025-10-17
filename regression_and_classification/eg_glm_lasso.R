library(tidyverse)
library(glmnet)
library(broom)
library(gridExtra)

# Load data
d <- read_csv("derived_data/mileage_prepped.csv") %>%
  select(-city_mpg)

# Response and predictor matrices
y <- d$highway_mpg
X <- model.matrix(highway_mpg ~ ., d)[, -1]   # remove intercept column

# Fit cross-validated LASSO
cvfit <- cv.glmnet(X, y, alpha = 1)
fit <- cvfit$glmnet.fit

best_fit <- glmnet(X,y,lambda=cvfit$lambda.min)
mdpre(best_fit$beta)




coef_df <- broom::tidy(fit) %>%
  filter(term != "(Intercept)") %>%
  mutate(log_lambda = log(lambda))


nz_df <- coef_df %>%
  group_by(lambda) %>%
  summarize(nonzero = sum(estimate != 0)) %>%
  mutate(log_lambda = log(lambda))

# Cross-validation curve (error vs lambda)
cv_df <- tibble(
  lambda = cvfit$lambda,
  cvm = cvfit$cvm,
  cvsd = cvfit$cvsd
) %>%
  mutate(log_lambda = log(lambda))


err_df <- left_join(cv_df, nz_df, by = "lambda")

# Plot 1: Coefficient paths
p1 <- ggplot(coef_df, aes(x = log_lambda, y = estimate, color = term)) +
  geom_line(linewidth = 1) +
  labs(
    title = "LASSO Coefficient Paths",
    x = "log(Lambda)",
    y = "Coefficient Value",
    color = "Predictor"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


p2 <- ggplot(nz_df, aes(x = log_lambda, y = nonzero)) +
  geom_line(linewidth = 1.2, color = "steelblue") +
  labs(
    title = "Number of Nonzero Coefficients",
    x = "log(Lambda)",
    y = "Nonzero Coefficients"
  ) +
  theme_minimal()

p3 <- ggplot(err_df, aes(x = nonzero, y = cvm)) +
  geom_line(linewidth = 1.2, color = "darkred") +
  geom_errorbar(aes(ymin = cvm - cvsd, ymax = cvm + cvsd), width = 0.2, color = "gray40") +
  labs(
    title = "Cross-Validation Error vs. Model Complexity",
    x = "Number of Nonzero Coefficients",
    y = "Mean CV Error"
  ) +
  theme_minimal()

# Combine all three plots
ggmd(gridExtra::grid.arrange(p1, p2, p3, ncol = 1))

beta_df <- tibble(variable=rownames(best_fit$beta), value = best_fit$beta %>% as.vector()) %>%
  arrange((abs(value))) %>%
  mutate(variable=factor(variable, variable)) %>%
  filter(abs(value)>0.0) %>% lbdr()

p <- ggplot(beta_df, aes(value, variable)) +
  geom_segment(aes(x=0,y=variable,xend=abs(value),yend=variable,color=factor(sign(value))),linewidth=4)

ggmd(p)


