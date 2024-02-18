#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector<lower=0>[I] delta = rep_vector(1, I);
  vector<lower=0, upper=1>[I] lambda = rep_vector(0, I);
}
parameters {
  real<lower=0, upper=1> pi;
  vector[J] alpha_spec;
  vector<lower=-alpha_spec>[J] alpha_sens;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  alpha_spec ~ logistic(0, 1);
  alpha_sens ~ logistic(0, 1);
  target += log_lik;
}
#include GQ.stan
