# This is an adaptation of EDDIE HUNSINGER's R script 
# so we can compute multiple Period Life Tables for 
# different groups with one single function

# Load packages
library(data.table)
library(ggplot2)


##############################################################################################################################
#STEP 1: Read in and review the population and death data
##############################################################################################################################

females<-read.table(file="http://www.demog.berkeley.edu/~eddieh/AppliedDemographyToolbox/StanfordCourseLifeTable/StanfordCourseMortalityData.csv",header=TRUE,sep=",")
females





##############################################################################################################################
# NEW STEP - Create hypotetical data
##############################################################################################################################

# Compute Mortality rates (nMx) within data table
females$nMx <- females$Death.Count/females$Population

#create Men data
temp <- females
temp$Gender <- "Male"
temp$nMx <- temp$nMx *2
data <- rbind(females,temp)

# create state data
data$uf <- "SP"
temp <- data
temp$uf <- "RJ" ; temp$nMx <- temp$nMx *1.3
data <- rbind(data,temp)
temp$uf <- "MG" ; temp$nMx <- temp$nMx *4
data <- rbind(data,temp)

# create year data
data$year <- 2008
temp <- data
temp$year <- 2010 ; temp$nMx <- temp$nMx *1.4
data <- rbind(data,temp)

# change variable name
setnames(data, "Gender", "sex")  




##############################################################################################################################
#STEP 2: Read in or create the fundamental pieces of the life table (age groupings, deaths by age, population by age ->death rates by age
##############################################################################################################################

# Age groups
x <- c(0,1,5,10,15,20,25,35,45,55,65,75,85)

# Mortality rates (nMx) are now computed within data table. See previous step.



##############################################################################################################################
#STEP 3: Read in the period life table function
##############################################################################################################################

life.table <- function( x, dataset, nMx){
  ## simple lifetable using Keyfitz and Flieger separation factors and 
  ## exponential tail of death distribution (to close out life table)
  tableid <- dataset$tableid # ******************** 
  uf <- dataset$uf # ******************** 
  sex <- dataset$sex # ********************
  year <- dataset$year # ********************
  b0 <- 0.07;   b1<- 1.7;      
  nmax <- length(x)
  #nMx = nDx/nKx   
  n <- c(diff(x),999)          		#width of the intervals
  nax <- n / 2;		            	# default to .5 of interval
  nax[1] <- b0 + b1 *nMx[1]    		# from Keyfitz & Flieger(1968)
  nax[2] <- 1.5  ;              
  nax[nmax] <- 1/nMx[nmax] 	  	# e_x at open age interval
  nqx <- (n*nMx) / (1 + (n-nax)*nMx)
  nqx<-ifelse( nqx > 1, 1, nqx);		# necessary for high nMx
  nqx[nmax] <- 1.0
  lx <- c(1,cumprod(1-nqx)) ;  		# survivorship lx
  lx <- lx[1:length(nMx)]
  ndx <- lx * nqx ;
  nLx <- n*lx - nax*ndx;       		# equivalent to n*l(x+n) + (n-nax)*ndx
  nLx[nmax] <- lx[nmax]*nax[nmax]
  Tx <- rev(cumsum(rev(nLx)))
  ex <- ifelse( lx[1:nmax] > 0, Tx/lx[1:nmax] , NA);
  lt <- data.frame(tableid=tableid,uf=uf,sex=sex,year=year,x=x,nax=nax,nmx=nMx,nqx=nqx,lx=lx,ndx=ndx,nLx=nLx,Tx=Tx,ex=ex)
  return(lt)
}

##############################################################################################################################
#STEP 4: Apply the function to the data, and review the created life table
##############################################################################################################################

# Create All life tables into a single data set
      groups <- unique(data$tableid)

      for (i in groups){
        print(i)
        y <- data[tableid==i,]
        if (i == groups[1]) {
          LIFETABLE <- life.table(x, y, y$nMx) }
        else # if it's not the 1st file, save it appending the rows to the previous file
        {
          temp <- life.table(x, y, y$nMx)
          LIFETABLE <- rbind(LIFETABLE, temp)
        }
      }


# Get the Life Table of only one group, for example:
  SPFemale2008 <- LIFETABLE[tableid =="SPFemale2008",]
  Men <- LIFETABLE[sex =="Male",]


##############################################################################################################################
#STEP 5: Visualize the data
##############################################################################################################################

# subset ggplot 
  # https://rpubs.com/kaz_yos/1330
  # http://stackoverflow.com/questions/18165578/subset-and-ggplot2

# Compare the mortality rate by Sex and State in 2010
ggplot(LIFETABLE, aes(x = x, y = nqx, color = factor(uf))) +
  geom_line(data = subset(LIFETABLE, year %in% 2010)) +
  facet_wrap(~sex)


# Compare the evolution of women mortality rate by State
ggplot(LIFETABLE, aes(x = x, y = nqx, color = factor(year))) +
  geom_line(data = subset(LIFETABLE, sex %in% "Female")) +
  facet_wrap(~uf)
  
# Compare the evolution of mortality rate by Sex and State
ggplot(LIFETABLE, aes(x = x, y = nqx, color = factor(year))) +
  geom_line() +
  facet_wrap(~sex+uf)
