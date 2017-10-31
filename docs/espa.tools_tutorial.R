##### ESPA Tools for R Tutorial #####
# Jonathan Greenberg
# jgreenberg@unr.edu
# Last updated 20 September 2017


### STEP 1: INSTALL ESPA TOOLS:
# Install dependencies:
install.packages("foreach")
install.packages("httr")
install.packages("jsonlite")
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
apiKey=espa_inventory_login(usgs_eros_username="jgrn307",usgs_eros_password="password307")
available_datasets <- espa_inventory_datasets(apiKey=apiKey)
available_datasetNames <- sapply(available_datasets$data,function(x) return(x$datasetName))
sort(available_datasetNames)

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
mystartDate="2010-01-01"
myendDate=as.character(Sys.Date()) # Today's date!  Needs to be in character format...

# And only July and August:
mymonths=c(7,8) 

# Now do the initial search, we'll let it be "verbose" so you can see all the calls...
# This will take a bit if the search returns a lot...

search_results <- earthexplorer_search(
		usgs_eros_username="jgrn307",usgs_eros_password="password307",
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
library("espa.tools")
library("foreach")
library("jsonlite")

# SOME INITIAL PARAMETERS:

# We'll search Landsat 4 TM, 5 TM, 7 ETM+, and 8 OLI:
mydatasetName="LANDSAT_4578" 
# Note this is a special "collection" that won't appear in the available_datasetNames, 
# it will search multiple dataSets: LANDSAT_4578=c("LANDSAT_TM_C1","LANDSAT_ETM_C1","LANDSAT_8_C1" )

# And, specifically, the "Surface Reflectance" product and Geotiff format:
myproducts="sr"
myformat="gtiff"

# Lake Tahoe Basin bounding box:
mylowerLeft = list(latitude=38.625,longitude=-120.25)
myupperRight = list(latitude=39.375,longitude=-119.86)

# We'll search from 2015 to present:
mystartDate="1990-01-01"
myendDate=as.character(Sys.Date()) # Today's date!  Needs to be in character format...

# And only July:
mymonths=c(7) 

# Let's just make sure this works before we order:

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
		verbose=F)

# Let's see how many results we get:
length(search_results$LANDSAT_8_C1$data$results)
length(search_results$LANDSAT_ETM_C1$data$results) 
length(search_results$LANDSAT_TM_C1$data$results) # Landsat 5 TM stopped in November 2011

# The Lake Tahoe Basin falls in a few Landsat "path/rows":
plot(search_to_spatialPolygons(search_results$LANDSAT_8_C1))

# Ok, let's only do Landsat 8, and put in an order!
mydatasetName="LANDSAT_8_C1" 

search_results <- earthexplorer_search(
		usgs_eros_username="myusername",usgs_eros_password="mypassword",
		datasetName=mydatasetName,
		lowerLeft=mylowerLeft,upperRight=myupperRight,
		startDate=mystartDate,endDate=myendDate,months=mymonths,
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		sp=NULL,
		place_order=T, # Change this to "T"
		products=myproducts,
		format=myformat,
		verbose=T)

# We can check the order at this website:
# https://espa.cr.usgs.gov -> login, then "Show Orders" (it may take a few minutes to show up)

### STEP 6: DOWNLOAD THE DATA.
library("espa.tools")
library("foreach")
library("jsonlite")
library("xml2")

# It can take hours to weeks to prepare the Landsat order.  You will get an email, but can also check online for the status:
# https://espa.cr.usgs.gov -> login, then "Show Orders" (it may take a few minutes to show up)
# Let's get a list of the orders we put in:

my_orders <- espa_ordering_listorders(usgs_eros_username="myusername",usgs_eros_password="mypassword",ordernums_only=T)
# On the website, you can see the order number as well.  Trick: the orders are sorted most recent to last, so we can choose:
my_latest_order <- my_orders[1]

# We'll use a slightly older one:
my_latest_order <- my_orders[2] 


# Let's setup an output folder to save to:
# Note with Windows, use double backslashes everywhere.
output_folder = "R:\\SCRATCH\\jgreenberg\\landsat_tahoe"

earthexplorer_download(usgs_eros_username="myusername",usgs_eros_password="mypassword",
 	output_folder=output_folder,
 	ordernum=my_latest_order)

# Once it says "NULL" that means it is done downloading everything!  Check your output folder!
