#include FUNCTIONS-DATA.stan
transformed data {
  vector[I] beta = rep_vector(0, I);
  vector[I] delta = rep_vector(1, I);
  vector[I] lambda = rep_vector(0, I);
}
parameters {
  real pi;
  real<lower=0> alpha_acc_scalar;
}
transformed parameters {
  vector[J] alpha_sens = rep_vector(alpha_acc_scalar, J);
  vector[J] alpha_spec = rep_vector(alpha_acc_scalar, J);
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ logistic(0, 1);
  alpha_acc_scalar ~ logistic(0, 1);
  target += log_lik;
}
#include GQ.stan
