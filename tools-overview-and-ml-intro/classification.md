# Classification

```r file=cartoon_regression.R
# logistic_label3_simple.R
# Load labelled.csv, rename time columns t1..tN for convenience,
# drop cluster if present, fit logistic regression for label==3,
# plot coefficients vs time.

library(tidyverse)

# S1: Load
df <- read_csv("labelled_traces.csv", show_col_types = FALSE)

# S2: Outcome
if (!"cluster" %in% names(df)) stop("Expected a 'cluster' column in clusterled.csv.")
y_bin <- as.integer(df$cluster == 3)

# S3: Identify time columns (exclude cluster, trial, index, cluster)
time_cols <- names(df) |>
  discard(~ .x %in% c("trial", "cluster", "index", "cluster")) |>
  keep(~ !is.na(suppressWarnings(as.numeric(.x)))) |>
  (\(x) x[order(as.numeric(x))])()

# S4: Rename time columns to t1..tN
n_time <- length(time_cols)
new_names <- paste0("t", seq_len(n_time))

df_clean <- df |>
  select(cluster, all_of(time_cols)) |>
  rename_with(~ new_names, all_of(time_cols)) |>
  mutate(y_bin = y_bin)

# S5: Logistic regression on standardized predictors
X_scaled <- df_clean |>
  select(all_of(new_names)) |>
  scale(center = TRUE, scale = TRUE) |>
  as.data.frame()

dat <- cbind(y_bin = df_clean$y_bin, X_scaled) %>% as_tibble() %>%
  select(where(~ !any(is.na(.x))));

form <- formula(sprintf("y_bin ~ %s", paste(names(dat)[!(names(dat) %in% c("y_bin","cluster"))], collapse = " + ")))
fit <- glm(form, data = dat %>% as_tibble(), family = binomial(), na.action = na.omit)

# S6: Extract coefficients (omit intercept) and align with time axis
coefs <- coef(fit)
coefs <- coefs[setdiff(names(coefs), "(Intercept)")]
coef_tbl <- tibble(
  time = as.numeric(time_cols[2:250]),
  beta = as.numeric(coefs)
)

# S7: Plot coefficients over time
ggmd(ggplot(coef_tbl, aes(x = time, y = beta)) +
  geom_hline(yintercept = 0, linewidth = 0.3) +
  geom_line() +
  geom_point(size = 0.7) +
  labs(
    title = "Logistic Regression Coefficients for cluster==3",
    x = "Time",
    y = "Coefficient (standardized features)"
  ) +
  theme_minimal())

```
In ::../chapter3/start:chapter 3:: we will bang all this into the shape of a 
small project.

:student-select:Name a simple yes/no decision you make often (e.g., bring umbrella?). What info do you use?; ../students.json::
:student-select:Pick two categories from daily life (e.g., ripe/unripe fruit). What clues separate them?; ../students.json::
