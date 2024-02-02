## ---- eval = FALSE------------------------------------------------------------
#      library("freesurferformats");
#      area = read.fs.morph(system.file("extdata", "lh.thickness", package = "freesurferformats", mustWork = TRUE));
#      thickness = read.fs.morph(system.file("extdata", "lh.area.gz", package = "freesurferformats", mustWork = TRUE));
#      mymorphdata = area * thickness;

## ---- eval = FALSE------------------------------------------------------------
#      format1 = write.fs.morph(tempfile(fileext = "mgz"), mymorphdata);
#      format2 = write.fs.morph(tempfile(fileext = "mgh"), mymorphdata);
#      format3 = write.fs.morph(tempfile(fileext = "curv"), mymorphdata);

## ---- eval = FALSE------------------------------------------------------------
#      mgh_outfile = "mystudy/subject1/mri/shifted_brain.mgz"
#      data = array(data=rep(1L, 256*256*256), dim=c(256,256,256)); # not exactly a brain, but will do.
#      mr_params = c(2300, 0.1, 2., 900.)
#      vox2ras_matrix = matrix(c(-1,0,0,0,  0,0,-1,0,  0,1,0,0,  127.5,-98.6273,79.0953,1.000), nrow=4, byrow = FALSE)
#      write.fs.mgh(mgh_outfile, data, vox2ras_matrix=vox2ras_matrix, mr_params=mr_params);

## ---- eval = FALSE------------------------------------------------------------
#      some_surface_mask = rep(1L, 163842);
#      some_surface_mask[30000:45000] = 0L;
#      write.fs.mgh("regionmask_stored_as_MRI_FLOAT.mgh", as.double(some_surface_mask));

## ---- eval = FALSE------------------------------------------------------------
#      data = rnorm(120000, 2.0, 1.0);
#      curvfile = "mystudy/subject1/surf/lh.random"
#      write.fs.curv(curvfile, data);

## ---- eval = FALSE------------------------------------------------------------
#      vertices = matrix(rep(0.3, 15), nrow=3);     # 5 vertices
#      faces = matrix(c(1L,2L,3L,2L,4L,3L,4L,5L,3L), nrow=3, byrow = TRUE);   # 3 faces
#  
#      write.fs.surface(tempfile(fileext="white"), vertices, faces);

## ---- eval = FALSE------------------------------------------------------------
#  output_file = tempfile();
#  
#  # generate data
#  vertex_indices = seq(from = 10000, to=20000);
#  
#  # write label to file
#  write.fs.label(output_file, vertex_indices);

## ---- eval = FALSE------------------------------------------------------------
#  colortable_df = data.frame("struct_index"=c(0, 1), "struct_name"=c("struct1", "struct2"),
#                    "r"=c(80, 100), "g"=c(50, 40), "b"=c(250, 200), "a"=c(0, 0), stringsAsFactors = FALSE);
#  
#  output_file = tempfile(fileext = ".txt");
#  write.fs.colortable(output_file, colortable_df);

