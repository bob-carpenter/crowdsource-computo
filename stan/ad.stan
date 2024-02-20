#include FUNCTIONS-DATA.stan
transformed data {
  vector<lower=0, upper=1>[I] lambda = rep_vector(0, I);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector<lower=0>[J] alpha_acc;  // constraint => cooperative
  vector[I] beta;
  vector<lower=0>[I] delta;
}
transformed parameters {
  vector[J] alpha_sens = alpha_acc;
  vector[J] alpha_spec = alpha_acc;
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  alpha_acc ~ logistic(0, 1);
  beta ~ logistic(0, 1);
  sum(beta) ~ normal(0, 1);  // soft sum to zero
  delta ~ lognormal(0, 0.25);
  target += log_lik;
}
#include GQ.stan
