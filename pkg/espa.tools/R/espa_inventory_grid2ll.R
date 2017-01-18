#' espa_inventory_datasets
#' 
#' R wrapper for USGS/EROS Inventory Service Dataset Grid to Lat/Lng API.
#' 
#' This method is used to convert the following grid systems to lat/lng 
#' center points or polygons: WRS-1, WRS-2. To account for multiple grid 
#' systems there are required fields for all grids (see "Required Request 
#' Parameters") as well as grid-specific parameters.
#' 
#' @param gridType Character. Identifies the grid system	Accepted values: "WRS1" and "WRS2".
#' @param responseShape Character. Determines if the response should be a center point or outer polygon	Accepted values: "point" and "polygon"
#' @param path Numeric. WRS Path.
#' @param row Numeric. WRS Row.
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of metadata on the conversion of the grid systems to lat/lng center points or polygons.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_get_api}}
#' @references \url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#grid2ll}
#' @examples
#' \dontrun{ 
#' espa_inventory_grid2ll(gridType="WRS1",responseShape="polygon",path=1,row=1)
#' }
#' @export 

espa_inventory_grid2ll <- function(gridType,responseShape,path,row,verbose=F)
{
	grid2ll_parameters <- list(gridType=gridType,responseShape=responseShape,path=path,row=row)
	
	grid2ll <- espa_inventory_get_api(request_code="grid2ll",json_request_content=grid2ll_parameters,verbose=verbose)
	
	return(grid2ll)
}