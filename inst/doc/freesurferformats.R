## ------------------------------------------------------------------------
    library("freesurferformats")
    curvfile = system.file("extdata", "lh.thickness", package = "freesurferformats", mustWork = TRUE)
    ct = read.fs.curv(curvfile)

## ------------------------------------------------------------------------
    cat(sprintf("Read data for %d vertices. Values: min=%f, mean=%f, max=%f.\n",  length(ct), min(ct), mean(ct), max(ct)))
    hist(ct, main="Histogram of cortical thickness for left hemisphere", xlab="Cortical thickness [mm]", ylab="Vertex count")

