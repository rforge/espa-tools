#' espa_ordering_apioperations
#' 
#' R wrapper for ESPA Ordering System API Operations API.
#' 
#' Lists all available api operations.
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of available api operations.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiOps}
#' @examples
#' \dontrun{ 
#' espa_ordering_apioperations(usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @import utils
#' @export 

espa_ordering_apioperations <- function(usgs_eros_username,usgs_eros_password,verbose=F)
{
	current_version <- tail(names(espa_ordering_apiversions(usgs_eros_username,usgs_eros_password)),n=1)
	
	return(espa_ordering_get_api(request_code=paste("api/",current_version,sep=""),json_request_content=NULL,
			usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
			verbose=verbose))
	
}