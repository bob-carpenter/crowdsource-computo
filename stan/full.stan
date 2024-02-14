data {
  int<lower=0> I;
  int<lower=0> J;
  int<lower=0> N;
  array[N] int<lower=1, upper=I> item;
  array[N] int<lower=1, upper=J> rater;
  array[N] int<lower=0, upper=1> rating;
}
parameters {
  real pi;
  vector[J] real alpha_sens;
  vector[J] real alpha_spec;
  vector[I] real beta;
  vector[I] delta;
  vector[I] lambda;
}
transformed parameters {
  vector[N] log_lik;
  {
    vector[I] delta_pos = exp(delta);
    vector[I] lambda_prob = inv_logit(lambda);
    vector[I] lambda1m_prob = inv_logit(-lambda);
  
    vector[I] lp_pos = rep_vector(log_inv_logit(pi), I);
    vector[I] lp_neg = rep_vector(log1m_inv_logit(pi), I);
    for (n in 1:N) {
      int i = item[n];
      int j = rater[n];
      int y = rating[n];
      lp_pos[i] += bernoulli_lpdf(y | lambda_prob[i] + lambda1m_prob[i] * inv_logit(delta[i] * (alpha_sens[j] - beta[i])));
      lp_neg[i] += bernoulli_lpdf(y | lambda1m_prob[i] * inv_logit(-delta[i] * (alpha_spec[j] - beta[i])));
    }
    for (i in 1:I) {
      log_lik[i] = log_sum_exp(lp_pos[i], lp_neg[i]);
    }
  }
}
model {
  pi ~ logistic(0, 1);
  alpha ~ logistic(0, 1);
  beta ~ logistic(0, 1);
  delta ~ logistic(0, 1);
  lambda ~ logistic(0, 1);
  target += log_lik;
}
