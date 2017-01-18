#' espa_ordering_itemstatus
#' 
#' R wrapper for ESPA Ordering System Status and Details API.
#' 
#' Retrieve status and details for all or a particular product in an order
#' 
#' @param ordernum Character. An order number. See https://espa.cr.usgs.gov/ordering/order-status/ for the IDs.
#' @param itemnum Character. An item number.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of status and details of items in an order.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiProdStats}
#' @examples
#' \dontrun{ 
#' # Get status for all items in a given order:
#' espa_ordering_itemstatus(ordernum="my@@email.com-01122017-154454-218",usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' 
#' # Get status for a single item in a given order:
#' espa_ordering_itemstatus(ordernum="my@@email.com-01122017-154454-218",itemnum="LC80410312015219LGN00",usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export


espa_ordering_itemstatus <- function(ordernum=NULL,itemnum=NULL,usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	if(is.null(ordernum))
	{
		stop("Must have an ordernum set.")
		#	json_request_content=NULL
	} else
	{
		if(is.null(itemnum))
		{
			json_request_content=ordernum
		} else
		{
			json_request_content=paste(ordernum,itemnum,sep="/")
		}
	}
	
	
	return(espa_ordering_get_api(request_code="api/v0/item-status",json_request_content=json_request_content,
					usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
					verbose=verbose))
	
}