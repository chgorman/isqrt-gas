# Analysis of Integer Square Root Algorithms in Solidity

This project analyzes the gas cost of computing
integer square roots in Solidity.
This includes a number of algorithms from various projects online
(with citations);
some of these algorithms are new and provably correct.

An extended discussion of the results may be found in `report/`,
specifically [here](./report/isqrt_analysis.pdf).

## Setup

Before running the analysis, it is necessary to ensure that `hardhat`
is installed and the files are compiled.
This may be performed by running

```shell
npm install hardhat
npx hardhat compile
```

## Analysis

### Standard Analysis

To run the analysis,

```shell
./analyze_data.sh
```

This script will construct a list of `uint256` values
and then run each value through a number of integer square root algorithms
while recording the total amount of gas used per function call.
After all the gas values are computed,
a collection of summary statistics (max, mean, median, and standard deviation)
are computed for each algorithm.
From there, the individual minimum between all algorithms
are computed for each `uint256` value.
A number of plots are made and results are tabulated.

All of the results are stored in `data/`.
During the analysis, the correctness of each computed value
(the value returned by the integer square root functions)
is confirmed.

The total time to run this analysis is approximately 2.5 minutes.
Approximately 30 seconds of this is due to the UniswapV2 analysis.
To run the "quick" standard analysis (with UniswapV2 removed),
run

```shell
./analyze_data.sh -q
```

The time to run this analysis is approximately 2 minutes.

### Choice of Data Points

In order to compare the different algorithms,
specific `uint256` values must be tested.
The specific values were included:

 -  $2^{k}-1$, $2^{k}$, and $2^{k} + 1$ for integer values of $k$
 -  $v-1$, $v$, and $v+1$ for $v = (2^{128}-1)^{2}$
 -  Random values according to a
    [loguniform distribution](https://en.wikipedia.org/wiki/Reciprocal_distribution)
    on $[1, 2^{256}]$ using
    [Scipy](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.loguniform.html)
    with the
    [random seed](https://numpy.org/doc/stable/reference/random/generated/numpy.random.seed.html)
    set to 0.

The number of deterministic values is 768.
Random values were added until to the total number
of unique data points was equal to 2048;
the number of random samples required were 1303 for 1280 random values.
While different data points will lead to different statistics,
it is thought that this sample size is sufficient to determine
which algorithm is most efficient.

### Extended Analysis

Additional analysis may be performed to verify the results from the Appendix;
only the top 4 algorithms are tested.
The extended deterministic test takes approximately 8 minutes
with results stored in `data/extended_det/` and may be ran by

```shell
./analyze_data.sh -d
```

The extended random test takes approximately 4 minutes
with results stored in `data/extended_rnd/` and may be ran by

```shell
./analyze_data.sh -r
```

### Results

These two tables show the summary statistics from the algorithms tested.
These are Tables 2, 3, and 4 from the report.

|          | UniswapV2 | PRB | PRBv2 | OpenZeppelin | ABDK | OpenZeppelinV2 |
| :------- | --------: | --: | ----: | -----------: | ---: | -------------: |
|  Max     |  33931    | 874 |  474  |    1015      |  877 |       823      |
|  Mean    |  17591    | 791 |  474  |     944      |  798 |       749      |
|  Median  |  17497    | 794 |  474  |     943      |  799 |       751      |
|  Std     |   9482    |  34 |    0  |      30      |   33 |        35      |

|          | Unrolled1 | Unrolled2 | **Unrolled3** | While1 | While2 | While3 |
| :------- | --------: | --------: | ------------: | -----: | -----: | -----: |
|  Max     |    275    |    275    |    **269**    |   677  |   665  |   626  |
|  Mean    |    275    |    275    |    **269**    |   448  |   551  |   459  |
|  Median  |    275    |    275    |    **269**    |   482  |   535  |   496  |
|  Std     |      0    |      0    |      **0**    |   119  |   102  |    85  |

|          | BitLength | Linear | Hyper4 | Lookup4 | Lookup8 |
| :------- | --------: | -----: | -----: | ------: | ------: |
|  Max     |    349    |  279   |  287   |   285   |   440   |
|  Mean    |    344    |  279   |  287   |   285   |   440   |
|  Median  |    339    |  279   |  287   |   285   |   440   |
|  Std     |      5    |    0   |    0   |     0   |     0   |

These results show how many times each algorithm was minimal.
Algorithms not included were never minimal.
This is Table 5 from the report.

|    Total           |    2048    |
| :----------------- |  -------:  |
|    UniswapV2       |       2    |
|    OpenZeppelinV2  |       2    |
|  **Unrolled3**     |  **1582**  |
|    While1          |     282    |
|    While2          |     134    |
|    While3          |      46    |

This is the most efficient algorithm (Unrolled3)
for computing integer square roots;
it is also provably correct.
It has the lowest mean, median, and maximum gas costs.
See `report/` for more information.

```solidity
// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256 result) {
    assembly ("memory-safe") {
        result := clz(x)
        result := sub(255, result)
        // If
        //
        //      2**(k-1) <= x < 2**k
        //
        // we now have
        //
        //      result == k-1

        result := shr(1, shl(shr(1, result), 3))
        // If
        //
        //      2**(f-1) <= sqrt(x) < 2**f
        //
        // we now have
        //
        //      result == 2**(f-1) + 2**(f-2)

        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))
        result := shr(1, add(result, div(x, result)))

        result := sub(result, gt(result, div(x, result)))
    }
}
```

## Note on License

As noted, all **new** algorithms and all supporting code is licensed under
[BSD Zero Clause License](https://spdx.org/licenses/0BSD.html).
Additional algorithms and code are from other projects and
**have different licenses**.
