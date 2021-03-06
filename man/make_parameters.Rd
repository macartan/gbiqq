% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/set_parameters.R
\name{make_parameters}
\alias{make_parameters}
\title{Make a 'true' parameter vector}
\usage{
make_parameters(
  model,
  parameters = NULL,
  param_type = NULL,
  warning = TRUE,
  normalize = TRUE,
  ...
)
}
\arguments{
\item{model}{A \code{causal_model}. A model object generated by \code{\link{make_model}}.}

\item{parameters}{A vector of real numbers in [0,1]. Values of parameters to specify (optional). By default, parameters is drawn from \code{model$parameters_df}.}

\item{param_type}{A character. String specifying type of parameters to make ("flat", "prior_mean", "posterior_mean", "prior_draw", "posterior_draw", "define). With param_type set to \code{define} use arguments to be passed to \code{make_priors}; otherwise \code{flat} sets equal probabilities on each nodal type in each parameter set; \code{prior_mean}, \code{prior_draw}, \code{posterior_mean}, \code{posterior_draw} take parameters as the means or as draws from the prior or posterior.}

\item{warning}{Logical. Whether to warn about parameter renormalization.}

\item{normalize}{Logical. If parameter given for a subset of a family the residual elements are normalized so that parameters in param_set sum to 1 and provided params are unaltered.}

\item{...}{Options passed onto \code{\link{make_priors}}.}
}
\value{
A vector of draws from the prior or distribution of parameters
}
\description{
A vector of 'true' parameters; possibly drawn from prior or posterior.
}
\examples{

# Simple examples
model <- make_model('X -> Y')
data  <- simulate_data(model, n = 2)
model <- update_model(model, data)
make_parameters(model, parameters = c(.25, .75, 1.25,.25, .25, .25))
make_parameters(model, param_type = 'flat')
make_parameters(model, param_type = 'prior_draw')
make_parameters(model, param_type = 'prior_mean')
make_parameters(model, param_type = 'posterior_draw')
make_parameters(model, param_type = 'posterior_mean')

# Harder examples, using \code{define} and priors arguments to define
# specific parameters using causal syntax

# Using labels: Two values for two nodes with the same label
make_model('X -> M -> Y') \%>\% make_parameters(label = "01", parameters = c(0,1))
\donttest{
# Using statement:
make_model('X -> Y') \%>\%
   make_parameters(statement = c('Y[X=1]==Y[X=0]'), parameters = c(.2,0))
make_model('X -> Y') \%>\%
   make_parameters(statement = c('Y[X=1]>Y[X=0]', 'Y[X=1]<Y[X=0]'), parameters = c(.2,0))

# Normalize renormalizes values not set so that value set is not renomalized
make_parameters(make_model('X -> Y'),
               statement = 'Y[X=1]>Y[X=0]', parameters = .5)
make_parameters(make_model('X -> Y'),
               statement = 'Y[X=1]>Y[X=0]', parameters = .5, normalize = FALSE)

# May be built up
make_model('X -> Y') \%>\%
  set_confound(list(X = 'Y[X=1]>Y[X=0]'))  \%>\%
  set_parameters(confound   = list(X='Y[X=1]>Y[X=0]', X='Y[X=1]<=Y[X=0]'),
                 parameters = list(c(.2, .8), c(.8, .2))) \%>\%
  set_parameters(statement  = 'Y[X=1]>Y[X=0]', parameters = .5) \%>\%
  get_parameters
  }
}
\seealso{
Other parameters: 
\code{\link{get_parameters}()},
\code{\link{set_parameters}()}
}
\concept{parameters}
