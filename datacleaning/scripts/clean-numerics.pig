REGISTER 'lib/udf-numerics-madsenlab.jar';
DEFINE convertDouble org.madsenlab.data.DoubleConverter();

rmf output/clean-numerics-postmergereduce

merged = load 'output/merged-reduced-postclassification-records.csv' using PigStorage(',') as (classification_id,classification_type,dimensionality,classification_coarseness:int,simulation_time,replication,sample_size,population_size,mutation_rate:double,simulation_run_id,class_richness:int,class_evenness_iqv:double,class_shannon_entropy:double,design_space_occupation:double,class_neutrality_slatkin:double,mean_trait_richness:double,mean_evenness_shannon_entropy:double,mean_evenness_iqv:double,mean_neutrality_slatkin:double);

cleaned = foreach merged generate classification_id,classification_type,dimensionality,classification_coarseness,simulation_time,replication,sample_size,population_size,convertDouble(mutation_rate),simulation_run_id,class_richness,convertDouble(class_evenness_iqv),convertDouble(class_shannon_entropy),convertDouble(design_space_occupation),convertDouble(class_neutrality_slatkin),convertDouble(mean_trait_richness),convertDouble(mean_evenness_shannon_entropy),convertDouble(mean_evenness_iqv),convertDouble(mean_neutrality_slatkin);

store cleaned into 'output/clean-numerics-postmergereduce' using PigStorage(',');

