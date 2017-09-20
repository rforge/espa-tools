#' @export 


espa_inventory_temporalFilter <- function(startDate,endDate,dateField="search_date")
{
#	browser()
	
	temporalFilter <- list(dateField=dateField,startDate=startDate,endDate=endDate)
	return(temporalFilter)
}