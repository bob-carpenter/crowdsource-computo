#include FUNCTIONS-DATA.stan
transformed data {
  vector<lower=0>[I] delta = rep_vector(1, I);
  vector<lower=0, upper=1>[I] lambda = rep_vector(0, I);
  vector[J] alpha_spec = rep_vector(0, J);
  vector[J] alpha_sens = rep_vector(0, J);
#include DATA-COUNTS.stan
}
parameters {
  real<lower=0, upper=1> pi;
  vector<upper=0.0001>[I] beta;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ uniform(0, 1);
  beta ~ normal(0, 2);
  target += log_lik;
}
#include GQ.stan
