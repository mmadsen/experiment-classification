#!/bin/sh

pig -x local scripts/merge-postclassification-exports.pig

sh scripts/merge-partfiles.sh merged-postclassification-records

pig -x local scripts/remove-duplicate-columns-postmerge.pig

sh scripts/merge-partfiles.sh merged-reduced-postclassification-records

pig -x local scripts/average-replicates.pig

cp output/grouped-average-postclassification/part-r-00000 output/grouped-average-postclassification.csv

echo "output/grouped-average-postclassification.csv is the final output dataset, without header row"