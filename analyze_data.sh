#!/bin/bash

GENERATE_DATA=scripts/data_points.py
DATA_FILE=data_points.csv
CSV_TMP=csv_output.csv
SUMMARY_FILE=data/summary_stats.py
ANALYSIS_FILE=data/analysis.py
TEST_FILE=scripts/gas_metrics.ts
TEST_FILE_TMP=scripts/gas_metrics.ts.tmp
DATA_DIR=data
SED_FILE=scripts/standard.sed

STD_BOOL=true

# Determine what type of analysis is to be run
if [[ "$#" -eq 0 ]]; then
    echo "Standard analysis"
    echo

elif [[ "$#" -eq 1 ]]; then
    # One argument; extended analysis
    # Check type:
    #       q for quick standard
    #       d for deterministic
    #       r for random
    #       o for other

    case "${1}" in
        -q) # Quick standard analysis (no UniswapV2); update file
            echo "Quick Standard analysis (no UniswapV2)"
            echo
            SED_FILE=scripts/standard_quick.sed
            ;;

        -d) # Deterministic analysis; update files
            echo "Extended Deterministic analysis"
            echo
            GENERATE_DATA=scripts/data_points_det.py
            DATA_FILE=data_points_det.csv
            SED_FILE=scripts/extended_det.sed

            # Ensure data directory exists; if not, make directory
            DATA_DIR=data/extended_det
            if [ ! -d "$DATA_DIR" ]; then
                mkdir $DATA_DIR
            fi
            ;;

        -r) # Random analysis; update files
            echo "Extended Random analysis"
            echo
            GENERATE_DATA=scripts/data_points_rnd.py
            DATA_FILE=data_points_rnd.csv
            SED_FILE=scripts/extended_rnd.sed

            # Ensure data directory exists; if not, make directory
            DATA_DIR=data/extended_rnd
            if [ ! -d "$DATA_DIR" ]; then
                mkdir $DATA_DIR
            fi
            ;;

        -o) # Quick standard analysis (no UniswapV2); update file
            echo "Standard analysis (on non-Newton algorithms)"
            echo
            SED_FILE=scripts/standard_quick.sed
            STD_BOOL=false
            ;;

        --deployment) # compute the size of the bytecode for the standard algs
            echo "Deployment gas costs for Standard Algorithms;"
            echo "Absolute Gas Cost"
            echo "Relative Gas Cost (Absolute - Empty)"
            echo
            TMP_FILE=tmp.txt
            npx hardhat sqrt-gas-tests-deployment > $TMP_FILE
            cat $TMP_FILE
            rm $TMP_FILE
            exit 0
            ;;

        --init) # run initialization tests
            echo "Gas cost tests for initialization"
            echo
            npx hardhat init-test
            exit 0
            ;;

        --newton-iter) # run unrolled Newton iteration tests
            echo "Gas cost for unrolled Newton iterations"
            echo
            npx hardhat newton-iter-test
            exit 0
            ;;

        --while-iter) # run while-loop Newton iteration tests
            echo "Gas cost for Newton iterations in while loop"
            echo
            npx hardhat while-iter-test
            exit 0
            ;;

        --halley-iter) # run unrolled Halley iteration tests
            echo "Gas cost for unrolled Halley iterations"
            echo
            npx hardhat halley-iter-test
            exit 0
            ;;

        --binary-iter) # run Binary Search iteration tests
            echo "Gas cost for binary search iterations"
            echo
            npx hardhat binary-search-iter-test
            exit 0
            ;;

        --interp-iter) # run Interpolation Search iteration tests
            echo "Gas cost for interpolation search iterations"
            echo
            npx hardhat interp-search-iter-test
            exit 0
            ;;

        --halley) # run unrolled Halley test
            echo "Gas cost for Halley's method"
            echo
            npx hardhat halley-test
            exit 0
            ;;

        *)  echo "invalid argument; exiting"
            exit 1
            ;;
    esac

else
    # Two or more arguments; invalid
    echo "Two or more arguments; invalid; exiting"
    exit 2
fi

# Update typescript test file
if [[ "$STD_BOOL" = true ]]; then
    sed -f $SED_FILE $TEST_FILE > $TEST_FILE_TMP
    mv $TEST_FILE_TMP $TEST_FILE
fi

# Generate data points
$GENERATE_DATA
mv $DATA_FILE scripts/

# Run analysis
if [[ "$STD_BOOL" = true ]]; then
    npx hardhat sqrt-gas-tests-std > $CSV_TMP
else
    npx hardhat sqrt-gas-tests-other > $CSV_TMP
fi

# Split tmp file into separate ones
csplit \
    --quiet \
    --prefix=tmp \
    --suffix-format=_%02d.csv \
    --suppress-matched \
    $CSV_TMP /^$/ {*}

# Remove tmp data file
rm $CSV_TMP

# Loop through data files
for tmp in tmp_*.csv; do
    if [ ! -s $tmp ]; then
        # Remove empty file
        rm $tmp
        continue
    fi
    # Need to get first line of file for renaming
    fname=`head -n 1 $tmp`
    CSV=output_${fname}.csv
    mv $tmp $CSV
    echo $fname

    # compute summary statistics and make plot
    $SUMMARY_FILE $CSV
    DATA_CSV=stats_${fname}.csv
    DATA_PLOT=plot_${fname}.pdf

    # save copy of plot in report
    #cp $DATA_PLOT report/plots/

    # move files to correct location
    mv $CSV $DATA_DIR
    mv $DATA_CSV $DATA_DIR
    mv $DATA_PLOT $DATA_DIR
    echo
done

# Compute detailed analysis of minimal gas
$ANALYSIS_FILE $DATA_DIR/output_*.csv

# move files
#cp minimal_plot_*.pdf report/plots/
mv minimal_plot_*.pdf $DATA_DIR
mv minimal_hist_*.pdf $DATA_DIR
mv minimal_values_*.csv $DATA_DIR
mv minimal_summary.csv $DATA_DIR

exit 0