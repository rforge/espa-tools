#' espa_inventory_status
#' 
#' R wrapper for USGS/EROS Inventory Service Status API.
#' 
#' This method is used to get the status of the API. 
#' 
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of status info of the API.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#status}
#' @examples
#' \dontrun{ 
#' espa_inventory_status()
#' }
#' @export 

espa_inventory_status <- function(verbose=F)
{
	status_parameters <- ""
	
	status <- espa_inventory_get_api(request_code="status",json_request_content=status_parameters,verbose=verbose)
	
	return(status)
}