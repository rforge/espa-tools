# 

library(gdalUtils)
gdalinfo(version=T)
library("devtools")
library("espa.tools")
library("foreach")
library("rgdal")
library("rgeos")
apiKey=espa_inventory_login(usgs_eros_username="username",usgs_eros_password="password")
mydatasetName="LANDSAT_4578" 
myproducts="sr"
myformat="gtiff"
myShapeInR<-readOGR("/Users/jgrn307/Downloads/SMRRP\ Degraded\ Meadows_Merged")
mystartDate="2016-05-01"
myendDate="2016-09-01"
mymonths=c(6,7)

usgs_eros_username="myusername"
usgs_eros_password="mypassword"

search_results <- earthexplorer_search(
		usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
		datasetName=mydatasetName,
		lowerLeft=NULL,upperRight=NULL,
		startDate=mystartDate,endDate=myendDate,months=mymonths,
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		sp=myShapeInR,
		place_order=F,
		products=myproducts,
		format=myformat,
		verbose=T)
