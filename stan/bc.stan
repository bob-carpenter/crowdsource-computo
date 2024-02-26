#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector<lower=0>[I] delta = rep_vector(1, I);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector[J] alpha_spec;
  vector<lower=-alpha_spec>[J] alpha_sens;
  vector<lower=0, upper=1>[I] lambda;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ beta(2, 2);
  alpha_spec ~ normal(2, 2);
  alpha_sens ~ normal(1, 2);
  lambda ~ beta(2, 2);
  target += log_lik;
}
#include GQ.stan
