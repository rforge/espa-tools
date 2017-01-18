#' espa_ordering_order
#' 
#' R wrapper for ESPA Ordering System Submit Order or Retrieve Details of an Order API.
#' 
#' Submit or retrieves details of an order with ESPA.
#' 
#' @param ordernum Character. An order number. See https://espa.cr.usgs.gov/ordering/order-status/ for the IDs.
#' @param orderrequest List. A properly formatted order request.  See the examples for details.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @seealso \code{\link{earthexplorer_search}}
#' @return If ordernum is supplied, a list of details of items in an order. If orderrequest is supplied, an ordernum.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiSubmitOrder}
#' @examples
#' \dontrun{ 
#' orderrequest=list(
#'		olitirs8=list(
#'				inputs="LC80270292015233LGN00",products="sr"),
#'		format=unbox("gtiff")) 
#' myorder <- espa_ordering_order(orderrequest=orderrequest,usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export
#' @import httr jsonlite


espa_ordering_order <- function(ordernum=NULL,orderrequest=NULL,usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	if(!is.null(ordernum))
	{
		json_request_content=ordernum
		return(espa_ordering_get_api(request_code="api/v0/order",json_request_content=json_request_content,
						usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
						verbose=verbose))
		
		
	} else
	{
		if(!is.null(orderrequest))
		{
			json_request_content=orderrequest
			return(espa_ordering_post_api(request_code="api/v0/order",json_request_content=orderrequest,
							usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
							verbose=verbose,auto_unbox=F))			
		} else
		{
			stop("Must have an ordernum or orderrequest set.")
			
		}
	}
}