#' espa_inventory_post_api
#' 
#' R wrapper for USGS/EROS Inventory Service POST API.
#' 
#' A function to convert requests to the USGS/EROS Inventory Service Request URL format (POST).
#' In general, you shouldn't need to call this directly unless you want finer command-line control over requests.
#' 
#' @param request_code Character. One of the requests listed at https://earthexplorer.usgs.gov/inventory/documentation/json-api
#' @param json_request_content List. Parameters to pass to the request system.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List generated from the request.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_login},\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api}
#' @examples
#' \dontrun{ 
#' # Run the API retrieval command:
#' 	login_parameters <- list(username="myusername",password="mypassword")
#' 	espa_inventory_post_api(request_code="login",json_request_content=login_parameters,verbose=verbose)
#' }
#' @import httr jsonlite
#' @export 

espa_inventory_post_api <- function(request_code,json_request_content,verbose=F)
{
	# https://earthexplorer.usgs.gov/inventory/documentation/json-api#login
	# <http_service_endpoint>/json/<request_code>?jsonRequest=<json_request_content>
	# http_service_endpoint <- "https://earthexplorer.usgs.gov/inventory/json/"
	
	current_version = "1.4.0"
	
	http_service_endpoint <- paste("https://earthexplorer.usgs.gov/inventory/json/v/",current_version,"/",sep="")
	
	# https://earthexplorer.usgs.gov/inventory/json/login?jsonRequest={"username":"XX","password":"XX"}
	
	url <- paste(http_service_endpoint,request_code,sep="")
	
	
	body <- paste("jsonRequest=",toJSON(json_request_content,auto_unbox=T),sep="")
#	browser()
	
	if(verbose)
	{
		return(content(POST(url,body=body,content_type("application/x-www-form-urlencoded"),verbose())))
		
	} else
	{
		return(content(POST(url,body=body,content_type("application/x-www-form-urlencoded"))))
		
	}
	
	
}


