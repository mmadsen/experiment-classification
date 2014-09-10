REGISTER 'lib/datafu-1.0.1-SNAPSHOT.jar';
DEFINE VAR datafu.pig.stats.VAR();


rmf output/grouped-average-postclassification

merged = load 'output/clean-numerics-postmergereduce.csv' using PigStorage(',') as (classification_id,classification_type,dimensionality,classification_coarseness,simulation_time,replication,sample_size,population_size,mutation_rate,simulation_run_id,class_richness,class_evenness_iqv,class_shannon_entropy,design_space_occupation,class_neutrality_slatkin,mean_trait_richness,mean_evenness_shannon_entropy,mean_evenness_iqv,mean_neutrality_slatkin);

-- Each simulation_run_id has a number of replicates, done internally in simuPOP, with the same basic parameters (mutation rate and population size)
-- In addition, we take multiple samples from each simulation replicate after it reaches stationarity.  
-- So simulation_run_id is a critical component of the key for grouping.  But we also project different sample sizes and dimensionality
-- from the original simulation runs by subsampling.  So the correct grouping key here is (simulation_run_id,classification_id,sample_size), 
-- where we aggregate over (replication,simulation_time) and all of the replications of a random mode classification.  

grouped = group merged by (simulation_run_id,classification_id,sample_size);

-- Given the grouping by (simulation_run_id,sample_size,dimensionality), we then aggregate the "observables" by averaging, and simply 
-- project the rest of the parameters.  

describe grouped;

averaged = foreach grouped {
	dist = distinct merged.(classification_id,simulation_run_id,dimensionality,sample_size,population_size,mutation_rate,classification_type,classification_coarseness);
	generate FLATTEN(dist), 
		COUNT_STAR(merged) as num_records_aggregated,
		AVG(merged.class_richness) as mean_class_richness,
		SQRT(VAR(merged.class_richness)) as sd_class_richness,
		AVG(merged.class_evenness_iqv) as mean_class_iqv, 
		SQRT(VAR(merged.class_evenness_iqv)) as sd_class_iqv,
		AVG(merged.class_shannon_entropy) as mean_class_entropy, 
		SQRT(VAR(merged.class_shannon_entropy)) as sd_class_entropy,
		AVG(merged.design_space_occupation) as mean_design_space_occupation,
		SQRT(VAR(merged.design_space_occupation)) as sd_design_space_occupation,
		AVG(merged.class_neutrality_slatkin) as mean_class_neutrality_slatkin,
		SQRT(VAR(merged.class_neutrality_slatkin)) as sd_class_neutrality_slatkin,
		AVG(merged.mean_trait_richness) as mean_trait_richness, 
		SQRT(VAR(merged.mean_trait_richness)) as sd_trait_richness,
		AVG(merged.mean_evenness_shannon_entropy) as mean_trait_entropy, 
		SQRT(VAR(merged.mean_evenness_shannon_entropy)) as sd_trait_entropy,
		AVG(merged.mean_evenness_iqv) as mean_trait_iqv,
		SQRT(VAR(merged.mean_evenness_iqv)) as sd_trait_iqv,
		AVG(merged.mean_neutrality_slatkin) as mean_trait_neutrality_slatkin,
		SQRT(VAR(merged.mean_neutrality_slatkin)) as sd_trait_neutrality_slatkin;
}

-- describe averaged;


-- classification_id,simulation_run_id,dimensionality,sample_size,population_size,mutation_rate,classification_type,classification_coarseness,num_records_aggregated,mean_class_richness,sd_class_richness,mean_class_iqv,sd_class_iqv,mean_class_entropy,sd_class_entropy,mean_design_space_occupation,sd_design_space_occupation,mean_class_neutrality_slatkin,sd_class_neutrality_slatkin,mean_trait_richness,sd_trait_richness,mean_trait_entropy,sd_trait_entropy,mean_trait_iqv,sd_trait_iqv,mean_trait_neutrality_slatkin,sd_trait_neutrality_slatkin



store averaged into 'output/grouped-average-postclassification' using PigStorage(',');