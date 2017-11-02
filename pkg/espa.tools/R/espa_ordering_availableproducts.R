#' espa_ordering_availableproducts
#' 
#' R wrapper for ESPA Ordering System API Available Products API.
#' 
#' Lists available products for the supplied inputs. Also 
#' classifies the inputs by sensor or lists as 'not implemented' 
#' if the values cannot be ordered or determined.
#' 
#' @param inputs Character. A vector of product_ids.
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of available output products.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @references \url{https://github.com/USGS-EROS/espa-api#apiProdsGet}
#' @examples
#' \dontrun{ 
#' inputs <- "LC08_L1TP_029030_20161008_20170220_01_T1"
#' espa_ordering_availableproducts(inputs=inputs,
#' 		usgs_eros_username="myusername",usgs_eros_password="mypassword")
#' }
#' @export

espa_ordering_availableproducts <- function(inputs=NULL,usgs_eros_username,usgs_eros_password,verbose=F)
{
	
	current_version <- tail(names(espa_ordering_apiversions(usgs_eros_username,usgs_eros_password)),n=1)
	
	if(is.character(inputs))
	{
		inputs <- list(inputs=inputs)
	}
	
#	browser()
	
#	if(is.null(inputs))
#	{
#		return(espa_ordering_get_api(request_code=paste("api/",current_version,"/available-products",sep=""),json_request_content=NULL,
#						usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
#						verbose=verbose))
#	} else
#	{
		
		return(espa_ordering_get_api(request_code=paste("api/",current_version,"/available-products",sep=""),json_request_content=inputs,
						usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,
						verbose=verbose))
#	}
}