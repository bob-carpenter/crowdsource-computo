#include FUNCTIONS-DATA.stan
transformed data {
  vector<lower=0>[I] delta = rep_vector(1, I);
  vector<lower=0, upper=1>[I] lambda = rep_vector(0, I);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector<lower=0>[J] alpha_acc;  // constraint => cooperative
  vector[I] beta;
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
  // sum(beta) ~ normal(0, 1);  // soft sum to zero
  target += log_lik;
}
#include GQ.stan
