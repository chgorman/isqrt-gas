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

value_array = np.empty([1], dtype=int)
valueInt_array = []
gas_array = np.empty([1], dtype=int)
#print(value_array)
#print(gas_array)

if len(sys.argv) < 2:
    raise ValueError("Must have at least one input")

total_sys_args = len(sys.argv)

file_names = []

# Open first file
input_file = sys.argv[1]
res = input_file.split('.')
if len(res) != 2:
    raise ValueError("Input must be csv file")
file_pre = res[0]

with open(input_file, 'r') as csvfile:
    lines = csv.reader(csvfile, delimiter=',', quotechar='\"')
    header = False
    for row in lines:
        if not header:
            if len(row) != 1:
                continue
            version = row[0]
            file_names += [version]
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
        valueInt_array += [valueInt]

gas_array = gas_array[1:]
value_array = value_array[1:]
#print(gas_array)
#print(value_array)
#print(valueInt_array)

total_gas_array = np.zeros([gas_array.size, total_sys_args-1], dtype=int)
total_gas_array[:, 0] = gas_array

gas_array_size = gas_array.size

# Open additional files file
for k in range(2, total_sys_args):
    input_file = sys.argv[k]
    res = input_file.split('.')
    if len(res) != 2:
        raise ValueError("Input must be csv file")

    count = 0
    with open(input_file, 'r') as csvfile:
        lines = csv.reader(csvfile, delimiter=',', quotechar='\"')
        header = False
        for row in lines:
            if not header:
                if len(row) != 1:
                    continue
                version = row[0]
                file_names += [version]
                header = True
                continue
            if len(row) != 3:
                continue
            value = float(row[0])
            gas = float(row[1])
            valueInt = int(row[0])
            ret = int(row[2])
            assert ret == m.isqrt(valueInt), "Invalid return value: %d" % valueInt
            total_gas_array[count, k-1] = gas
            count += 1
    assert count == gas_array_size

# All gas data is now located in total_gas_array

# Need to
#   Loop through total_gas_array row by row
#   Compute minimum of each row
#   Find indices which gives minimum
#   Store value and gas in corresponding

total_algs = total_sys_args - 1
total_gas_args = gas_array.size

total_min_count = np.zeros(total_algs, dtype=int)
total_min_index = np.zeros([total_gas_args, total_algs], dtype=int)
total_min_gas = np.zeros([total_gas_args, total_algs], dtype=int)

#print()
#print()
#print()
#print("total_algs:", total_algs)

# Find gas min across all algs
for k in range(total_gas_args):
    gas_min = total_gas_array[k,:].min()
    #print("Min gas:", gas_min)
    value = value_array[k]
    #print("Arg:    ", value)
    #print()
    for j in range(total_algs):
        if total_gas_array[k, j] == gas_min:
            # store reference to it
            loc = total_min_count[j]
            total_min_index[loc, j] = k
            total_min_gas[loc, j] = gas_min
            total_min_count[j] += 1

print(file_names)
print(total_min_count)
#print(total_min_index)
#print(total_min_gas)
#print()
#print(total_gas_array)

# Want to save minimal values (actual value, not index) and gas costs
# to csv for reference.
# Then make plot of the values

for alg_index in range(total_algs):
    alg_num_minimal = total_min_count[alg_index]
    if alg_num_minimal > 0:
        min_alg_file_csv = "minimal_values_" + file_names[alg_index] + ".csv"
        min_alg_file_plot = "minimal_plot_" + file_names[alg_index] + ".pdf"
        min_alg_file_hist = "minimal_hist_" + file_names[alg_index] + ".pdf"
        
        min_value_array = np.zeros(alg_num_minimal)
        min_gas_array = np.zeros(alg_num_minimal)

        with open(min_alg_file_csv, 'w', newline='') as csvfile:
            cwriter = csv.writer(csvfile, delimiter=',')

            # Something is wrong with value;
            # not printing the correct **value**
            count = 0
            for iter_index in range(alg_num_minimal):
                # need to form arrays, save to file, and then make plot
                # write row to file
                value_index = total_min_index[iter_index, alg_index]
                value_valueInt = valueInt_array[value_index]
                value_min_gas = total_min_gas[iter_index, alg_index]
                cwriter.writerow([value_valueInt, value_min_gas])
                # save value to arrays
                if value_valueInt == 0:
                    # get around log(0) problems
                    min_value_array[count] = 1
                else:
                    min_value_array[count] = value_valueInt
                min_gas_array[count] = value_min_gas
                count += 1
        
        # Plot Setup for individual gas costs when minimal
        fig, axs = plt.subplots(1, 1)

        # plot the functions
        plt.title(r'Minimal Isqrt Gas Cost (' + file_names[alg_index] + ')')
        plt.xlabel('Argument', fontsize=24)
        plt.ylabel('Gas Cost', fontsize=24)
        plt.scatter(min_value_array, min_gas_array, s = 3.0)
        plt.xscale('log', base=2)
        plt.xlim([1, 2.0**256.0])
        plt.ylim([-50, 1050])

        axs.xaxis.set_ticks([2.0**(32*k) for k in range(1,8)])

        # show the plot
        figName = min_alg_file_plot
        plt.savefig(figName, bbox_inches='tight')
        plt.close()

        # Histogram Plot
        fig, axs = plt.subplots(1, 1)
        num_bins = 64
        plt.title(r'Minimal Isqrt Gas Histogram ('+ file_names[alg_index] +')')
        plt.xlabel('Argument', fontsize=24)
        plt.ylabel('Number', fontsize=24)
        # compute logarithmic bins
        log_bins = np.logspace(0.0, 256.0 * np.log10(2), num_bins)

        plt.hist(min_value_array, bins=log_bins)
        plt.xscale('log', base=2)
        plt.xlim([1, 2.0**256.0])
        plt.ylim([0, 40]) # Standard: 40; Extended Det: 625; Extended Rnd: 300
        axs.xaxis.set_ticks([2.0**(32*k) for k in range(1,8)])

        # show the plot
        figName = min_alg_file_hist
        plt.savefig(figName, bbox_inches='tight')
        plt.close()


# print minimal summary
filename = "minimal_summary.csv"
with open(filename, 'w', newline='') as csvfile:
    cwriter = csv.writer(csvfile, delimiter=',')
    cwriter.writerow(["Total", total_gas_args])
    for alg_index in range(total_algs):
        #file_names[alg_index]
        cwriter.writerow([file_names[alg_index], total_min_count[alg_index]])
