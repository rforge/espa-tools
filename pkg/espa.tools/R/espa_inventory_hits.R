#' espa_inventory_hits
#' 
#' R wrapper for USGS/EROS Inventory Service Scene Search Hits API.
#' 
#' This method is used in determining the number of hits a search returns. 
#' Because a hits request requires a search, this request takes the same 
#' parameters as the search request, with exception to the non-search-field 
#' parameters; maxResults, startingNumber, and sortOrder.
#' 
#' @param datasetName Character. Used as a filter with wildcards inserted at the beginning and the end of the supplied value.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.
#' @param lowerLeft List. When used in conjunction with upperRight, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param upperRight List. When used in conjunction with lowerLeft, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param startDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored. Default is "1920-01-01".
#' @param endDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored.Default is today's date.
#' @param months Numeric. Used to limit results to specific months.
#' @param includeUnknownCloudCover Logical. Used to determine if scenes with unknown cloud cover values should be included in the results. Default is TRUE.
#' @param minCloudCover Numeric. Used to limit results by minimum cloud cover (for supported datasets). Range 0 to 100. Default is 0.
#' @param maxCloudCover Numeric. Used to limit results by maximum cloud cover (for supported datasets). Range 0 to 100. Default is 100.
#' @param additionalCriteria List. Used to filter results based on dataset specific metadata fields. Use datasetFields request to determine available fields and options.
#' @param apiKey Character. Users API Key/Authentication Token, obtained from espa_inventory_login request.
#' @param node Character. Determines the dataset catalog to use. Default="EE", probably never needs to be changed.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return A list contains the results of the search.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#hits}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' # Standard search:
#' espa_inventory_hits(datasetName="GLS2005",
#' 		"lowerLeft"=list(latitude=75,longitude=-135),
#' 		"upperRight"=list(latitude=90,longitude=-120),
#' 		startDate="2006-01-01",endDate="2007-12-01",
#' 		node="EE",
#' 		apiKey=apiKey)
#' }
#' @export 

espa_inventory_hits <- function(datasetName,lowerLeft="",upperRight="",
		startDate="1920-01-07",endDate=Sys.Date(),months="",
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		apiKey,node="EE",verbose=F)
{
	hits_parameters <- list(datasetName=datasetName,lowerLeft=lowerLeft,upperRight=upperRight,
			startDate=startDate,endDate=endDate,months,
			includeUnknownCloudCover=includeUnknownCloudCover,minCloudCover=minCloudCover,maxCloudCover=maxCloudCover,
			additionalCriteria=additionalCriteria,
			apiKey=apiKey,node=node)
	
	hits <- espa_inventory_get_api(request_code="hits",json_request_content=hits_parameters,verbose=verbose)
	
	return(as.numeric(hits$data))
}


		