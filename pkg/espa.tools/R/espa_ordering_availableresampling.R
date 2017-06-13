#' espa_ordering_availableresampling
#' 
#' R wrapper for ESPA Ordering System API Output Resampling API.
#' 
#' Lists all available resampling methods
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of available output formats.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiResamp}
#' @examples
#' \dontrun{ 
#' espa_ordering_availableresampling(usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export 

espa_ordering_availableresampling <- function(usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	current_version <- tail(names(espa_ordering_apiversions(usgs_eros_username,usgs_eros_password)),n=1)
	
	return(espa_ordering_get_api(request_code=paste("api/",current_version,"/resampling-methods",sep=""),json_request_content=NULL,
					usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
					verbose=verbose))
	
}