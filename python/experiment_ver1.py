import cmdstanpy as csp
import numpy as np
import pandas as pd
import logging
import warnings
from tqdm import tqdm

# Handling warnings and logging
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.filterwarnings("ignore", module="plotnine\..*")
csp.utils.get_logger().setLevel(logging.ERROR)
pd.set_option('display.max_rows', None)
pd.set_option('display.max_columns', None)

def rating_csv_to_dict(file):
    df = pd.read_csv(file, comment='#')
    rater = df['rater'].to_list()
    item = df['item'].to_list()
    rating = df['rating'].to_list()
    I = int(np.max(item))
    J = int(np.max(rater))
    N = int(len(rater))
    data = {'I': I, 'J': J, 'N': N, 'item': item, 'rater': rater, 'rating': rating}
    return data

def sample(stan_file, data, init={}):
    model = csp.CmdStanModel(stan_file=stan_file)
    return model.sample(data=data, inits=init, iter_warmup=1000, iter_sampling=1000, chains=2, parallel_chains=4, show_console=True, show_progress=True, refresh=100, seed=925845)

def min_p_twosided(ps):
    return np.fmin(np.min(ps), 1 - np.max(ps)) / 2

def p_twosided(ps):
    return np.fmin(ps, 1 - ps) / 2

# Data loading and initialization
data_file = 'rte.csv'
data_path = '../data/' + data_file
data = rating_csv_to_dict(data_path)
init = {
    'pi': 0.2,
    'alpha_acc_scalar': 2,
    'alpha_sens_scalar': 1,
    'alpha_spec_scalar': 2,
    'alpha_acc': np.full(data['J'], 2),
    'alpha_sens': np.full(data['J'], 1),
    'alpha_spec': np.full(data['J'], 2),
    'beta': np.full(data['I'], 0),
    'delta': np.full(data['I'], 1),
    'lambda': np.full(data['I'], 0.5)
}    

J = data['J']
    
rater_labels = [f"rater_sim[{i}]" for i in range(1, J)]
rater_lt_labels = [f"rater_sim_lt_data[{i}]" for i in range(1, J)]
votes_labels = [f"votes_sim[{i}]" for i in range(1, J + 1)]
votes_lt_labels = [f"votes_sim_lt_data[{i}]" for i in range(1, J + 1)]

# models = ['a', 'ab', 'abc', 'abcd', 'abcde', 'abce', 'abd', 'abde', 'ac', 'acd', 'ad', 'bc', 'bcd', 'bd', 'c', 'cd', 'd', 'full']
models = ['a', 'ab', 'abc']
results = []

for model in tqdm(models, desc="Processing Models"): 
    print(f"***** Processing model: {model}")
    draws = sample(f'../stan/{model}.stan', data, init)
    post_summary = draws.summary()
    # print(post_summary)
    post_means = post_summary['Mean']
    rater_lt_sim = post_means[rater_lt_labels]
    votes_lt_sim = post_means[votes_lt_labels]
    
    # Calculating two-sided p-values
    raters_p = p_twosided(rater_lt_sim)
    votes_p = p_twosided(votes_lt_sim)

    min_raters_p = min_p_twosided(rater_lt_sim)
    min_votes_p = min_p_twosided(votes_lt_sim)

    # Gathering results
    stats = {
        'model': model,
        'min_raters_p': min_raters_p,
        'min_votes_p': min_votes_p,
        'mean_raters_p': np.mean(raters_p),
        'median_raters_p': np.median(raters_p),
        'std_dev_raters_p': np.std(raters_p),
        '90_CI_lower_raters': np.percentile(raters_p, 5),
        '90_CI_upper_raters': np.percentile(raters_p, 95),
        'mean_votes_p': np.mean(votes_p),
        'median_votes_p': np.median(votes_p),
        'std_dev_votes_p': np.std(votes_p),
        '90_CI_lower_votes': np.percentile(votes_p, 5),
        '90_CI_upper_votes': np.percentile(votes_p, 95)
    }
    results.append(stats)

# Convert results to a DataFrame for easier handling and visualization
results_df = pd.DataFrame(results)
print(results_df)
results_df.to_csv('results_summary.csv', index=False, sep=',', encoding='utf-8')
