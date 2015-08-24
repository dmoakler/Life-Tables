# Multiple Life Tables for different groups with one single function
This R script creates a function to compute multiple Period Life Tables of different social groups. The original Script was originally produced by EDDIE HUNSINGER.

The original function was adapted so we can apply it to a single data frame that contains Age-specific mortality rates of different social groups (countries, sex, year).
Output: the adapted function computes the Period Life Table of each group separately and bind all Life Tables into one big data frame, which makes it easier to plot and compare the mortality for the different groups.

