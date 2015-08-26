# Life-Tables
This R script computes a Period Life Table. The Script was originally produced by EDDIE HUNSINGER. 

In this 'Multiple-Life-Tables' branch of this project, I have adapted EDDIE HUNSINGER's code so I  can apply it to a single data frame that contains Age-specific mortality rates of different population subgroups groups (states, sex, year) and compute separte life tables for each group. Output: the adapted function computes the Period Life Table of each group separately and bind all Life Tables into one big data frame, which makes it easier to plot and compare the mortality patterns of the different groups.

---------------
R CODE FOR A PERIOD LIFE TABLE, REPRODUCED FROM ONLINE MATERIALS FOR THE 2006 FORMAL DEMOGRAPHY WORKSHOP AT STANFORD UNIVERSITY
THE ORIGINAL POSTING OF THIS CODE IS AVAILABLE [here](http://www.stanford.edu/group/heeh/cgi-bin/web/node/75) or [here] (http://www.demog.berkeley.edu/~eddieh/AppliedDemographyToolbox/StanfordCourseLifeTable/StanfordCourseLifeTableCode.txt).

NOTE: I (EDDIE HUNSINGER) REPRODUCED THE CODE HERE TO PROVIDE AN IMMEDIATE LINK TO INPUT DATA FOR QUICK REVIEW BY POTENTIAL USERS
FEBRUARY 2011 (LAST UPDATED FEBRUARY 12, 2011)
edynivn@gmail.com

IF YOU WOULD LIKE TO USE, SHARE OR REPRODUCE THIS CODE, BE SURE TO CITE THE SOURCE

EXAMPLE DATA IS LINKED, SO YOU SHOULD BE ABLE TO SIMPLY COPY ALL AND PASTE INTO R

THERE IS NO WARRANTY FOR THIS CODE

