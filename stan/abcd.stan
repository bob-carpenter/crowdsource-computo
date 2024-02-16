#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector[I] delta = rep_vector(1, I);
  vector[I] lambda = rep_vector(0, I);
}
parameters {
  real pi;
  real<lower=0>[J] alpha_acc;
}
transformed parameters {
  vector[J] alpha_sens = alpha_acc;
  vector[J] alpha_spec = alpha_acc;
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ logistic(0, 1);
  alpha_acc ~ logistic(0, 1);
  target += log_lik;
}
#include GQ.stan
