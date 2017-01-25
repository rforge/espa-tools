library(espa.tools)

earthexplorer_search(usgs_eros_username="jgrn307",usgs_eros_password=usgs_eros_password,
		datasetName="GLS2005",
		lowerLeft=list(latitude=75,longitude=-135),upperRight=list(latitude=90,longitude=-120),
		startDate="2006-01-01",endDate="2007-12-01",
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,place_order=F,verbose=T)