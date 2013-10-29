#!/bin/sh



# Take the raw data as exported by CTPy's export_data_to_csv.py script, and snip off the column headers.  
echo "Cutting off headers from raw exports: postclassification"
tail -n +2 rawdata/data_pergeneration_stats_postclassification.csv > rawdata/data_pergeneration_stats_postclassification_noheader.csv
echo "Cutting off headers from raw exports: traits"
tail -n +2 rawdata/data_pergeneration_stats_traits.csv > rawdata/data_pergeneration_stats_traits_noheader.csv


# run the processing scripts in sequence 

pig -x local scripts/merge-postclassification-exports.pig

sh scripts/merge-partfiles.sh merged-postclassification-records

pig -x local scripts/remove-duplicate-columns-postmerge.pig

sh scripts/merge-partfiles.sh merged-reduced-postclassification-records

# we need the files to be clean of scientific notation and only have clean floating point representations

pig -x local scripts/clean-numerics.pig

sh scripts/merge-partfiles.sh clean-numerics-postmergereduce

pig -x local scripts/average-replicates.pig

cp output/grouped-average-postclassification/part-r-00000 output/grouped-average-postclassification.csv

echo "output/grouped-average-postclassification.csv is the final output dataset, without header row"
