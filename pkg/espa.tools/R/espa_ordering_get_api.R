#' espa_ordering_get_api
#' 
#' R wrapper for USGS/EROS Ordering System GET API.
#' 
#' A function to convert requests to the USGS/EROS Ordering System URL format (GET).
#' In general, you shouldn't need to call this directly unless you want finer command-line control over requests.
#' 
#' @param request_code Character. One of the requests listed at https://earthexplorer.usgs.gov/inventory/documentation/json-api
#' @param json_request_content List. Parameters to pass to the request system.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List generated from the request.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_ordering_post_api}}
#' @examples
#' \dontrun{ 
#' # Run the API version command:
#' espa_ordering_get_api(request_code="api",json_request_content=NULL,usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @import httr jsonlite
#' @export 



espa_ordering_get_api <- function(request_code,json_request_content=NULL,
		usgs_eros_username,usgs_eros_password,verbose=F)
{
	# https://earthexplorer.usgs.gov/inventory/documentation/json-api#login
	# <http_service_endpoint>/json/<request_code>?jsonRequest=<json_request_content>
	http_service_endpoint <- "https://espa.cr.usgs.gov/"
	
	# https://earthexplorer.usgs.gov/inventory/json/login?jsonRequest={"username":"XX","password":"XX"}
	
	url <- paste(http_service_endpoint,request_code,sep="")
	
	if(is.null(json_request_content))
	{
		body <- NULL
		
		if(verbose)
		{
			return(content(GET(paste(url,body,sep=""),authenticate(usgs_eros_username, usgs_eros_password),verbose())))
		} else
		{
			return(content(GET(paste(url,body,sep=""),authenticate(usgs_eros_username, usgs_eros_password))))
			
		}
	} else
	{
		# I don't think this is working:
	#	body <- toJSON(paste("/",json_request_content,sep=""),auto_unbox=T)
		body <- json_request_content
		if(verbose)
		{
			return(content(GET(paste(url,body,sep="/"),authenticate(usgs_eros_username, usgs_eros_password),verbose())))
		} else
		{
			return(content(GET(paste(url,body,sep="/"),authenticate(usgs_eros_username, usgs_eros_password))))
			
		}
		
	}
		
#	browser()
#	if(verbose)
#	{
#		return(content(GET(paste(url,body,sep=""),authenticate(usgs_eros_username, usgs_eros_password),verbose())))
#	} else
#	{
#		return(content(GET(paste(url,body,sep=""),authenticate(usgs_eros_username, usgs_eros_password))))
#		
#	}
}