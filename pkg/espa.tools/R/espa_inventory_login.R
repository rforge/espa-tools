#' espa_inventory_login
#' 
#' R wrapper for USGS/EROS Inventory Service Login API.
#' 
#' Upon a successful login, an API key will be returned. 
#' This key will be active for one hour and should be 
#' destroyed upon final use of the service by calling the 
#' logout method. Users must have "Machine to Machine" 
#' access, which is established in the user's profile. 
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return Character of the API KEY needed by the other inventory APIs.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_logout}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#login}
#' @examples
#' \dontrun{ 
#' # Get API KEY (required EROS username/password): 
#' apiKey=espa_inventory_login("myusername","mypassword")
#' }
#' @export 


espa_inventory_login <- function(usgs_eros_username,usgs_eros_password,verbose=F)
{
	login_parameters <- list(username=usgs_eros_username,password=usgs_eros_password)
	
	api_key <- espa_inventory_post_api(request_code="login",json_request_content=login_parameters,verbose=verbose)
	
	return(api_key$data)
}