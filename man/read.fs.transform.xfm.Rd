% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_fs_transform.R
\name{read.fs.transform.xfm}
\alias{read.fs.transform.xfm}
\title{Load transformation matrix from an XFM file.}
\usage{
read.fs.transform.xfm(filepath)
}
\arguments{
\item{filepath}{character string, the full path to the transform file.}
}
\value{
4x4 numerical matrix, the transformation matrix
}
\description{
Load transformation matrix from an XFM file.
}
\note{
Currently this function has been tested with linear transformation files only, all others are unsupported.
}
\examples{
    tf_file = system.file("extdata", "talairach.xfm",
                               package = "freesurferformats",
                               mustWork = TRUE);
    transform = read.fs.transform.xfm(tf_file);
    transform$matrix;

}
\seealso{
Other header coordinate space: 
\code{\link{mghheader.is.ras.valid}()},
\code{\link{mghheader.ras2vox.tkreg}()},
\code{\link{mghheader.ras2vox}()},
\code{\link{mghheader.scanner2tkreg}()},
\code{\link{mghheader.tkreg2scanner}()},
\code{\link{mghheader.vox2ras.tkreg}()},
\code{\link{mghheader.vox2ras}()},
\code{\link{read.fs.transform.dat}()},
\code{\link{read.fs.transform.lta}()},
\code{\link{read.fs.transform}()},
\code{\link{sm0to1}()},
\code{\link{sm1to0}()}
}
\concept{header coordinate space}
