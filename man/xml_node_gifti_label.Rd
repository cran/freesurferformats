% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gifti_xml_tools.R
\name{xml_node_gifti_label}
\alias{xml_node_gifti_label}
\title{Create XML GIFTI Label node.}
\usage{
xml_node_gifti_label(value, attributes = list(), as_cdata = TRUE)
}
\arguments{
\item{value}{the text contents of the node, usually the region name}

\item{attributes}{named list, the attributes}

\item{as_cdata}{logical, whether to wrap the value in cdata tags}
}
\value{
XML node from xml2
}
\description{
Create XML GIFTI Label node.
}
\keyword{internal}
