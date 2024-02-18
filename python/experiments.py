import cmdstanpy as csp
import numpy as np
import scipy as sp
import pandas as pd
pd.set_option('display.max_rows', None)

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
    sample = model.sample(data = data, show_console = True, refresh = 5,
                          iter_warmup=500, iter_sampling=500,
                          parallel_chains = 4,
                          chains = 2, inits = init,
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
    'lambda': np.full(data['I'], 0.5),
}         

# sens = spec models
draws_a = sample('../stan/a.stan', data, init)
draws_ab = sample('../stan/ab.stan', data, init)
draws_abd = sample('../stan/abd.stan', data, init)
draws_abc = sample('../stan/abc.stan', data, init)
draws_abcd = sample('../stan/abcd.stan', data, init)
draws_abcde = sample('../stan/abcde.stan', data, init)
draws_abce = sample('../stan/abce.stan', data, init)
draws_ac = sample('../stan/ac.stan', data, init)
draws_acd = sample('../stan/acd.stan', data, init)
draws_ad = sample('../stan/ad.stan', data, init)

# draws_abcde.summary()



