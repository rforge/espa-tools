#' espa_ordering_userinformation
#' 
#' R wrapper for ESPA Ordering System User Information API.
#' 
#' Returns user information for the authenticated user.
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of user information.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiUser}
#' @examples
#' \dontrun{ 
#' espa_ordering_userinformation(usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export 

espa_ordering_userinformation <- function(usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	current_version <- tail(names(espa_ordering_apiversions(usgs_eros_username,usgs_eros_password)),n=1)
	
	return(espa_ordering_get_api(request_code=paste("api/",current_version,"/user",sep=""),json_request_content=NULL,
			usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
			verbose=verbose))
	
}