## ---- eval = FALSE-------------------------------------------------------
#      library("freesurferformats");
#      area = read.fs.morph(system.file("extdata", "lh.thickness", package = "freesurferformats", mustWork = TRUE));
#      thickness = read.fs.morph(system.file("extdata", "lh.area.gz", package = "freesurferformats", mustWork = TRUE));
#      mymorphdata = area * thickness;

## ---- eval = FALSE-------------------------------------------------------
#      format1 = write.fs.morph(tempfile(fileext = "mgz"), mymorphdata);
#      format2 = write.fs.morph(tempfile(fileext = "mgh"), mymorphdata);
#      format3 = write.fs.morph(tempfile(fileext = "curv"), mymorphdata);

## ---- eval = FALSE-------------------------------------------------------
#      mgh_outfile = "mystudy/subject1/mri/shifted_brain.mgz"
#      data = array(data=rep(1L, 256*256*256), dim=c(256,256,256)); # not exactly a brain, but will do.
#      mr_params = c(2300, 0.1, 2., 900.)
#      vox2ras_matrix = matrix(c(-1,0,0,0,  0,0,-1,0,  0,1,0,0,  127.5,-98.6273,79.0953,1.000), nrow=4, byrow = FALSE)
#      write.fs.mgh(mgh_outfile, data, vox2ras_matrix=vox2ras_matrix, mr_params=mr_params);

## ---- eval = FALSE-------------------------------------------------------
#      data = rnorm(120000, 2.0, 1.0);
#      curvfile = "mystudy/subject1/surf/lh.random"
#      write.fs.curv(curvfile, data);

