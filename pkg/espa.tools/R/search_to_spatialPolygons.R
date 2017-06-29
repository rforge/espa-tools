#' search_to_spatialPolygons
#' 
#' Converts espa inventory search results to a SpatialPolygonsDataFrame
#' 
#' @param espa_inventory_search_results List. The outputs of espa_inventory_search
#' @return Character of the API KEY needed by the other inventory APIs.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net})
#' @seealso \code{\link{espa_inventory_search}}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' 
#' # Standard search:
#' search_results <- espa_inventory_search(datasetName="GLS2005",
#' 		"lowerLeft"=list(latitude=75,longitude=-135),
#' 		"upperRight"=list(latitude=90,longitude=-120),
#' 		startDate="2006-01-01",endDate="2007-12-01",
#' 		node="EE",
#' 		maxResults=3,startingNumber=1,sortOrder="ASC",
#' 		apiKey=apiKey)
#' 
#' plot(search_to_spatialPolygons(espa_inventory_search_results=search_results))
#' }
#' @import foreach sp
#' @export 

search_to_spatialPolygons <- function(espa_inventory_search_results)
{
	# For pass check:
	i=NULL
	
	if(espa_inventory_search_results$data$numberReturned > 0)
	{
		
		search_to_spatialPolygons_list <- foreach(i=seq(espa_inventory_search_results$data$numberReturned)) %do%
				{
					# Updated for 1.4.0
					sceneBounds <- as.numeric(unlist(strsplit(espa_inventory_search_results$data$results[[i]]$sceneBounds,split=",")))
					
					# http://gis.stackexchange.com/questions/206929/r-create-a-boundingbox-convert-to-polygon-class-and-plot
					coords <- matrix(c(
									c(sceneBounds[1],sceneBounds[4]),
									c(sceneBounds[1],sceneBounds[2]),
									c(sceneBounds[3],sceneBounds[2]),
									c(sceneBounds[3],sceneBounds[4])
							),ncol=2,byrow=TRUE)
					P1 <- Polygon(coords)
					Ps1 <- Polygons(list(P1),ID=i) 
					return(Ps1)
				}
		search_to_spatialPolygons_entities <- as.data.frame(foreach(i=seq(espa_inventory_search_results$data$numberReturned),.combine=rbind) %do%
						{
							# http://gis.stackexchange.com/questions/206929/r-create-a-boundingbox-convert-to-polygon-class-and-plot
							return(espa_inventory_search_results$data$results[[i]]$entityId)
						})
		
		
		search_to_spatialPolygons_sp = SpatialPolygons(search_to_spatialPolygons_list, proj4string=CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0 "))
		search_to_spatialPolygons_spdf = SpatialPolygonsDataFrame(search_to_spatialPolygons_sp,search_to_spatialPolygons_entities,match.ID=F)
		
		
	} else
	{		
		search_to_spatialPolygons_spdf = NULL
	}	
	return(search_to_spatialPolygons_spdf)
	
}