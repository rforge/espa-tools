#' espa_ordering_itemstatus
#' 
#' R wrapper for ESPA Order Status API.
#' 
#' Retrieves a submitted orders status
#' 
#' @param ordernum Character. An order number. See https://espa.cr.usgs.gov/ordering/order-status/ for the IDs.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of order status.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiStatus}
#' @examples
#' \dontrun{ 
#' espa_ordering_orderstatus(ordernum="my@@email.com-01122017-154454-218",usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export
espa_ordering_orderstatus <- function(ordernum=NULL,usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	if(is.null(ordernum))
	{
		stop("Must have an ordernum set.")
	} else
	{
		json_request_content=ordernum
	}
	
	
	return(espa_ordering_get_api(request_code="api/v0/order-status",json_request_content=json_request_content,
			usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
			verbose=verbose))
	
}