# Data

All scripts and data are stored here.

## `summary_stats.py`

This script computes summary statistics
(maximum, mean, medium, and standard deviation)
from the various tests.
It also produces plots of the gas cost.

## `analysis.py`

This script performs a detailed analysis where
the miniimum gas cost is determined for each value
and which algorithms are minimal.

## `loguniform.py`

This script was used to determine 1024 unique integers
within the range $[0, 2^{256})$
based on a loguniform distribution.
The individual values are sorted as raw numbers in
`loguniform_raw.csv`
while `loguniform_data.ts` is formatted for easy inclusion
for testing.
