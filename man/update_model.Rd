% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gbiqq.R
\name{update_model}
\alias{update_model}
\title{Fit causal model using stan}
\usage{
update_model(model, data = NULL, stan_model = NULL,
  data_type = "long", keep_stan_model = FALSE, ...)
}
\arguments{
\item{model}{A model object generated by \code{make_model()}.}

\item{data}{A data frame with observations}

\item{stan_model}{A fitted stan model. If not provided a gbiqq model is compiled from stan file "inst/tools/simplexes.stan"}

\item{data_type}{Either "long" (as made by `simulate_data()`) or "compact"}

\item{keep_stan_model}{Logical, defulating to FALSE, indicates whether to append the stanfit object to the model.
(as made by `collapse_data()``). Compact data must have entries for each member of each strategy family to produce a valid simplex.}

\item{...}{Options passed onto \code{rstan::stan} call.}
}
\description{
Takes a model and data and returns a model object with data attached and a posterior model
}
\examples{
model <- make_model("X->Y")
data_long   <- simulate_data(model, n = 4)
data_short  <- collapse_data(data_long, model)
fit <- fitted_model()
model_1 <- update_model(model, data_long)
model_2 <- update_model(model, data_long, stan_model = fit)

# Throws error unless compact data indicated:
\dontrun{
model_3 <- update_model(model, data_short)
}
model_4 <- update_model(model, data_short, stan_model = fit, data_type = "compact")

# It is possible to implement updating without data, in which case the posterior
# is a stan object that reflects the prior
model5 <- update_model(model)

# Advanced: Example of a model with tailored parameters.
# We take a model and add a tailored P matrix (which maps from parameters
# to causal types) and a tailored parameters_df which reports that
# all parameters are in one family.
# Parameters in this example are not connected with nodal types in any way.

\dontrun{
model <- make_model("X->Y")
model$P <- diag(8)
colnames(model$P) <- rownames(model$causal_types)
model$parameters_df <- data.frame(
  param_names = paste0("x",1:8),
  param_set = 1, priors = 1, parameters = 1/8)

# Update fully confounded model on strongly correlated data

data <- make_data(make_model("X->Y"), n = 100,
  parameters = c(.5, .5, .1,.1,.7,.1))
fully_confounded <- update_model(model, data,
  stan_model = fit, keep_stan_model = TRUE)
fully_confounded$stan_fit
query_model(fully_confounded, "Y[X = 1] > Y[X=0]", using = "posteriors")
# To see the confounding:
with(fully_confounded$posterior_distribution \%>\% data.frame(),
{par(mfrow = c(1,2))
 plot(x1, x5, main = "joint distribution of X0.Y00, X0.Y01")
 plot(x1, x6, main = "joint distribution of X0.Y00, X1.Y01")})
}

}