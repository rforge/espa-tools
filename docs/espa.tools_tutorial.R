

##### ESPA Tools for R Tutorial #####

### STEP 1: INSTALL ESPA TOOLS:
# Install dependencies:
install.packages("foreach")
install.packages("httr")
install.packages("jsonlite")
install.packages("parallel")
install.packages("rgdal")
install.packages("rgeos")
install.packages("sp")
install.packages("xml2")

# Install espa-tools from R-forge:
# Try this first:
install.packages("espa.tools", repos="http://R-Forge.R-project.org")

# If that doesn't work:
install.packages("devtools")
library("devtools")
# Install Tortoise SVN if on Windows:
# https://tortoisesvn.net/downloads.html
# Then:
install_svn("svn://r-forge.r-project.org/svnroot/espa-tools/pkg/espa.tools")