#!/usr/bin/env python3

import sys
import csv
import math as m
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np

plt.rcParams.update({
    'font.size': 16,
    'text.usetex': True,
    'text.latex.preamble': r'\usepackage{amsfonts}'
})

value_array = np.empty(1)
gas_array = np.empty(1)

if len(sys.argv) != 2:
    raise ValueError("Require only one input")

input_file = sys.argv[1]
res = input_file.split('.')
if len(res) != 2:
    raise ValueError("Input must be csv file")
file_pre = res[0]
res = file_pre.split('_')
if len(res) != 2:
    raise ValueError("Invalid csv file name")
name_value = res[1]

with open(input_file, 'r') as csvfile:
    lines = csv.reader(csvfile, delimiter=',', quotechar='\"')
    header = False
    for row in lines:
        if not header:
            if len(row) != 1:
                continue
            version = row[0]
            header = True
            continue
        if len(row) != 3:
            continue
        value = float(row[0])
        gas = float(row[1])
        valueInt = int(row[0])
        ret = int(row[2])
        assert ret == m.isqrt(valueInt), "Invalid return value: %d" % valueInt
        value_array = np.append(value_array, value)
        gas_array = np.append(gas_array, gas)

gas_array = gas_array[1:]
value_array = value_array[1:]

print("Max:    %5.0f" % gas_array.max())
print("Mean:   %5.0f" % np.mean(gas_array))
print("Median: %5.0f" % np.median(gas_array))
print("Std:    %5.0f" % np.std(gas_array))

data_array = np.array([gas_array.max(), np.mean(gas_array), np.median(gas_array), np.std(gas_array)])
data_array = np.reshape(data_array, (1,4))
data_array = np.ceil(data_array)
data_array = data_array.astype(int)

data_file = "stats_" + name_value + ".csv"
#file_pre = res[0]

writer = csv.writer(open(data_file, 'w'))
np.savetxt(data_file, data_array, delimiter=',', fmt='%d')

# Plot Setup
fig, axs = plt.subplots(1, 1)

# plot the functions
plt.title(r'ISqrt Gas Cost (' + version + ')')
plt.xlabel('Argument', fontsize=24)
plt.ylabel('Gas Cost', fontsize=24)
plt.scatter(value_array, gas_array, s = 3.0)
plt.xscale('log', base=2)
plt.xlim([1, 2.0**256.0])

if gas_array.max() <= 1300:
    plt.ylim([-50, 1300])

axs.xaxis.set_ticks([2.0**(32*k) for k in range(1,8)])

# show the plot
figName = "plot_" + name_value + ".pdf"
plt.savefig(figName, bbox_inches='tight')
plt.close()
