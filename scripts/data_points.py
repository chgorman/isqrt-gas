#!/usr/bin/env python3

import numpy as np
from scipy.stats import loguniform

total_data_points = 2048

# 0 in tested values
test_values = []

# Add all 2**k
for k in range(256):
    x = 2**k
    assert x < 2**256
    test_values += [x]

# Add all 2**k - 1
for k in range(257):
    x = 2**k - 1
    assert x < 2**256
    test_values += [x]

# Add all 2**k + 1
for k in range(1,255):
    x = 2**k + 1
    assert x < 2**256
    test_values += [x]

# Add additional important test values
value = (2**128 - 1)**2
x = value - 1
assert x < 2**256
test_values += [x]
x = value
assert x < 2**256
test_values += [x]
x = value + 1
assert x < 2**256
test_values += [x]

# Add loguniform random values
np.random.seed(0)
a = 1.0
b = 2.0**256
sample_size = 1303
r = loguniform.rvs(a, b, size=sample_size)
for x in r:
    test_values += [int(x)]
test_values = sorted(set([int(x) for x in test_values ]))
#for x in values:
#    print(x)
assert len(test_values) == total_data_points

# write raw data to file
raw_file = "data_points.csv"
with open(raw_file, "w") as f:
    for x in test_values:
        f.write("%d\n" % x)
