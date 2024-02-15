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

def sample(stan_file, data):
    init = { 'pi': 0.2,
             'alpha_scalar': 2 }
    model = csp.CmdStanModel(stan_file = stan_file)
    sample = model.sample(data = data, show_console = True, refresh = 5,
                          iter_warmup=200, iter_sampling=200,
                          parallel_chains = 4,
                          chains = 1, # inits = init,
                          seed = 92584)
    return sample

data = rating_csv_to_dict('../data/caries.csv')
sample = sample('../stan/abcde.stan', data)
sample.summary()



