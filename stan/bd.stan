#include FUNCTIONS-DATA.stan
transformed data {
  vector<lower=0>[I] delta = rep_vector(1, I);
}
parameters {
  real<lower=0, upper=1> pi;
  vector<lower=0>[J] alpha_acc;
  vector[I] beta;
  vector<lower=0, upper=1>[I] lambda;
}
transformed parameters {
  vector[J] alpha_sens = alpha_acc;
  vector[J] alpha_spec = alpha_acc;
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  alpha_acc ~ normal(0, 3);
  beta ~ normal(0, 1);
  lambda ~ uniform(0, 1);
  target += log_lik;
}
#include GQ.stan