#' search_to_Dates
#' 
#' Converts espa inventory search results to a data.frame that includes Dates
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
#' plot(search_to_Dates(espa_inventory_search_results=search_results))
#' }
#' @import foreach
#' @export 

search_to_Dates <- function(espa_inventory_search_results)
{
	# For pass check:
	i=NULL
	
	if(espa_inventory_search_results$data$numberReturned > 0)
	{
		
		search_to_Dates_data.frame <- as.data.frame(foreach(i=seq(length(espa_inventory_search_results$data$results)),.combine=rbind) %do%
						{
							# print(i)
							entityId=espa_inventory_search_results$data$results[[i]]$entityId
							acquisitionDate=espa_inventory_search_results$data$results[[i]]$acquisitionDate
							if(!is.null(acquisitionDate))
							{
							month=as.numeric(format(as.Date(acquisitionDate),"%m"))
							return(c(entityId,acquisitionDate,month))
							} else
								return(NULL)
						#	return(c(espa_inventory_search_results$data$results[[i]]$entityId,espa_inventory_search_results$data$results[[i]]$acquisitionDate))
						})
		names(search_to_Dates_data.frame) <- c("entityId","acquisitionDate","acquisitionMonth")
#		browser()
		return(search_to_Dates_data.frame)
		
	}
}