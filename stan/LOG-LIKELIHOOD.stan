  vector[I] log_lik;
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
      lp_pos[i] += bernoulli_lpmf(y | lambda_prob[i] + lambda1m_prob[i] * inv_logit(delta_pos[i] * (alpha_sens[j] - beta[i])));
      lp_neg[i] += bernoulli_lpmf(y | lambda1m_prob[i] * inv_logit(-delta_pos[i] * (alpha_spec[j] - beta[i])));
    }
    for (i in 1:I) {
      log_lik[i] = log_sum_exp(lp_pos[i], lp_neg[i]);
    }
  }
