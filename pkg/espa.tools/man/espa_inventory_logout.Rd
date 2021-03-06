% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/espa_inventory_logout.R
\name{espa_inventory_logout}
\alias{espa_inventory_logout}
\title{espa_inventory_logout}
\usage{
espa_inventory_logout(apiKey, verbose = F)
}
\arguments{
\item{apiKey}{Character. The apiKey returned by espa_inventory_login.}

\item{verbose}{Logical. Verbose execution?  Default=F.}
}
\value{
Logical: did the logout conclude successfully?
}
\description{
R wrapper for USGS/EROS Inventory Service Logout API.
}
\details{
This method is used to remove the users API key from being used in the future.
}
\examples{
\dontrun{ 
# Get API KEY (required EROS username/password): 
apiKey=espa_inventory_login("myusername","mypassword")
espa_inventory_logout(apiKey=apiKey)
}
}
\references{
\url{https://earthexplorer.usgs.gov/inventory/documentation/json-api#login}
}
\seealso{
\code{\link{espa_inventory_logout}}
}
\author{
Jonathan A. Greenberg (\email{espa-tools@estarcion.net}) (wrapper) 
and USGS ESPA Developers (API and documentation)
}
