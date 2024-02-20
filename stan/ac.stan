#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector[I] lambda = rep_vector(0, I);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector[J] alpha_spec;
  vector<lower=-alpha_spec>[J] alpha_sens;  // constraint -> cooperative
  vector<lower=0>[I] delta;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  alpha_spec ~ logistic(0, 1);
  alpha_sens ~ logistic(0, 1);
  delta ~ lognormal(0, 0.25);
  target += log_lik;
}
#include GQ.stan
