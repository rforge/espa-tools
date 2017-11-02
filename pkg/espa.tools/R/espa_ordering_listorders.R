#' espa_ordering_listorders
#' 
#' R wrapper for ESPA Ordering System List Orders API.
#' 
#' Lists orders for the authenticated user or a supplied email.
#' 
#' @param email Character. email address of a user.  Only neccessary if you want to list orders from a different user.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param ordernums_only Logical. Returns the orders in a nearly formatted character vector. Default=F.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return (ordernums_only=F) list or (ordernums_only=T) character vector of orders for a given user.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiOrdersEmail}
#' @examples
#' \dontrun{ 
#' # Get status for the authenticated user:
#' espa_ordering_listorders(usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' 
#' # Get status for a different user based on their email:
#' espa_ordering_listorders(email="my@@email.com",usgs_eros_username="myusername",
#' 		usgs_eros_password="mypassword")
#' }
#' @export

espa_ordering_listorders <- function(email=NULL,usgs_eros_username,usgs_eros_password,
		ordernums_only=F,verbose=F)
{
	
	current_version <- tail(names(espa_ordering_apiversions(usgs_eros_username,usgs_eros_password)),n=1)
		
	if(is.null(email))
	{
		json_request_content=NULL
	} else
	{
		json_request_content=email
	}
	
	
	espa_ordering_listorders_results <- 
			espa_ordering_get_api(request_code=paste("api/",current_version,"/list-orders",sep=""),json_request_content=json_request_content,
					usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
					verbose=verbose)
	
	if(ordernums_only) 
	{
		# v1 -- very messy cleaning:
		results <- strsplit(gsub(" ","",gsub("\"","",gsub("\\]","",gsub("\\[","",(as.list(espa_ordering_listorders_results)$body$p[[1]]))))),",")[[1]]
		espa_ordering_listorders_results <- results
	}
		
		
	#	espa_ordering_listorders_results <- unlist(espa_ordering_listorders_results$orders)
	return(espa_ordering_listorders_results)
	
}