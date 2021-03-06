% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gifti_xml_tools.R
\name{cdata}
\alias{cdata}
\title{Create CDATA element string from string.}
\usage{
cdata(string)
}
\arguments{
\item{string}{character string, the input string, freeform text. Must not contain the cdata start and end tags.}
}
\value{
character string, the input wrapped in the cdata tags
}
\description{
Create CDATA element string from string.
}
\note{
This returns a string, not an XML node. See \code{\link[xml2]{xml_cdata}} if you want a node.
}
