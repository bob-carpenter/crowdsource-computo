#include FUNCTIONS-DATA.stan
transformed data {
  vector<lower=0>[I] delta = rep_vector(1, I);
  vector<lower=0, upper=1>[I] lambda = rep_vector(0, I);
  vector[J] alpha_spec = rep_vector(0, J);
  vector[J] alpha_sens = rep_vector(0, J);
#include DATA-COUNTS.stan
}
parameters {
  vector[I] beta;
}
transformed parameters {
  real<lower=0, upper=1> pi = 1;  // pin to identify, include output
#include LOG-LIKELIHOOD.stan
}
model {
  beta ~ normal(0, 1);
  target += log_lik;
}
#include GQ.stan
