#' espa_inventory_get_api
#' 
#' R wrapper for USGS/EROS Inventory Service GET API.
#' 
#' A function to convert requests to the USGS/EROS Inventory Service Request URL format (GET).
#' In general, you shouldn't need to call this directly unless you want finer command-line control over requests.
#' 
#' @param request_code Character. One of the requests listed at https://earthexplorer.usgs.gov/inventory/documentation/json-api
#' @param json_request_content List. Parameters to pass to the request system.
#' @param auto_unbox Logical auto_unbox the json_request_content?  Default = T.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List generated from the request.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_post_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api}
#' @examples
#' \dontrun{ 
#' # Run the simple API status command:
#' espa_inventory_get_api(request_code="status",json_request_content="",verbose=F)
#' }
#' @import httr jsonlite
#' @export 

espa_inventory_get_api <- function(request_code,json_request_content,auto_unbox=T,verbose=F)
{
	# https://earthexplorer.usgs.gov/inventory/documentation/json-api#login
	# <http_service_endpoint>/json/<request_code>?jsonRequest=<json_request_content>
	# https://earthexplorer.usgs.gov/json/v/1.4.0/<request_code>?jsonRequest=<json_request_content>
	
	current_version = "1.4.0"
	
	http_service_endpoint <- paste("https://earthexplorer.usgs.gov/inventory/json/v/",current_version,"/",sep="")
	
	# https://earthexplorer.usgs.gov/inventory/json/login?jsonRequest={"username":"XX","password":"XX"}
	
	url <- paste(http_service_endpoint,request_code,sep="")
	
	body <- paste("jsonRequest=",toJSON(json_request_content,auto_unbox=auto_unbox),sep="")
	#	browser()
	if(verbose)
	{
		return(content(GET(paste(url,"?",body,sep=""),content_type("application/x-www-form-urlencoded"),verbose())))
	} else
	{
		return(content(GET(paste(url,"?",body,sep=""),content_type("application/x-www-form-urlencoded"))))
		
	}
}