-- Set directory where Pig is allowed to install software 

rmf output/merged-postclassification-records

-- Load both files
classified = load 'rawdata/data_pergeneration_stats_postclassification_noheader.csv' using PigStorage(',') as (classification_id,classification_type,dimensionality,classification_coarseness,simulation_time,replication,sample_size,population_size,mutation_rate,simulation_run_id,class_richness,class_evenness_iqv,class_shannon_entropy,design_space_occupation);
traitsonly = load 'rawdata/data_pergeneration_stats_traits_noheader.csv' using PigStorage(',') as (simulation_run_id,simulation_time,replication,sample_size,population_size,mutation_rate,dimensionality,mean_trait_richness,mean_evenness_shannon_entropy,mean_evenness_iqv);

-- do the join as a fragment-replicate join, using traits almost like a lookup table, to add its values to the larger data set
-- the simulation_run_id implies a specific mutation rate and population size, so we don't have to repeat those as keys
-- but sample size and dimensionality are modified by subsampling after the fact, so we need them as keys
-- and replication and simulation_time are independent and necessary to link up identical points in the simulation data

joined = join classified by (dimensionality,simulation_time,replication,sample_size,simulation_run_id), traitsonly by (dimensionality,simulation_time,replication,sample_size,simulation_run_id) using 'replicated';

-- store the result
-- if running on EMR or hadoop fs, merge to single file after with:  hadoop fs -getmerge <dir_of_input_files> <mergedsinglefile>

store joined into 'output/merged-postclassification-records' using PigStorage(',');
