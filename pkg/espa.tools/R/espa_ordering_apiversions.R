#' espa_ordering_apiversions
#' 
#' R wrapper for ESPA Ordering System API Versions API.
#' 
#' Lists all available versions of the api.
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of available api versions.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#api}
#' @examples
#' \dontrun{ 
#' espa_ordering_apiversions(usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export 

espa_ordering_apiversions <- function(usgs_eros_username,usgs_eros_password,verbose=F)
{
	return(espa_ordering_get_api(request_code="api",json_request_content=NULL,
			usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
			verbose=verbose))
	
	
}