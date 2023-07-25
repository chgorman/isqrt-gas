#!/usr/bin/env python3

import numpy as np
from scipy.stats import loguniform

total_data_points = 16384
sample_size = 16808
#total_data_points = 8192
#sample_size = 8377
#total_data_points = 4096
#sample_size = 4161
#total_data_points = 2048
#sample_size = 2072

# 0 in tested values
test_values = []

# Add loguniform random values
np.random.seed(0)
a = 1.0
b = 2.0**256
r = loguniform.rvs(a, b, size=sample_size)
for x in r:
    test_values += [int(x)]
test_values = sorted(set([int(x) for x in test_values ]))
#for x in values:
#    print(x)
assert len(test_values) == total_data_points

# write raw data to file
raw_file = "data_points_rnd.csv"
with open(raw_file, "w") as f:
    for x in test_values:
        f.write("%d\n" % x)
