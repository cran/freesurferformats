
test_that("One can write triangular surface data", {
  vertex_coords = matrix(seq(1, 15)+0.5, ncol=3, byrow=TRUE);
  faces = matrix(c(1L,2L,3L,2L,4L,3L,4L,5L,3L), nrow=3, byrow = TRUE);

  format_written = write.fs.surface(tempfile(fileext="white"), vertex_coords, faces);
  expect_equal(format_written, "tris");
})

test_that("One can write and re-read triangular surface data", {
  vertex_coords = matrix(seq(1, 15)+0.5, nrow=5, ncol=3, byrow=TRUE);
  faces = matrix(c(1L,2L,3L,2L,4L,3L,4L,5L,3L), nrow=3, ncol=3, byrow = TRUE);

  tmp_file = tempfile(fileext="white");
  format_written = write.fs.surface(tmp_file, vertex_coords, faces);

  # Write a test file to a permanent location to manually check with freeview whether it gets read correctly ('freeview -f <file>').
  #format_written = write.fs.surface("/home/spirit/test.tiny.white", vertex_coords, faces);

  expect_equal(format_written, "tris");

  surf = read.fs.surface(tmp_file);
  expect_equal(surf$internal$num_vertices_expected, 5)
  expect_equal(surf$internal$num_faces_expected, 3)
  expect_equal(nrow(surf$vertices), nrow(vertex_coords));

  expect_equal(typeof(surf$faces), "integer");
  expect_equal(typeof(surf$vertices), "double");

  expect_equal(nrow(surf$faces), nrow(faces));
  expect_equal(surf$mesh_face_type, "tris");

  expect_equal(surf$vertices, vertex_coords);
  expect_equal(surf$faces, faces);

})

test_that("One can read, write and re-read triangular surface data", {

  skip_if(tests_running_on_cran_under_macos(), message = "Skipping on CRAN under MacOS, required test data cannot be downloaded.");
  testthat::skip_on_cran(); # cannot download testdata on CRAN.
  freesurferformats::download_opt_data();
  subjects_dir = freesurferformats::get_opt_data_filepath("subjects_dir");
  surface_file = file.path(subjects_dir, "subject1", "surf", "lh.white");

  skip_if_not(file.exists(surface_file), message="Test data missing.");

  surf = read.fs.surface(surface_file);

  tmp_file = tempfile(fileext="white");
  format_written = write.fs.surface(tmp_file, surf$vertices, surf$faces);

  # One should also write the file to some permament location and manually ensure that freeview will open it correctly ('freeview -f <file>'):
  #format_written = write.fs.surface("/home/spirit/test.lh.white", surf$vertices, surf$faces);

  expect_equal(format_written, "tris");

  surf_re = read.fs.surface(tmp_file);
  expect_equal(surf$internal$num_vertices_expected, surf_re$internal$num_vertices_expected);
  expect_equal(surf$internal$num_faces_expected, surf_re$internal$num_faces_expected);
  expect_equal(nrow(surf$vertices), nrow(surf_re$vertices));
  expect_equal(nrow(surf$faces), nrow(surf_re$faces));
  expect_equal(surf$mesh_face_type, "tris");
  expect_equal(surf$mesh_face_type, surf_re$mesh_face_type);

  expect_equal(surf$vertices, surf_re$vertices);
  expect_equal(surf$faces, surf_re$faces);
})


test_that("Surface files in VTK format can be read and written", {

  surface_file = system.file("extdata", "lh.tinysurface", package = "freesurferformats", mustWork = TRUE);
  surf = read.fs.surface(surface_file);

  tmp_vtk_file = tempfile(fileext=".vtk");
  write.fs.surface.vtk(tmp_vtk_file, surf$vertices, surf$faces);

  surf_re = read.fs.surface(tmp_vtk_file);
  expect_equal(surf$vertices, surf_re$vertices);
  expect_equal(surf$faces, surf_re$faces);
})


