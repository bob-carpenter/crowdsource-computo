generated quantities {
  array[J + 1] int<lower = 0> votes_sim;
  array[J] int votes_by_anno_sim = rep_array(0, J);
  {
    array[N] int rating_sim;
    array[I] int z_sim;
    for (i in 1:I) {
      z_sim[i] = bernoulli_rng(pi);
    }
    for (n in 1:N) {
      int i = item[n];
      int j = rater[n];
      rating_sim[n]
        = bernoulli_rng(z_sim[i] == 1
                        ? lambda[i]
                        + (1 - lambda[i])
                          * inv_logit(delta[i] * (alpha_sens[j] - beta[i]))
                        : (1 - lambda[i])
                          * inv_logit(-delta[i] * (alpha_spec[j] -  beta[i])));
                        
    }
    votes_sim = vote_count(rating_sim, item, rater, I, J);
    for (n in 1:N) {
      votes_by_anno_sim[rater[n]] += rating_sim[n];
    }
  }   
}

