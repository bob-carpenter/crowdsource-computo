import cmdstanpy as csp
import numpy as np
import scipy as sp
import pandas as pd
import logging
import warnings

# warnings.simplefilter(action='ignore', category=FutureWarning)
# warnings.filterwarnings( "ignore", module = "plotnine\..*" )
csp.utils.get_logger().setLevel(logging.INFO)
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)


def rating_csv_to_dict(file):
    df = pd.read_csv(file, comment = '#')
    rater = df['rater'].to_list()
    item = df['item'].to_list()
    rating = df['rating'].to_list()
    I = int(np.max(item))
    J = int(np.max(rater))
    N = int(len(rater))
    data = { 'I': I, 'J': J, 'N': N,
             'item': item, 'rater': rater, 'rating': rating }
    return data

def sample(stan_file, data, init = {}):
    model = csp.CmdStanModel(stan_file = stan_file)
    sample = model.sample(data = data, inits = init,
                          iter_warmup=100, iter_sampling=100,
                          chains = 2, parallel_chains = 4,
                          show_console = True, show_progress=False,
                          refresh = 10,
                          seed = 925845)
    return sample

data = rating_csv_to_dict('../data/caries.csv')
init = {
    'pi': 0.2,
    'alpha_acc_scalar': 2,
    'alpha_sens_scalar': 1,
    'alpha_spec_scalar': 1,
    'alpha_acc': np.full(data['J'], 2),
    'alpha_sens': np.full(data['J'], 1),
    'alpha_spec': np.full(data['J'], 2),
    'beta': np.full(data['I'], 0),
    'delta': np.full(data['I'], 1),
    'lambda': np.full(data['I'], 0.5)
}         

models = ['d', 'cd', 'bd', 'bcd', 'ad', 'acd', 'abd', 'abcd', 'abcde',  # acc
              'full', 'c', 'bc', 'a', 'ac', 'ab', 'abc', 'abce',   # sens
              'abde' ]  # no rater effects

rater_labels = [f"rater_sim[{i}]" for i in range(1, 6)]
rater_lt_labels = [f"rater_sim_lt_data[{i}]" for i in range(1, 6)]
votes_labels = [f"votes_sim[{i}]" for i in range(1, 7)]
votes_lt_labels = [f"votes_sim_lt_data[{i}]" for i in range(1, 7)]

models = ['abc', 'abcd']
rows = []
for model in models:
    print(f"{model = }")
    draws = sample('../stan/' + model + '.stan', data, init)
    post_summary = draws.summary()
    post_rhat = post_summary['R_hat']
    post_means = post_summary['Mean']
    rhat_lp = post_rhat['lp__']
    rhat_max = np.max(post_rhat)
    pi = post_means['pi']
    log_lik = post_means['log_lik']
    rater_sim = post_means[rater_labels]
    rater_lt_sim = post_means[rater_lt_labels]
    votes_sim = post_means[votes_labels]
    votes_lt_sim = post_means[votes_lt_labels]
    row = {'model': [model], 'rhat_max': [rhat_max], 'rhat_lp': [rhat_lp], 'pi': [pi], 'log_lik': log_lik }
    row.update(dict(zip(rater_labels, rater_sim)))
    row.update(dict(zip(rater_lt_labels, rater_lt_sim)))
    row.update(dict(zip(votes_labels, votes_sim)))
    row.update(dict(zip(votes_lt_labels, votes_lt_sim)))
    rows.append(pd.DataFrame(row))

results_df = pd.concat(rows)
    




