#' @export 


espa_inventory_spatialFilter <- function(lowerLeft,upperRight,filterType="mbr")
{
	spatialFilter <- list(filterType=filterType,lowerLeft=lowerLeft,upperRight=upperRight)
	return(spatialFilter)
}