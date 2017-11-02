#' espa_inventory_datasets
#' 
#' R wrapper for USGS/EROS Inventory Service Dataset Search API.
#' 
#' This method is used to find datasets available for searching. 
#' By passing no parameters except node, all available datasets are returned. 
#' Additional parameters such as temporal range and spatial bounding box can 
#' be used to find datasets that provide more specific data. The dataset name 
#' parameter can be used to limit the results based on matching the supplied 
#' value against the public dataset name with assumed wildcards at the beginning 
#' and end.
#' 
#' @param datasetName Character. Used as a filter with wildcards inserted at the beginning and the end of the supplied value.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.
#' @param spatialFilter TBD
#' @param temporalFilter TBD
#' @param lowerLeft List. When used in conjunction with upperRight, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param upperRight List. When used in conjunction with lowerLeft, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param startDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored.
#' @param endDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored.
#' @param apiKey Character. Users API Key/Authentication Token, obtained from espa_inventory_login request.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of metadata filter fields for datasets available for searching.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#datasets}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' espa_inventory_datasets(datasetName="LANDSAT_8",lowerLeft=list(latitude=44.60847,"longitude"=-99.69639),
#'    upperRight=list(latitude=44.60847,"longitude"=-99.69639),
#'    startDate="2014-10-01",endDate="2014-10-01",
#'    apiKey=apiKey)
#' }
#' @export 

espa_inventory_datasets <- function(datasetName=NULL,
		spatialFilter=NULL,
		temporalFilter=NULL,
		lowerLeft=NULL,upperRight=NULL,
		startDate="1920-01-07",endDate=Sys.Date(),apiKey,verbose=F)
{
	if(is.null(spatialFilter) && (!is.null(lowerLeft) && !is.null(upperRight)))
	{
		spatialFilter <- espa_inventory_spatialFilter(lowerLeft=lowerLeft,upperRight=upperRight,filterType="mbr")
	}
	
	if(is.null(temporalFilter) && (!is.null(startDate) && !is.null(endDate)))
	{
		temporalFilter <- espa_inventory_temporalFilter(startDate=startDate,endDate=endDate,dateField="search_date")
	}
	
	
	# We need to build this list up rather than pre-create it:
	datasets_parameters <- vector(mode="list")
	
	if(!is.null(datasetName)) datasets_parameters$datasetName=datasetName
	if(!is.null(spatialFilter)) datasets_parameters$spatialFilter=spatialFilter
	if(!is.null(temporalFilter)) datasets_parameters$temporalFilter=temporalFilter
	
#	if(!is.null(lowerLeft)) datasets_parameters$lowerLeft=lowerLeft
#	if(!is.null(upperRight)) datasets_parameters$upperRight=upperRight
#	if(!is.null(startDate)) datasets_parameters$startDate=startDate
#	if(!is.null(endDate)) datasets_parameters$endDate=endDate
	
	datasets_parameters$apiKey=apiKey
	
#	
#	datasets_parameters <- list(datasetName=datasetName,lowerLeft=lowerLeft,upperRight=upperRight,
#			startDate=startDate,endDate=endDate,
#			apiKey=apiKey,node=node)
	
	datasets <- espa_inventory_get_api(request_code="datasets",json_request_content=datasets_parameters,verbose=verbose)
	
	return(datasets)
}