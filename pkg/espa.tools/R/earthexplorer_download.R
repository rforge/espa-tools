#' earthexplorer_download
#' 
#' Downloads from Earth Explorer.
#' 
#' @param usgs_eros_username Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov
#' @param usgs_eros_password Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.
#' @param output_folder Character. Folder to save results to.
#' @param earthexplorer_search_results List. Output from earthexplorer_search or espa_inventory_search.  Only used to download quicklooks.
#' @param quicklooks_only Logical. If earthexplorer_search_results isn't NULL, will download the quicklooks of the search results.
#' @param ordernum Character. An order number. See https://espa.cr.usgs.gov/ordering/order-status/ for the IDs.
#' @param overwrite Logical. Overwrite existing results?  Default is FALSE
#' @param verbose Logical. Verbose execution?  Default=F.
#' @return NULL and the files downloaded into the output_folder.
#' @details This is esssentially the command line version of the bulk download application.
#' Typically you submit a search using earthexplorer_search or just the Earth Explorer GUI, wait
#' a bit for it to process, and when you get your notificaiton the order is complete, you
#' submit the ordernum to this function for batch downloading. 
#' 
#' @author Jonathan A. Greenberg (\email{espa-tools@@estarcion.net})
#' @seealso \code{\link{espa_inventory_search},\link{espa_ordering_order}}
#' @references \url{https://earthexplorer.usgs.gov}
#' @examples
#' \dontrun{ 
#' # Get a list of your orders, and choose the first order result:
#' my_orders <- espa_ordering_listorders(usgs_eros_username="myusername",usgs_eros_password="mypassword",ordernums_only=T)
#' my_latest_order <- my_orders[1]
#' earthexplorer_download(usgs_eros_username="myusername",usgs_eros_password="mypassword",
#' 	output_folder=getwd()
#' 	ordernum=my_latest_order)
#' }
#' @import httr foreach parallel
#' @export 

earthexplorer_download <- function(
		usgs_eros_username,usgs_eros_password,output_folder=getwd(),
		earthexplorer_search_results=NULL,quicklooks_only=F,
		ordernum=NULL,
#		organize_by=NULL,
#		concurrent_downloads=1,
		overwrite=F,
#		progress=F,
		verbose=F)	
{
	# To pass check:
	i=NULL
	
	concurrent_downloads=1
	
	# Make this better:
	setwd(output_folder)
	
	if(!is.null(earthexplorer_search_results))
	{
		if(quicklooks_only)
		{
			# Download urls:
			download_urls <- foreach(i=seq(length(earthexplorer_search_results)),.combine="rbind") %do%
					{
						current_search <- earthexplorer_search_results[[i]]
						if(current_search$data$numberReturned > 0)
						{
							urls <- sapply(current_search$data$results,function(x) return(x$browseUrl))
							basenames <- basename(urls)
							urls_basenames <- data.frame(url=urls,basename=basenames,stringsAsFactors=F)
						} else
						{
							return(NULL)
						}
					}
			
			# Perform download
			registerDoSEQ()
			downloads <- foreach(i=seq(nrow(download_urls))) %dopar%
					{
						print(i)
						if((overwrite || (!overwrite && !file.exists(download_urls$basename[i]))) && (download_urls$basename[i] != "")) {
							return(GET(download_urls$url[i],write_disk(download_urls$basename[i],overwrite=overwrite),authenticate(usgs_eros_username,usgs_eros_password)))
						} else
						{
							return(NULL)
						}
					}
			
			
		}
	}
	
	if(!is.null(ordernum))
	{
		# First check the status:
		order_status <- espa_ordering_orderstatus(ordernum=ordernum,usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password)
		if(order_status$status=="ordered") 
		{
			message("Order is not yet completed, please try again later or visit")
			message(paste("https://espa.cr.usgs.gov/ordering/order-status/",ordernum,sep=""))
			stop("for more details.")
		} else
		{
			# Now download!  output folder isn't working yet...
			order_info <- espa_ordering_itemstatus(ordernum=ordernum,usgs_eros_username=usgs_eros_username,usgs_eros_password=usgs_eros_password)
			# download_urls <- data.frame(url=sapply(order_info$orderid[[1]],function(x) return(x$product_dload_url)),stringsAsFactors=F)
			download_urls <- data.frame(url=sapply(order_info[[1]],function(x) return(x$product_dload_url)),stringsAsFactors=F)
			# Remove blank urls:
			#	browser()
			download_urls <-as.data.frame(download_urls[download_urls[,1] != "",],stringsAsFactors=F)
			names(download_urls) <- "url"
			#		browser()
			download_urls$basename <- basename(download_urls$url)
			
			if(concurrent_downloads == 1)
			{
				registerDoSEQ()
			} else
			{
				# Do not allow more than 4 concurrent downloads at once
				if(concurrent_downloads > 4) concurrent_downloads = 4
				cl <- makeCluster(spec=concurrent_downloads,type="PSOCK")
				setDefaultCluster(cl=cl)
				registerDoParallel(cl)
			}
			
			downloads <- foreach(i=seq(nrow(download_urls)),.packages=c("httr")) %dopar%
					{
						GET(download_urls$url[i],write_disk(download_urls$basename[i],overwrite=overwrite),authenticate(usgs_eros_username,usgs_eros_password))
					}
			
			if(concurrent_downloads > 1)
			{
				registerDoSEQ()
				tryCatch(stopCluster(cl),error=function(e){})
			}
		}
	}
	
	return(NULL)
}