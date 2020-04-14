## ---- eval = FALSE------------------------------------------------------------
#      library("freesurferformats");
#      mgh_file = system.file("extdata", "brain.mgz", package = "freesurferformats", mustWork = TRUE);
#      brain = read.fs.mgh(mgh_file, with_header = TRUE);

## ---- eval = FALSE------------------------------------------------------------
#  mghheader.is.ras.valid(brain$header);

## ---- eval = FALSE------------------------------------------------------------
#  voxel = c(128, 128, 128);
#  vox2ras = mghheader.vox2ras(brain);
#  ras_coords = vox2ras %*% c(voxel, 1);  # the 1 is because we use homogeneous coordinates

## ---- eval = FALSE------------------------------------------------------------
#  mghheader.primary.slice.direction(brain);

## ---- eval = FALSE------------------------------------------------------------
#  mghheader.crs.orientation(brain);

## ---- eval = FALSE------------------------------------------------------------
#  mghheader.is.conformed(brain);

