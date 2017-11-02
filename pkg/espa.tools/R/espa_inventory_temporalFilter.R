#' espa_inventory_temporalFilter
#'  
#' @param startDate TBD
#' @param endDate TBD
#' @param dateField TBD
#' @details TBD
#' 
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net})
#' 
#' @examples
#' \dontrun{ 
#' ### TBD
#' }
#' 
#' @export 


espa_inventory_temporalFilter <- function(startDate,endDate,dateField="search_date")
{
#	browser()
	
	temporalFilter <- list(dateField=dateField,startDate=startDate,endDate=endDate)
	return(temporalFilter)
}