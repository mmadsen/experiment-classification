# Exploratory data analysis for grouped classification data
# Experiment:  Classification
# Mark E. Madsen
# (c) 2013 - see file LICENSE for license terms

library(ggplot2)

qplot(theta, mean_class_richness, data=class.grouped, facets = classification_type ~ classification_coarseness, geom=c("point", "smooth"))

# select three theta levels, since there are so many above 1.0.  
grouped.theta_subset <- subset(class.grouped, class.grouped$theta_factor == c("0.2", "1", "10"))

qplot(total_num_classes, mean_class_richness, data=grouped.theta_subset, facets = theta_factor ~ ., geom=c("point"))