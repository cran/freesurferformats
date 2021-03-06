% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/brainvoyager.R
\name{bvsmp}
\alias{bvsmp}
\title{Create new bvsmp instance encoding morph data for Brainvoyager.}
\usage{
bvsmp(morph_data)
}
\arguments{
\item{morph_data}{numeric vector, the morphometry data to store in the bvsmp instance (one value per mesh vertex).}
}
\value{
bvsmp instance, can be used to write Brainvoyager SMP format morphometry files using \code{\link{write.smp.brainvoyager}}. Modify as needed before writing.
}
\description{
Create new bvsmp instance encoding morph data for Brainvoyager.
}
\examples{
   morph_data = rnorm(100L, 3.0, 1.0);
   mybvsmp = bvsmp(morph_data);
   mybvsmp$smp_version;

}
