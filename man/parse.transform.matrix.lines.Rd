% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_fs_transform.R
\name{parse.transform.matrix.lines}
\alias{parse.transform.matrix.lines}
\title{Parse matrix from text file lines.}
\usage{
parse.transform.matrix.lines(file_lines, ignore_line_suffix = ";")
}
\arguments{
\item{file_lines}{vector of 3 character strings, the matrix lines. The separator is assumed to be a single space.}

\item{ignore_line_suffix}{character string, a line suffix that will be stripped from the end of each line if it exists.}
}
\value{
numerical 4x4 matrix, the parsed matrix
}
\description{
Parse matrix from text file lines.
}
\keyword{internal}
