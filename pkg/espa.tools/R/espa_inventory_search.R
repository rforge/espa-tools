#' espa_inventory_search
#' 
#' R wrapper for USGS/EROS Inventory Service Scene Search API.
#' Note: earthexplorer_search is much easier to use, and is recommended.
#' 
#' Searching is done with limited search criteria. All coordinates 
#' are assumed decimal-degree format. If lowerLeft or upperRight 
#' are supplied, then both must exist in the request to complete 
#' the bounding box. Starting and ending dates, if supplied, are 
#' used as a range to search data based on acquisition dates. The 
#' current implementation will only search at the date level, 
#' discarding any time information. If data in a given dataset is 
#' composite data, or data acquired over multiple days, a search 
#' will be done to match any intersection of the acquisition range. 
#' There currently is a 50,000 scene limit for the number of results 
#' that are returned, however, some client applications may encounter 
#' timeouts for large result sets for some datasets. 

#' To use the additional criteria field, pass one of the four search filter objects (SearchFilterAnd, SearchFilterBetween, SearchFilterOr, SearchFilterValue) in JSON format with additionalCriteria being the root element of the object.
#' 
#' @param datasetName Character. Used as a filter with wildcards inserted at the beginning and the end of the supplied value.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.
#' @param spatialFilter List. Used to apply a spatial filter on the data.
#' @param temporalFilter List. Used to apply a temporal filter on the data.
#' @param months Numeric. Used to limit results to specific months.
#' @param includeUnknownCloudCover Logical. Used to determine if scenes with unknown cloud cover values should be included in the results. Default is TRUE.
#' @param minCloudCover Numeric. Used to limit results by minimum cloud cover (for supported datasets). Range 0 to 100. Default is 0.
#' @param maxCloudCover Numeric. Used to limit results by maximum cloud cover (for supported datasets). Range 0 to 100. Default is 100.
#' @param additionalCriteria List. Used to filter results based on dataset specific metadata fields. Use datasetFields request to determine available fields and options.
#' @param maxResults Numeric. Used to determine the number of results to return	Use with startingNumber for controlled pagination. Maximum list size - 50,000
#' @param startingNumber Numeric. Used to determine the result number to start returning from	Use with maxResults for controlled pagination.
#' @param sortOrder Character. Used to order results based on acquisition date. Default="ASC".
#' @param lowerLeft List. When used in conjunction with upperRight, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param upperRight List. When used in conjunction with lowerLeft, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param startDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored. Default is "1920-01-01".
#' @param endDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored.Default is today's date.
#' @param apiKey Character. Users API Key/Authentication Token, obtained from espa_inventory_login request.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return Number of hits found given the search.
#' @details Additional Criteria Usage:
#' Additional criteria fields can be used to add metadata level filters to search results. This feature allows to creation of complex logical queries by allowing users to nest the 'and/or' logical operators, however, users should expect longer search times as these queries may take longer to execute. To obtain a datasets list of criteria fields, a datasetFields request must be executed. The response of this request will list all of the possible criteria fields. 
#' Some criteria fields include 'display lists'. These are lists of values that correspond to predefined values of interest within the dataset. In some cases their name and value are the same, but the value should be used at all times, as that value corresponds to the database values that will be searched on. 
#' When using the operand 'like', no wildcards are needed. The search will append the appropriate database wildcards and the beginning and end of the supplied value automatically. For all operands dealing with alphabetic values please note that searches are case sensitive. 
#' The second example below would result in the following query logic (using Landsat 8 dataset)
#' (WRS Path BETWEEN 22 AND 24) AND (WRS Row BETWEEN 38 AND 40)
#' 
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#search}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' 
#' # Standard search:
#' espa_inventory_search(datasetName="LANDSAT_8",
#' 		"lowerLeft"=list(latitude=75,longitude=-135),
#' 		"upperRight"=list(latitude=90,longitude=-120),
#' 		startDate="2006-01-01",endDate="2007-12-01",
#' 		maxResults=3,startingNumber=1,sortOrder="ASC",
#' 		apiKey=apiKey)
#' 
#' # Additional Criteria Usage:
#' espa_inventory_search(datasetName="LANDSAT_8",
#' 		additionalCriteria=list(
#' 				filterType="and",
#' 				childFilters=c(
#' 						list(filterType="between",fieldId=10036,
#' 							firstValue="22",secondValue="24"),
#' 						list(filterType="between",fieldId=10038,
#' 							firstValue="38",secondValue="40")
#' 						)),
#' 						node="EE",
#' 						maxResults=3,startingNumber=1,sortOrder="ASC",
#' 						apiKey=apiKey)
#' }
#' @export 

espa_inventory_search <- function(datasetName,
		spatialFilter="",
		temporalFilter="",
		months="",
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		maxResults=50000,startingNumber=1,sortOrder="ASC",
		apiKey,
		lowerLeft="",upperRight="",
		startDate="1920-01-07",endDate=Sys.Date(),
		verbose=F)
{
#	browser()
	
	
	# Updated for 1.4.0.
	if(spatialFilter=="" && (lowerLeft != "" && upperRight != ""))
	{
		spatialFilter <- espa_inventory_spatialFilter(lowerLeft=lowerLeft,upperRight=upperRight,filterType="mbr")
	}
	
	if(temporalFilter=="" && (startDate != "" && endDate != ""))
	{
		temporalFilter <- espa_inventory_temporalFilter(startDate=startDate,endDate=endDate,dateField="search_date")
	}
	
	
	search_parameters <- list(datasetName=datasetName,spatialFilter=spatialFilter,
			temporalFilter=temporalFilter,months=months,
			includeUnknownCloudCover=includeUnknownCloudCover,minCloudCover=minCloudCover,maxCloudCover=maxCloudCover,
			additionalCriteria=additionalCriteria,
			maxResults=maxResults,startingNumber=startingNumber,sortOrder=sortOrder,
			apiKey=apiKey)
	
	search <- espa_inventory_get_api(request_code="search",json_request_content=search_parameters,verbose=verbose)
	
	return(search)
}


		