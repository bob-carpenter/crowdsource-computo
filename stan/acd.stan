#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector[I] lambda = rep_vector(0, I);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector<lower=0>[J] alpha_acc; // constraint => cooperative
  vector<lower=0>[I] delta;
}
transformed parameters {
  vector[J] alpha_sens = alpha_acc;
  vector[J] alpha_spec = alpha_acc;
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ beta(2, 2);
  alpha_acc ~ normal(1, 2);
  delta ~ lognormal(0, 0.25);
  target += log_lik;
}
#include GQ.stan
