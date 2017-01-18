#' espa_inventory_logout
#' 
#' R wrapper for USGS/EROS Inventory Service Logout API.
#' 
#' This method is used to remove the users API key from being used in the future.
#' 
#' @param apiKey Character. The apiKey returned by espa_inventory_login.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return Logical: did the logout conclude successfully?
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_logout}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#login}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' espa_inventory_logout(apiKey=apiKey)
#' }
#' @export 

espa_inventory_logout <- function(apiKey,verbose=F)
{
	logout_parameters <- list(apiKey=apiKey)
	
	logout <- espa_inventory_get_api(request_code="logout",json_request_content=logout_parameters,verbose=verbose)
	
	return(logout$data)
}