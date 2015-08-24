# This is an adaptation of EDDIE HUNSINGER's R script 
# so we can compute multiple Period Life Tables for 
# different groups with one single function



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

life.table <- function( x, nMx){
  ## simple lifetable using Keyfitz and Flieger separation factors and 
  ## exponential tail of death distribution (to close out life table)
  uf <- data$uf # ******************** 
  sex <- data$sex # ********************
  year <- data$year # ********************
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
  lt <- data.frame(uf=uf,sex=sex,year=year,x=x,nax=nax,nmx=nMx,nqx=nqx,lx=lx,ndx=ndx,nLx=nLx,Tx=Tx,ex=ex)
  return(lt)
}

##############################################################################################################################
#STEP 4: Apply the function to the data, and review the created life table
##############################################################################################################################

# Create All life tables into a single data set
LIFETABLE <- life.table(x, data$nMx)
LIFETABLE




##############################################################################################################################
#STEP 5: Visualize the data
##############################################################################################################################

ggplot() + geom_line(data = LIFETABLE, aes(x=x, y=nqx, colour = factor(sex))) +
  facet_wrap(~uf)


ggplot() + geom_line(data = LIFETABLE, aes(x=x, y=nqx, colour = factor(year))) +
  facet_wrap(~sex+uf)

