#!/usr/bin/env python3

import numpy as np

# 0 in tested values
test_values = []

# Add all 2**k
for k in range(257):
    v = 2**k
    for m in [-1, 0, 1]:
        x = v + m
        if (x >= 0) and (x < 2**256):
            assert x >= 0
            assert x < 2**256
            test_values += [x]

for k in range(257):
    for j in range(k):
        x = 2**k + 2**j
        if (x >= 0) and (x < 2**256):
            assert x >= 0
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

test_values = sorted(set(test_values))

# write raw data to file
raw_file = "data_points_det.csv"
with open(raw_file, "w") as f:
    for x in test_values:
        f.write("%d\n" % x)
