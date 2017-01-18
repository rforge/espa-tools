#' espa_inventory_datasetfields
#' 
#' R wrapper for USGS/EROS Inventory Service Dataset Fields API.
#' 
#' This request is used to return the metadata filter fields for the specified dataset. 
#' These values can be used as additional criteria when submitting search and hit queries.
#' 
#' @param datasetName Character.  Identifies the dataset.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.
#' @param node Character. Determines the dataset catalog to use. Default="EE", probably never needs to be changed.
#' @param apiKey Character. Users API Key/Authentication Token, obtained from espa_inventory_login request.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of metadata filter fields for the specified dataset.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#datasetfields}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' espa_inventory_datasetfields(datasetName="LANDSAT_8",apiKey=apiKey)
#' }
#' @export 

espa_inventory_datasetfields <- function(datasetName,node="EE",apiKey,verbose=F)
{
	datasetfields_parameters <- list(datasetName=datasetName,node=node,apiKey=apiKey)
	
	datasetfields <- espa_inventory_get_api(request_code="datasetfields",json_request_content=datasetfields_parameters,verbose=verbose)
	
	return(datasetfields)
}