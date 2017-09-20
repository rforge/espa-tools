#' earthexplorer_search
#' 
#' Searches and orders from Earth Explorer.
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param datasetName Character. Used as a filter with wildcards inserted at the beginning and the end of the supplied value.  See https://mapbox.github.io/usgs/reference/catalog/hdds.html for a list of valid datasetNames.  See Details for additional info.
#' @param lowerLeft List. When used in conjunction with upperRight, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param upperRight List. When used in conjunction with lowerLeft, creates a bounding box to search spatially. Should be a list of form list(latitude=XX,longitude=XX)
#' @param startDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored. Default is "1920-01-01".
#' @param endDate Character. Used to search datasets temporally for possible dataset coverage. ISO 8601 Formatted Date. Time portion is ignored.Default is today's date.
#' @param months Numeric. Used to limit results to specific months.
#' @param includeUnknownCloudCover Logical. Used to determine if scenes with unknown cloud cover values should be included in the results. Default is TRUE.
#' @param minCloudCover Numeric. Used to limit results by minimum cloud cover (for supported datasets). Range 0 to 100. Default is 0.
#' @param maxCloudCover Numeric. Used to limit results by maximum cloud cover (for supported datasets). Range 0 to 100. Default is 100.
#' @param additionalCriteria List. Used to filter results based on dataset specific metadata fields. Use datasetFields request to determine available fields and options.
#' @param sp SpatialPolygons. Used to refine the search results based on a polygon rather than a bounding box.
#' @param place_order Logical. If T, the search will be ordered.  Usually you want to search and refine first before ordering. Default is F.
#' @param products Character. A vector of products to be ordered.  Default is "sr" (surface reflectance).
#' @param format Character. The output file format for an order.  Default is "gtiff".
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return List of search results.
#' @details This is meant to be a fully functional command line interface to searching and (optionally) ordering products from Earth Explorer.
#' 
#' We have added some custom datasetNames to make searching a bit easier.  If datasetName="LANDSAT_4578", the search
#' will include Landsat 4 TM, Landsat 5 TM, Landset 7 ETM+, and Landsat 8 OLI.  This is a good if you want to order a long
#' time series of surface reflectance products.  Set products="sr" in that case.
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net}) (wrapper) 
#' and USGS ESPA Developers (API and documentation)
#' @seealso \code{\link{espa_inventory_search},\link{espa_ordering_order}}
#' @references \url{https://earthexplorer.usgs.gov}
#' @examples
#' \dontrun{ 
#' # Search only:
#' earthexplorer_search(
#'		usgs_eros_username="myusername",usgs_eros_password="mypassword",
#'		datasetName="GLS2005",
#' 		"lowerLeft"=list(latitude=75,longitude=-135),
#' 		"upperRight"=list(latitude=90,longitude=-120),
#' 		startDate="2006-01-01",endDate="2007-12-01",
#'		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
#'		place_order = F,
#'		verbose=T)
#' 
#' # Search and order:
#' earthexplorer_search(
#'		usgs_eros_username="myusername",usgs_eros_password="mypassword",
#'		datasetName="GLS2005",
#' 		"lowerLeft"=list(latitude=75,longitude=-135),
#' 		"upperRight"=list(latitude=90,longitude=-120),
#' 		startDate="2006-01-01",endDate="2007-12-01",
#'		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
#'		place_order = T,
#' 		products="sr",
#' 		format="gtiff",
#'		verbose=T)
#' }
#' @import rgdal foreach rgeos
#' @export 

