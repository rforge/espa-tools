

##### ESPA Tools for R Tutorial #####

### STEP 1: INSTALL ESPA TOOLS:
# Install dependencies:
install.packages("foreach")
install.packages("httr")
install.packages("jsonlite")
install.packages("parallel")
install.packages("rgdal")
install.packages("rgeos")
install.packages("sp")
install.packages("xml2")

# Install espa-tools from R-forge:
# Try this first:
install.packages("espa.tools", repos="http://R-Forge.R-project.org")

# If that doesn't work:
install.packages("devtools")
library("devtools")
# Install Tortoise SVN if on Windows:
# https://tortoisesvn.net/downloads.html
# Then:
install_svn("svn://r-forge.r-project.org/svnroot/espa-tools/pkg/espa.tools")


### STEP 2: REGISTER WITH EARTHEXPLORER, USE A NON-IMPORTANT PASSWORD:
# https://earthexplorer.usgs.gov/


### STEP 3: CHECK OUT WHAT DATASETS YOU CAN ORDER:
library("espa.tools")
apiKey=espa_inventory_login(usgs_eros_username="myusername",usgs_eros_password="mypassword")
available_datasets <- espa_inventory_datasets(apiKey=apiKey)
available_datasetNames <- sapply(available_datasets$data,function(x) return(x$datasetName))
available_datasetNames

### STEP 4: DO AN INITIAL SEARCH BUT DON'T ORDER YET.
library("espa.tools")
library("foreach")

# SOME INITIAL PARAMETERS:

# We'll search Landsat 4 TM, 5 TM, 7 ETM+, and 8 OLI:
mydatasetName="LANDSAT_4578" 
# Note this is a special "collection" that won't appear in the available_datasetNames, 
# it will search multiple dataSets: LANDSAT_4578=c("LANDSAT_TM_C1","LANDSAT_ETM_C1","LANDSAT_8_C1" )

# And, specifically, the "Surface Reflectance" product and Geotiff format:
myproducts="sr"
myformat="gtiff"

# Nevada bounding box:
mylowerLeft = list(latitude=35.0023,longitude=-120.0058)
myupperRight = list(latitude=42.0018,longitude=-114.0394)

# We'll search from 1990 to present:
mystartDate="1990-01-01"
myendDate=as.character(Sys.Date()) # Today's date!  Needs to be in character format...

# And only July and August:
mymonths=c(7,8) 

# Now do the initial search, we'll let it be "verbose" so you can see all the calls...
# This will take a bit if the search returns a lot...

search_results <- earthexplorer_search(
		usgs_eros_username="myusername",usgs_eros_password="mypassword",
		datasetName=mydatasetName,
		lowerLeft=mylowerLeft,upperRight=myupperRight,
		startDate=mystartDate,endDate=myendDate,months=mymonths,
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		sp=NULL,
		place_order=F,
		products=myproducts,
		format=myformat,
		verbose=T)

# Let's see how many images this is:
# First, what does the output look like:
names(search_results) 

# It's a list, organized by datasetName
names(search_results$LANDSAT_8_C1) 

# Note that there are various outputs from the search, but "data" is what we are interested in...
names(search_results$LANDSAT_8_C1$data) 

# Great, we can quickly query the original number of hits for Landsat 8:
length(search_results$LANDSAT_8_C1$data$results)

# We can check out what dates they were acquired:
search_to_Dates(search_results$LANDSAT_8_C1)

# And confirm the locations:
library(sp)
plot(search_to_spatialPolygons(search_results$LANDSAT_8_C1))

### STEP 5: LET'S REFINE OUR SEARCH AND PUT IN AN ORDER:

