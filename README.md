experiment-classification
=========================

Experiment:  Observing cultural transmission models through archaeological classifications

## Dependencies ##

Requires custom written user-defined functions for Apache Pig, accessible at [pig-udf-numerics](https://github.com/mmadsen/pig-udf-numerics).

Requires UDF's from the LinkedIn `DataFu` library, accessible at [DataFu](http://data.linkedin.com/opensource/datafu).  

Jar files for both as used in this analysis are also located in the `lib/` subdirectory.  


## Raw Data Note ##

The raw data files created by simulation for this experiment occupy more than 1.5 GB, and thus have NOT been checked into github.  The section on "Replicating the Experiment" below 
covers how to create them.  Given a specific request or need, the author is also happy to 
make the exact files available (by FTP or SSH to your selected storage server).  Please contact me at mark@madsenlab.org if you really need this.  Replicating the experiment will serve most of the same needs, but given random number generation and a stochastic process, your replicated data will NOT be the exact same samples that I am analyzing here.  They should result, however, in variables whose distribution match those given here.  Or so the Central Limit Theorem claims.... :)

## Data for Analysis ##

If you do not need to replicate the experiment, or see the intermediate data files, the results of running every step in the section "Replicating the Experiment" live in:

`data/classification-experiment-neutral-dataset-fullrows.csv`

and 

`data/classification-experiment-neutral-dataset-grouped.csv`

and associated `.rda` files for the R binary representation.

__NOTE__:  Unfortunately, the file sizes exceed Github's maximum allowable file size, so they're not present in this repository.  I'll be archiving them at Figshare, instead, and providing links.  So you'd download them from Figshare, copy them to the `data/` directory, and then proceed with the analysis.  Sorry, that's the only way this works right now.  

These data were used in the preparation of my dissertation and associated publications.  


## Replicating the Experiment ##

### Required Software ###

You need a couple of pieces of software to replicate this experiment and analysis:

1.  Python 2.7 (I used the Enthought distribution, the default CPython, and Anaconda distributions at various stages and got identical results, of course).
1.  MongoDB 2.4 -- a simple "localhost" installation is sufficient.  I used a single instance and single shard for all of the data in this experiment.  All of the scripts take hostname/port parameters, though, if your database is located on a host different than your simulations or analyses.  
1.  simuPOP 1.1.1 (http://simupop.sourceforge.net/).  
1.  CTPy version 1.0.3 (https://github.com/mmadsen/CTPy/releases/tag/v1.0.3)
1.  All of the Python modules listed in "required-modules.txt".  All are available via "pip" or "easy_install" (or the Enthought package manager)

All of these items should be installed on your system.  You should be able to connect to MongDB via the command line client "mongo".  The MongoDB database directory needs to be located on a drive or partition that contains at least 100GB of free space for the configured parameter space.  Adding more parameters will require correspondingly greater disk space.  

### Running the Experiment ###

Database tables (collections) are prefixed by an "experiment name" in CTPy simulations, and there is a data document for each experiment which tracks processing stages (ensuring that the same operation isn't run twice, thus potentially corrupting your data).  

The `run-experiment-sequence.sh` takes 2 parameters `<experiment name>` and `<configuration file>`.  The values you should use are:

1.  "classification"
2.  "conf/classification-diss.json"

Thus, from the ctpy directory, and with a clean MongoDB instance (i.e., no collections starting with "classification_"), execute the script:

`sh run-experiment-sequence.sh classification conf/classification-diss.json`

There will be periodic output to STDOUT, and you should see three collections appear immediately in MongoDB:

1.  classification_samples_raw
1.  ctpy_registry
1.  classification_configuration

At some point in the process flow (which will take awhile, even on a fast machine), another collection will appear:

1.  classification_samples_postclassification

At the end of the script run, you should be ready to export the dataset to CSV files for further processing.  Execute the following in the ctpy directory:

`admin/export_data_to_csv.py --experiment classification`

This will leave two files in this directory:

1.  data_pergeneration_stats_traits.csv
1.  data_pergeneration_stats_postclassification.csv

The former will be about 16 MB in size, the latter will be 1.5GB.  These are the data files which are **NOT** included in this Github repository.  The line count on the former should be 144,000, and the line count on the latter 9,504,000.  

If these values are incorrect, something has gone wrong.  Do not continue analysis.  The exact samples will vary from run to run, but this configuration file and simulation parameters MUST generate this specific number of rows of data in these two files.  Contact the author if they do not.  


### Preparing Data For Analysis ###

The two data files must be merged, duplicate columns removed, and then replicates aggregated by calculating the mean for each observable statistic across all of the 100 replicates for each simulation parameter set, sample size level, and classification.  This will reduce 9,504,000 data samples to 95,040 rows.  

To run this post-processing chain, copy the two CSV files from the ctpy directory where the simulation occurred to the `rawdata` directory in this repository.  

Then run the analysis chain script:

`sh scripts/run-all-steps.sh`

This will generate a LOT of console output -- Apache Pig is running the show, and shows you a ton of Hadoop job creation and execution output.  There should periodically be a "SUCCESS" indicator as each of the Pig scripts completes.  The pauses in between Pig output is the shell script which merges each of the partial outputfiles into a single intermediate data file which will be used as input to the next script.  

At the end of the processing chain, the script will indicate the filename of the "completed" dataset.  This file will not have any header with column names.  In the `rawdata` directory, the file `averaged-columns.txt` file contains the header row.  This is usefully prepended prior to import to R, but is kept separate depending upon the next step in analysis....

This final dataset file will be named after the final processing step:

`output/grouped-average-postclassification.csv`

This file can be copied to the `data` directory for further analysis, where it has been renamed for obvious identification during analysis:

`data/classification-experiment-neutral-dataset.csv`