earthexplorer_search <- function(
		usgs_eros_username,usgs_eros_password,
		datasetName,
		lowerLeft=NULL,upperRight=NULL,
		startDate="1920-01-07",endDate=as.character(Sys.Date()),months="",
		includeUnknownCloudCover=T,minCloudCover=0,maxCloudCover=100,
		additionalCriteria="",
		sp=NULL,
		place_order=F,
		products="sr",
		format="gtiff",
		verbose=F)
{
	# Parameters:
#	special_datasetName=list(
#			LANDSAT_4578=c("LANDSAT_TM","LANDSAT_ETM","LANDSAT_8" )#,
#	#	LANDSAT_4578_SR=c("LSR_LANDSAT_TM","LSR_LANDSAT_ETM_COMBINED","LSR_LANDSAT_8")
#	)
	
	special_datasetName=list(
			LANDSAT_4578=c("LANDSAT_TM_C1","LANDSAT_ETM_C1","LANDSAT_8_C1" ),
			LANDSAT_4578_SR=c("LSR_LANDSAT_TM_C1","LSR_LANDSAT_ETM_C1","LSR_LANDSAT_8_C1")
	)
	
	# First, get API key:
	if(verbose) message("Logging into Earth Explorer...")
	apiKey=espa_inventory_login(usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,verbose=verbose)
	if(is.null(apiKey)) stop("Failure to login.  Please use your ESPA credentials used at https://espa.cr.usgs.gov/login")
	
	# Next, check to see if datasetNames are ok:
	available_datasets <- espa_inventory_datasets(
			#		lowerLeft=lowerLeft,upperRight=upperRight,
			#		startDate=startDate,endDate=endDate,
			apiKey=apiKey,verbose=verbose)
	
#	browser()
	
	available_datasetNames <- sapply(available_datasets$data,function(x) return(x$datasetName))
	
#	browser()
	
	if(any(names(special_datasetName) %in% datasetName))
	{
		# index of special datasetNames:
		special_datasetName_index <- names(special_datasetName) %in% datasetName
		additional_datasets <- unlist(special_datasetName[special_datasetName_index])
		datasetName <- c(unlist(special_datasetName[special_datasetName_index]),datasetName[!(datasetName %in% names(special_datasetName))])
		
	} else
	{
		additional_datasets=NULL
	}
	
	if(verbose) message("Checking for valid datasetNames...")
	
	
	# browser()
	# Make sure they are ok:
	if(!all(datasetName %in% available_datasetNames)) 
	{
		missing_datasetNames <- datasetName[!(datasetName %in% available_datasetNames)]
		message(paste(missing_datasetNames,"are not available.  Please fix datasetName parameter."))
		stop(paste("Valid datasetNames:",available_datasetNames,collapse=T))
	}
	
	# Set up corners if a sp object is used:
	if(!is.null(sp))
	{
		sp_ll <- spTransform(sp,CRS("+proj=longlat +datum=WGS84"))
		sp_ll_bbox <- bbox(sp_ll)
		lowerLeft <- list(latitude=sp_ll_bbox[2,1],longitude=sp_ll_bbox[1,1])
		upperRight <- list(latitude=sp_ll_bbox[2,2],longitude=sp_ll_bbox[1,2])
		
	}
	
	# Do initial search:
	initial_search <- foreach(i=datasetName) %do%
			{
				espa_inventory_search(datasetName=i,lowerLeft=lowerLeft,upperRight=upperRight,
						startDate=startDate,endDate=endDate,months="",
						includeUnknownCloudCover=includeUnknownCloudCover,minCloudCover=minCloudCover,maxCloudCover=maxCloudCover,
						additionalCriteria=additionalCriteria,
						maxResults=50000,startingNumber=1,sortOrder="ASC",
						apiKey=apiKey,verbose=verbose)
			}
	
	names(initial_search) <- datasetName
	# TODO: DEAL WITH TIMEOUTS
	
	# Remove datasets with no results:
	# search_with_results_index <- sapply(initial_search,function(x) {!is.null(x$data)} )
	
	
#	browser()
	
	# Check for intersection with poly if need be and remove searches outside of it.
	if(!is.null(sp))
	{
		search_to_spatialPolygons_datasets <- lapply(initial_search,search_to_spatialPolygons)
		refined_search_results <- foreach(i=seq(length(initial_search))) %do%
				{
					intersection_ids <- gIntersects(search_to_spatialPolygons_datasets[[i]],sp_ll,byid=T)
					return(initial_search[[i]]$data$results[intersection_ids])
				}
		# refined_search <- initial_search
		for(i in seq(length(initial_search)))
		{
			initial_search[[i]]$data$results <- refined_search_results[[i]]
		}
	}
	
	# TODO: IMPLEMENT MULTIPLE MONTHS
	
	if(!is.null(months))
	{
		search_to_Dates_datasets <- lapply(initial_search,search_to_Dates)
		refined_search_results <- foreach(i=seq(length(initial_search))) %do%
				{
					intersection_ids <- search_to_Dates_datasets[[i]]$acquisitionMonth %in% months					
					return(initial_search[[i]]$data$results[intersection_ids])
				}
		
		# refined_search <- initial_search
		for(i in seq(length(initial_search)))
		{
			initial_search[[i]]$data$results <- refined_search_results[[i]]
		}
	}
	
	if(place_order)
	{
		# only need to be ordered if not available for downloading
		if(!is.null(products))
		{
#			browser()
			
			entities <- foreach(i=seq(length(initial_search))) %do%
					{
						current_search <- initial_search[[i]]
						if(length(current_search$data$results) > 0)
						{
							if(names(initial_search)[i] %in% c("LANDSAT_TM_C1","LANDSAT_ETM_C1","LANDSAT_8_C1" ))
							{
								return(sapply(current_search$data$results,function(x) return(x$displayId)))						
							} else
							{
								return(sapply(current_search$data$results,function(x) return(x$entityId)))
							}
						} else
						{
							return(NULL)
						}
					}
			names(entities) <- names(initial_search)
			
			# Check for product info for all products:
			if(verbose) message("Checking for product availability...")
			entities_all <- unlist(entities,recursive=T)
			entities_availability <- lapply(entities_all,
					function(x,usgs_eros_username,usgs_eros_password) espa_ordering_availableproducts(x,
								usgs_eros_username,usgs_eros_password),
					usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password)
			
			order_df <- foreach(i=seq(length(entities_availability)),.combine="rbind") %do%
					{
						sensor_id <- names(entities_availability[[i]])
						available_products <- entities_availability[[i]][[1]]$products
						if(all(products %in% unlist(entities_availability[[i]][[1]]$products)))
						{
							return(data.frame(sensor_id=sensor_id,entity_id=unlist(entities_availability[[i]][[1]]$inputs)))
						} else
						{
							return(NULL)
						}
					}
			
			
			# Create order:
			# Right now this is hard-coded, but we'll fix this with a package.
			# ASSUMPTION: LANDSAT_8 = OLITIRS8
			
			#	espa_dataset_mappings <- read.csv("C:\\Users\\jgreenberg\\git\\espa_tools\\espa_tools\\inst\\extdata\\espa_order_to_inventory_naming.csv")
			
			#	browser()
			
#			order_df <- foreach(i=seq(length(initial_search)),.combine="rbind") %do%
#					{
#						if(!is.null(entities[[i]]))
#						{
#							sensor_id_index <- espa_dataset_mappings$inventory_name %in% names(entities)[i]
#							
#							# LANDSAT_TM FIX
#							if(names(entities)[i]=="LANDSAT_TM")
#							{
#								landsat_number <- substr(entities[[i]], 3, 3)
#								sensor_id <- landsat_number
#								sensor_id[landsat_number=="4"] <- "tm4"
#								sensor_id[landsat_number=="5"] <- "tm5"
#							} else
#							{
#								sensor_id <- espa_dataset_mappings$order_name[sensor_id_index]
#							}
#							temp_order_df <- data.frame(sensor_id=sensor_id,entity_id <- entities[i])
#							names(temp_order_df) <- c("sensor_id","entity_id")
#							return(temp_order_df)	
#						} else
#						{
#							return(NULL)
#						}
#					}
#			
			# order_list <- vector(mode="list")
			# Check for unique sensors:
			unique_sensors <- unique(order_df$sensor_id)
			order_list <- foreach(i=unique_sensors) %do%
					{
						return(list(inputs=order_df$entity_id[order_df$sensor_id==i],products=products))
					}
			names(order_list) <- unique_sensors
			order_list$format=unbox(format)
#			browser()
			espa_ordering_order_results <- espa_ordering_order(orderrequest=order_list,usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password,verbose=verbose)
			if(verbose) 
			{
				message("Order placed:")
				message(espa_ordering_order_results)
				
			}
			
		} else
		{
			message("No product selected, so nothing was ordered.")
		}
	}
	
	
	# Logout:
	logout <- espa_inventory_logout(apiKey)
	if(verbose) { if(!logout) message("Logout unsuccessful.")} else { message("Logout successful.") }
	
	return(initial_search)
	
}