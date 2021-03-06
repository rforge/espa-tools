% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/espa_ordering_availableproducts.R
\name{espa_ordering_availableproducts}
\alias{espa_ordering_availableproducts}
\title{espa_ordering_availableproducts}
\usage{
espa_ordering_availableproducts(inputs = NULL, usgs_eros_username,
  usgs_eros_password, verbose = F)
}
\arguments{
\item{inputs}{Character. A vector of product_ids.}

\item{usgs_eros_username}{Character. Your USGS registration username. You can register for an account at https://espa.cr.usgs.gov}

\item{usgs_eros_password}{Character. Your USGS registration password. WARNING: USING THIS WITH R IS NOT PARTICULARLY SECURE.}

\item{verbose}{Logical. Verbose execution?  Default=F.}
}
\value{
List of available output products.
}
\description{
R wrapper for ESPA Ordering System API Available Products API.
}
\details{
Lists available products for the supplied inputs. Also 
classifies the inputs by sensor or lists as 'not implemented' 
if the values cannot be ordered or determined.
}
\examples{
\dontrun{ 
inputs <- "LC08_L1TP_029030_20161008_20170220_01_T1"
espa_ordering_availableproducts(inputs=inputs,
		usgs_eros_username="myusername",usgs_eros_password="mypassword")
}
}
\references{
\url{https://github.com/USGS-EROS/espa-api#apiProdsGet}
}
\author{
Jonathan A. Greenberg (\email{espa-tools@estarcion.net}) (wrapper) 
and USGS ESPA Developers (API and documentation)
}
