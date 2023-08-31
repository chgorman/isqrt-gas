#!/usr/bin/env python3

import math as m

values = [k for k in range(4, 16)]

max_value = 1024
base = 16

print(" v    LowerB  UpperB      mu      Diff     Base")
print("-----------------------------------------------")

# Compute values
for v in values:
    lower = 0
    for ell in range(max_value):
        if ((ell**2 <= v * base**2) and ((ell+1)**2 > v * base**2)):
            lower = ell
            break
    upper = 0
    for ell in range(max_value, 0, -1):
        if ((ell**2 >= (v+1) * base**2) and ((ell-1)**2 < (v+1) * base**2)):
            upper = ell
            break
    mu = (14 + v) * 2
    approx_diff_lower = abs(mu - lower)
    approx_diff_upper = abs(mu - upper)
    approx_diff = approx_diff_lower
    if approx_diff_upper > approx_diff_lower:
        approx_diff = approx_diff_upper
    print("%3d   %4d    %4d      %4d        %1d       %2d" % (v, lower, upper, mu, approx_diff, base))

