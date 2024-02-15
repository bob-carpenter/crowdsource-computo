#include FUNCTIONS-DATA.stan
parameters {
  real pi;
  vector[J] real alpha_sens;
  vector[J] real alpha_spec;
  vector[I] real beta;
  vector[I] delta;
  vector[I] lambda;
}
transformed parameters {
#include LOG-LIKELIHOOD.stan
}
model {
  pi ~ logistic(0, 1);
  alpha ~ logistic(0, 1);
  beta ~ logistic(0, 1);
  delta ~ logistic(0, 1);
  lambda ~ logistic(0, 1);
  target += log_lik;
}
#include GQ.stan
