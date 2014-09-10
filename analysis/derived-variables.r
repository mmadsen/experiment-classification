# Derived variables
# Experiment:  Classification
# Mark E. Madsen
# (c) 2013 - see file LICENSE for license terms


# calculate theta as a number, and as a factor
# assume haploid so 2Nmu, not 4Nmu
class.grouped$theta <- class.grouped$population_size * class.grouped$mutation_rate * 2.0
class.grouped$theta_factor <- factor(class.grouped$theta)

# Total number of classes is the coarseness for each dimension multiplied
class.grouped$total_num_classes <- as.numeric(class.grouped$classification_coarseness) ^ as.numeric(class.grouped$dimensionality)
class.grouped$total_classes_factor <- factor(class.grouped$total_num_classes)

grouped.theta_subset <- subset(class.grouped, class.grouped$theta_factor == c("0.2", "1", "10"))


