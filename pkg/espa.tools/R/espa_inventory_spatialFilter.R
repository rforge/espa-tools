#' espa_inventory_spatialFilter
#'  
#' @param lowerLeft List. When used in conjunction with upperRight, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param upperRight List. When used in conjunction with lowerLeft, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param filterType TBD.
#' 
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


espa_inventory_spatialFilter <- function(lowerLeft,upperRight,filterType="mbr")
{
	spatialFilter <- list(filterType=filterType,lowerLeft=lowerLeft,upperRight=upperRight)
	return(spatialFilter)
}