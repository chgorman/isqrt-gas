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

|          | UniswapV2 | PRB | OpenZeppelin | ABDK | OpenZeppelinV2 |
| :------- | --------: | --: | -----------: | ---: | -------------: |
|  Max     |  33931    | 874 |    1015      |  877 |       823      |
|  Mean    |  17591    | 791 |     944      |  799 |       749      |
|  Median  |  17497    | 794 |     943      |  799 |       751      |
|  Std     |   9482    |  34 |      30      |   33 |        35      |

|          | Unrolled1 | Unrolled2 | **Unrolled3** | While1 | While2 | While3 |
| :------- | --------: | --------: | ------------: | -----: | -----: | -----: |
|  Max     |    837    |    837    |    **790**    |  1200  |  1152  |  1130  |
|  Mean    |    762    |    762    |    **730**    |   815  |   872  |   831  |
|  Median  |    765    |    765    |    **730**    |   858  |   907  |   854  |
|  Std     |     33    |     33    |     **28**    |   176  |   155  |   135  |

|          | BitLength | Linear | Hyper4 | Lookup4 | Lookup8 |
| :------- | --------: | -----: | -----: | ------: | ------: |
|  Max     |    833    |  796   |  826   |   903   |   906   |
|  Mean    |    762    |  739   |  769   |   846   |   849   |
|  Median  |    762    |  739   |  769   |   846   |   849   |
|  Std     |     30    |   28   |   29   |    30   |    30   |

These results show how many times each algorithm was minimal.
Algorithms not included were never minimal.
This is Table 5 from the report.

|    Total           |    2048    |
| :----------------- |  -------:  |
|    UniswapV2       |       2    |
|    OpenZeppelinV2  |       2    |
|    Unrolled1       |       2    |
|    Unrolled2       |       2    |
|  **Unrolled3**     |  **1188**  |
|    While1          |     383    |
|    While2          |     186    |
|    While3          |     295    |
|    BitLength       |       2    |
|    Linear          |       2    |
|    Hyper4          |       2    |
|    Lookup4         |       2    |
|    Lookup8         |       2    |

This is the most efficient algorithm (Unrolled3)
for computing integer square roots;
it is also provably correct.
It has the lowest mean, median, and maximum gas costs.
See `report/` for more information.

```solidity
// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        // Take care of easy edge cases
        if (x <= 1) {
            return x;
        }

        // If we have
        //
        //      2^{e-1} <= sqrt(x) < 2^{e},
        //
        // then at the end of initialization, we will have
        //
        //      result == 2^{e-1} + 2^{e-2}.
        //
        // This ensures that
        //
        //      abs(sqrt(x) - result) <= 2^{e-2}.
        uint256 result = x;
        uint256 e = 1;
        if (x >= (1 << 128)) {
            result >>= 128;
            e = 129;
        }
        if (result >= (1 << 64)) {
            result >>= 64;
            e += 64;
        }
        if (result >= (1 << 32)) {
            result >>= 32;
            e += 32;
        }
        if (result >= (1 << 16)) {
            result >>= 16;
            e += 16;
        }
        if (result >= (1 << 8)) {
            result >>= 8;
            e += 8;
        }
        if (result >= (1 << 4)) {
            result >>= 4;
            e += 4;
        }
        if (result >= (1 << 2)) {
            e += 2;
        }
        result = (3 << (e/2)) >> 1;

        // Perform the 6 required Newton iterations
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;
        result = (result + x / result) >> 1;

        // We either have
        //
        //      Isqrt(x) == result      or      Isqrt(x) == result-1.
        if (result <= x/result) {
            return result;
        }
        return result-1;
    }
}
```

## Note on License

As noted, all **new** algorithms and all supporting code is licensed under
[BSD Zero Clause License](https://spdx.org/licenses/0BSD.html).
Additional algorithms and code are from other projects and
**have different licenses**.
