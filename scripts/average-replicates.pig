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

-- averaged = foreach grouped generate FLATTEN(merged.(simulation_run_id,dimensionality,sample_size,classification_type, classification_coarseness, population_size, mutation_rate)), AVG(class_richness), AVG(class_evenness_iqv), AVG(class_shannon_entropy), AVG(design_space_occupation), AVG(mean_trait_richness), AVG(mean_evenness_shannon_entropy), AVG(mean_evenness_iqv);

averaged = foreach grouped {
	dist = distinct merged.(classification_id,simulation_run_id,dimensionality,sample_size,population_size,mutation_rate,classification_type, classification_coarseness);
	generate FLATTEN(dist), AVG(merged.class_richness) as class_richness, AVG(merged.class_evenness_iqv) as class_iqv, 
		AVG(merged.class_shannon_entropy) as class_entropy, AVG(merged.design_space_occupation) as design_space_occupation, AVG(merged.class_neutrality_slatkin) as class_neutrality_slatkin,
		AVG(merged.mean_trait_richness) as trait_richness, AVG(merged.mean_evenness_shannon_entropy) as trait_entropy, AVG(merged.mean_evenness_iqv) as trait_iqv,
		AVG(merged.mean_neutrality_slatkin) as mean_neutrality_slatkin;
}

describe averaged;


-- Final column order:  
-- classification_id,simulation_run_id,dimensionality,sample_size,population_size,mutation_rate,classification_type, classification_coarseness, num_records_aggregated, class_richness, class_iqv, class_entropy, design_space_occupation, trait_richness, trait_entropy, trait_iqv

store averaged into 'output/grouped-average-postclassification' using PigStorage(',');

