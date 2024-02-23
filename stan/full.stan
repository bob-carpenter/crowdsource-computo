#include FUNCTIONS-DATA.stan
transformed data {
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector[J] alpha_spec;
  vector<lower=-alpha_spec>[J] alpha_sens;
  vector[I] beta;
  vector<lower=0>[I] delta;
  vector<lower=0, upper=1>[I] lambda;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  alpha_spec ~ normal(0, 3);
  alpha_sens ~ normal(0, 3);
  beta ~ normal(0, 1);
  delta ~ lognormal(0, 0.5);
  lambda ~ beta(5, 5);
  target += log_lik;
}
#include GQ.stan
