#!/usr/bin/env python3

import math as m

values = [k for k in range(4, 16)]

max_value = 1024
base = 8
hex_values = []
max_diff = 0

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
    diff = upper - lower
    if diff > max_diff:
        max_diff = diff
    h_value = 0
    if diff == 1:
        h_value = upper
    if diff == 2:
        h_value = upper - 1
    if diff == 3:
        h_value = upper - 1
    approx_diff_lower = abs(h_value - lower)
    approx_diff_upper = abs(h_value - upper)
    approx_diff = approx_diff_lower
    if approx_diff_upper > approx_diff_lower:
        approx_diff = approx_diff_upper
    print("%3d   %4d    %4d      %4d        %1d       %2d" % (v, lower, upper, h_value, approx_diff, base))

    hex_values += [h_value]

print()
print("Max diff between upper and lower bounds:", max_diff)
print()
print(hex_values)
print()
print(''.join(["\\" + "x" + h.to_bytes(1, byteorder="big").hex() for h in hex_values]))
