# Analysis of Integer Square Root Algorithms in Solidity

This project analyzes the gas cost of various methods of computing
integer square roots within Solidity.
A number of algorithms are from various projects
(with citations).
A couple of these algorithms are new and are provably correct.

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
are computed for the entire gas distributions for each algorithm.
From there, the individual minimum between all algorithms
are computed for each `uint256` value.
A number of plots are made and the results are tabulated.

All of the results are stored in `data/`.
During the analysis, the correctness of each computed value
(the value returned by the integer square root functions)
is confirmed.

The total time to run this analysis is approximately 2 minutes.

### Choice of Data Points

In order to compare the different algorithms,
specific `uint256` values must be tested.
The specific values were included:

 -  $2^{k}$, $2^{k}-1$, and $2^{k} + 1$ for integer values of $k$
 -  $v$, $v-1$, and $v+1$ for $v = (2^{128}-1)^{2}$
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
These are Tables 1 and 2 from the report.

|              | UniswapV2 | PRB | OpenZeppelin | ABDK | Python |
|  :---------  | --------: | --: | -----------: | ---: | -----: |
|   Max        |  34205    | 878 |    1021      |  881 |  963   |
|   Mean       |  17734    | 795 |     950      |  803 |  885   |
|   Median     |  17639    | 798 |     949      |  803 |  888   |
|   Std        |   9558    |  34 |      30      |   33 |   44   |

|              | Unrolled1 | Unrolled2 | Unrolled3 | While1 | While2 | While3 |
|  :---------  | --------: | --------: | --------: | -----: | -----: | -----: |
|   Max        |    858    |    851    |  **831**  |  1223  |  1167  |  1154  |
|   Mean       |    776    |    775    |  **749**  |   831  |   880  |   848  |
|   Median     |    779    |    777    |  **752**  |   875  |   909  |   878  |
|   Std        |     42    |     42    |   **41**  |   178  |   158  |   139  |

These results show how many times each algorithm was minimal.
Algorithms not included were never minimal.
This is Table 3 from the report.

|    Total        |    2048    |
| :-----------    |  -------:  |
|    UniswapV2    |       2    |
|    Python       |       5    |
|    Unrolled1    |       5    |
|    Unrolled2    |       5    |
|  **Unrolled3**  |  **1186**  |
|    While1       |     383    |
|    While2       |     189    |
|    While3       |     294    |

This is the most efficient algorithm (Unrolled3)
for computing integer square roots;
it is also provably correct.
See `report/` for more information.

```solidity
// SPDX-License-Identifier: 0BSD
function sqrt(uint256 x) internal pure returns (uint256) {
    unchecked {
        // Take care of easy edge cases
        if (x <= 1) {
            return x;
        }
        // This check ensures no overflow
        if (x >= ((1 << 128) - 1)**2) {
            return (1 << 128) - 1;
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
        uint256 xAux = x;
        uint256 result = 1;
        if (xAux >= (1 << 128)) {
            xAux >>= 128;
            result <<= 64;
        }
        if (xAux >= (1 << 64)) {
            xAux >>= 64;
            result <<= 32;
        }
        if (xAux >= (1 << 32)) {
            xAux >>= 32;
            result <<= 16;
        }
        if (xAux >= (1 << 16)) {
            xAux >>= 16;
            result <<= 8;
        }
        if (xAux >= (1 << 8)) {
            xAux >>= 8;
            result <<= 4;
        }
        if (xAux >= (1 << 4)) {
            xAux >>= 4;
            result <<= 2;
        }
        if (xAux >= (1 << 2)) {
            result <<= 1;
        }
        result += (result >> 1);

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
        if (result * result <= x) {
            return result;
        }
        return result-1;
    }
}
```

## Note on License

As noted, all **new** algorithms and all supporting code is licensed under
[BSD Zero Clause License](https://spdx.org/licenses/0BSD.html).
Additional code from other projects have been included for comparison
and **have different licenses**.