test_that("One can export surface meshes in OFF, OBJ, PLY2 and PLY formats", {

  surface_file = system.file("extdata", "lh.tinysurface", package = "freesurferformats", mustWork = TRUE);
  mesh = read.fs.surface(surface_file);

  # Standford PLY format without vertex colors
  write.fs.surface.ply(tempfile(fileext=".ply"), mesh$vertices, mesh$faces);

  # PLY with vertex colors
  vertex_colors = matrix(rep(82L, 5*4), ncol=4);    # the mesh contains 5 verts
  write.fs.surface.ply(tempfile(fileext=".ply"), mesh$vertices, mesh$faces, vertex_colors=vertex_colors);

  # OFF, the Object File Format
  write.fs.surface.off(tempfile(fileext=".off"), mesh$vertices, mesh$faces);

  # PLY2 format, very similar to OFF.
  write.fs.surface.ply2(tempfile(fileext=".ply2"), mesh$vertices, mesh$faces);

  # Wavefront OBJ format
  write.fs.surface.obj(tempfile(fileext=".obj"), mesh$vertices, mesh$faces);

  # FreeSurfer ASCII surface format
  write.fs.surface.asc(tempfile(fileext=".fsascii"), mesh$vertices, mesh$faces);

  # GIFTI surface format
  write.fs.surface.gii(tempfile(fileext=".gii"), mesh$vertices, mesh$faces);

  # MZ3 surface format
  write.fs.surface.mz3(tempfile(fileext=".mz3"), mesh$vertices, mesh$faces);

  # BYU surface format
  write.fs.surface.byu(tempfile(fileext=".byu"), mesh$vertices, mesh$faces);

  # currently this test only ensures that the functions run without error, the output is not checked in detail yet.
  # You can import the PLY and OBJ files into Blender, btw.
  expect_equal(1L, 1L);
})


test_that("One can export and re-read surface meshes in PLY format", {
  surface_file = system.file("extdata", "lh.tinysurface", package = "freesurferformats", mustWork = TRUE);
  mesh = read.fs.surface(surface_file);

  # Standford PLY format without vertex colors
  ply_file = tempfile(fileext=".ply");
  write.fs.surface.ply(ply_file, mesh$vertices, mesh$faces);

  mesh_reread = read.fs.surface.ply(ply_file);
  expect_equal(mesh$vertices, mesh_reread$vertices);
  expect_equal(mesh$faces, mesh_reread$faces);

  # PLY with vertex colors
  vertex_colors = matrix(rep(82L, 5*4), ncol=4);    # the mesh contains 5 verts
  ply_col_file = tempfile(fileext=".ply");
  write.fs.surface.ply(ply_col_file, mesh$vertices, mesh$faces, vertex_colors=vertex_colors);

  col_mesh_reread = read.fs.surface.ply(ply_col_file);
  expect_equal(mesh$vertices, col_mesh_reread$vertices);
  expect_equal(mesh$faces, col_mesh_reread$faces);
})



test_that("One can write meshes in all formats directly from write.fs.surface", {

  surface_file = system.file("extdata", "lh.tinysurface", package = "freesurferformats", mustWork = TRUE);
  mesh = read.fs.surface(surface_file);

  # Standford PLY format
  write.fs.surface(tempfile(fileext=".ply"), mesh$vertices, mesh$faces);

  # OFF, the Object File Format
  write.fs.surface(tempfile(fileext=".off"), mesh$vertices, mesh$faces);

  # PLY2 format, very similar to OFF.
  write.fs.surface(tempfile(fileext=".ply2"), mesh$vertices, mesh$faces);

  # Wavefront OBJ format
  write.fs.surface(tempfile(fileext=".obj"), mesh$vertices, mesh$faces);

  # FreeSurfer ASCII surface format
  write.fs.surface(tempfile(fileext=".asc"), mesh$vertices, mesh$faces);

  # GIFTI surface format
  write.fs.surface(tempfile(fileext=".gii"), mesh$vertices, mesh$faces);

  # MZ3 surface format
  write.fs.surface(tempfile(fileext=".mz3"), mesh$vertices, mesh$faces);

  # BYU surface format
  write.fs.surface(tempfile(fileext=".byu"), mesh$vertices, mesh$faces);

  # VTK format
  write.fs.surface(tempfile(fileext=".vtk"), mesh$vertices, mesh$faces);

  # error on invalid format
  expect_error(write.fs.surface(tempfile(fileext=".vtk"), mesh$vertices, mesh$faces, format = "invalid format")); # invalid format

})
