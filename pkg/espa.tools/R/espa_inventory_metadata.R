#' espa_inventory_metadata
#' 
#' R wrapper for USGS/EROS Inventory Service Scene Metadata API.
#' 
#' The use of the metadata request is intended for those who have 
#' acquired scene IDs from a different source. It will return the 
#' same metadata that is available via the search request.
#' 
#' @param datasetName Character. Identifies the dataset	Use the datasetName from datasets response.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.
#' @param entityIds Character. Identifies multiple scenes to remove. 
#' @param apiKey Character. Users API Key/Authentication Token, obtained from espa_inventory_login request.
#' @param node Character. Determines the dataset catalog to use. Default="EE", probably never needs to be changed.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of metadata.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#metadata}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' espa_inventory_metadata(datasetName="LANDSAT_8",entityIds=c("LC80130292014100LGN00"),apiKey=apiKey)
#' }
#' @export 

espa_inventory_metadata <- function(datasetName,entityIds,apiKey,node="EE",verbose=F)
{
	metadata_parameters <- list(datasetName=unbox(datasetName),entityIds=entityIds,
			apiKey=unbox(apiKey),node=unbox(node))
	
	metadata <- espa_inventory_get_api(request_code="metadata",json_request_content=metadata_parameters,auto_unbox=F,verbose=verbose)
	
	return(metadata)
}