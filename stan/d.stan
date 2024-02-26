#include FUNCTIONS-DATA.stan
transformed data {
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector<lower=0>[J] alpha_acc;
  vector[I] beta;
  vector<lower=0>[I] delta;
  vector<lower=0, upper=1>[I] lambda; // = rep_vector(lambda_scalar, I);
}
transformed parameters {
  vector[J] alpha_sens = alpha_acc;
  vector[J] alpha_spec = alpha_acc;
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ beta(2, 2);
  alpha_acc ~ normal(1, 2);
  beta ~ normal(0, 1);
  delta ~ lognormal(0, 0.25);
  lambda ~ beta(2, 2);
  target += log_lik;
}
#include GQ.stan
