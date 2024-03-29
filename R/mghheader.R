# Functions to derive information from the MGH header.

#' @title  Compute vox2ras matrix from basic MGH header fields.
#'
#' @description This is also known as the 'scanner' or 'native' vox2ras.  It is the inverse of the respective ras2vox, see \code{\link[freesurferformats]{mghheader.ras2vox}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @seealso \code{\link{sm0to1}}
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.vox2ras(vdh$header);
#'
#' @export
mghheader.vox2ras <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive vox2ras matrix.');
  }

  delta = c(header$internal$xsize, header$internal$ysize, header$internal$zsize);
  D = diag(delta);
  Mdc = matrix(c(header$internal$x_r, header$internal$x_a, header$internal$x_s, header$internal$y_r, header$internal$y_a, header$internal$y_s, header$internal$z_r, header$internal$z_a, header$internal$z_s), nrow=3, byrow = FALSE);
  Pcrs_c = c(header$internal$width/2, header$internal$height/2, header$internal$depth/2); # CRS of the center of the volume
  Pxyz_c = c(header$internal$c_r, header$internal$c_a, header$internal$c_s); # x,y,z at center of the volume
  Mdc_scaled = Mdc %*% D;
  Pxyz_0 = Pxyz_c - (Mdc_scaled %*% Pcrs_c); # the x,y,z location at CRS=0
  M = matrix(rep(0, 16), nrow=4);
  M[1:3,1:3] = as.matrix(Mdc_scaled);
  M[4,1:4] = c(0,0,0,1); # affine row
  M[1:3,4] = Pxyz_0;
  return(M);
}


#' @title Check whether header contains valid ras information
#'
#' @param header mgh header or `fs.volume` instance with header
#'
#' @return logical, whether header contains valid ras information (according to the `ras_good_flag`).
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.is.ras.valid(vdh$header);
#'
#' @export
mghheader.is.ras.valid <- function(header) {
  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(is.null(header)) {
    return(FALSE);
  }

  if(!is.list(header)) {
    return(FALSE); # most likely someone passed the raw volume data array instead of the volume.
  }

  if(is.null(header$ras_good_flag)) {
    return(FALSE);
  }

  if(header$ras_good_flag == 1L) {
    return(TRUE);
  }
  return(FALSE);
}


#' @title  Compute ras2vox matrix from basic MGH header fields.
#'
#' @description This is also known as the 'scanner' or 'native' ras2vox. It is the inverse of the respective vox2ras, see \code{\link[freesurferformats]{mghheader.vox2ras}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.ras2vox(vdh$header);
#'
#' @seealso \code{\link{sm1to0}}
#'
#' @export
mghheader.ras2vox <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive ras2vox matrix.');
  }

  return(solve(mghheader.vox2ras(header)));
}




#' @title  Compute vox2ras-tkreg matrix from basic MGH header fields.
#'
#' @description This is also known as the 'tkreg' vox2ras. It is the inverse of the respective ras2vox, see \code{\link[freesurferformats]{mghheader.ras2vox.tkreg}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.vox2ras.tkreg(vdh$header);
#'
#' @seealso \code{\link{sm0to1}}
#'
#' @export
mghheader.vox2ras.tkreg <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive vox2ras.tkreg matrix.');
  }

  header_copy = header; # copy the xsize, ysize, zsize

  # now set tkreg default orientation
  header_copy$internal$x_r = -1;
  header_copy$internal$y_r = 0;
  header_copy$internal$z_r = 0;
  header_copy$internal$c_r = 0.0;
  header_copy$internal$x_a = 0;
  header_copy$internal$y_a = 0;
  header_copy$internal$z_a = 1;
  header_copy$internal$c_a = 0.0;
  header_copy$internal$x_s = 0;
  header_copy$internal$y_s = -1;
  header_copy$internal$z_s = 0;
  header_copy$internal$c_s = 0.0;
  return(mghheader.vox2ras(header_copy));
}


#' @title  Compute ras2vox-tkreg matrix from basic MGH header fields.
#'
#' @description This is also known as the 'tkreg' ras2vox. It is the inverse of the respective vox2ras, see \code{\link[freesurferformats]{mghheader.vox2ras.tkreg}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.ras2vox.tkreg(vdh$header);
#'
#' @seealso \code{\link{sm1to0}}
#'
#' @export
mghheader.ras2vox.tkreg <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive ras2vox.tkreg matrix.');
  }

  return(solve(mghheader.vox2ras.tkreg(header)));
}


#' @title  Compute tkreg-RAS to scanner-RAS matrix from basic MGH header fields.
#'
#' @description This is also known as the 'tkreg2scanner' matrix. Note that this is a RAS-to-RAS matrix. It is the inverse of the 'scanner2tkreg' matrix, see \code{\link[freesurferformats]{mghheader.scanner2tkreg}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.tkreg2scanner(vdh$header);
#'
#' @export
mghheader.tkreg2scanner <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive tkreg2scanner matrix.');
  }

  vox2ras_native = mghheader.vox2ras(header);
  ras2vox_tkreg = mghheader.ras2vox.tkreg(header);
  tkreg2scanner = vox2ras_native %*% ras2vox_tkreg;
  return(tkreg2scanner);
}


#' @title  Compute scanner-RAS 2 tkreg-RAS matrix from basic MGH header fields.
#'
#' @description This is also known as the 'scanner2tkreg' matrix. Note that this is a RAS-to-RAS matrix. It is the inverse of the 'tkreg2scanner' matrix, see \code{\link[freesurferformats]{mghheader.tkreg2scanner}}.
#'
#' @param header the MGH header
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @family header coordinate space
#'
#' @examples
#'     brain_image = system.file("extdata", "brain.mgz",
#'                                package = "freesurferformats",
#'                                mustWork = TRUE);
#'     vdh = read.fs.mgh(brain_image, with_header = TRUE);
#'     mghheader.scanner2tkreg(vdh$header);
#'
#' @export
mghheader.scanner2tkreg <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    stop('MGH header does not contain valid RAS information. Cannot derive scanner2tkreg matrix.');
  }

  ras2vox = mghheader.ras2vox(header);
  vox2tkras = mghheader.vox2ras.tkreg(header);
  scanner2tkreg = vox2tkras %*% ras2vox;
  return(scanner2tkreg);
}


#' @title Compute vox2vox matrix between two volumes.
#'
#' @param header_from the MGH header of the source volume
#'
#' @param header_to the MGH header of the target volume
#'
#' @return 4x4 numerical matrix, the transformation matrix
#'
#' @export
mghheader.vox2vox <- function(header_from, header_to) {

  if(is.fs.volume(header_from)) {
    header_from = header_from$header;
  }

  if(!(mghheader.is.ras.valid(header_from))) {
    stop("MGH header of parameter 'header_from' does not contain valid RAS information. Cannot derive vox2vox matrix.");
  }

  if(is.fs.volume(header_to)) {
    header_to = header_to$header;
  }

  if(!(mghheader.is.ras.valid(header_to))) {
    stop("MGH header of parameter 'header_to' does not contain valid RAS information. Cannot derive vox2vox matrix.");
  }

  vox2ras_from = mghheader.vox2ras(header_from);
  ras2vox_to = mghheader.ras2vox(header_to);
  vox2vox = ras2vox_to %*% vox2ras_from;
  return(vox2vox);
}


#' @title Determine whether an MGH volume is conformed.
#'
#' @description In the FreeSurfer sense, *conformed* means that the volume is in coronal primary slice direction, has dimensions 256x256x256 and a voxel size of 1 mm in all 3 directions. The slice direction can only be determined if the header contains RAS information, if it does not, the volume is not conformed.
#'
#' @param header Header of the mgh datastructure, as returned by \code{\link[freesurferformats]{read.fs.mgh}}.
#'
#' @return logical, whether the volume is *conformed*.
#'
#' @export
mghheader.is.conformed <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    return(FALSE);
  }

  return(mgh.is.conformed(header));
}


#' @title Compute MGH primary slice direction
#'
#' @param header Header of the mgh datastructure, as returned by \code{\link[freesurferformats]{read.fs.mgh}}.
#'
#' @return character string, the slice direction. One of 'sagittal', 'coronal', 'axial' or 'unknown'.
#'
#' @export
mghheader.primary.slice.direction <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    return('unknown');
  }

  mdc = header$internal$Mdc;
  return(get.slice.orientation(mdc)$direction_name);
}


#' @title Compute MGH volume orientation string.
#'
#' @param header Header of the mgh datastructure, as returned by \code{\link[freesurferformats]{read.fs.mgh}}.
#'
#' @return character string of length 3, one uppercase letter per axis. Each of the three position is a letter from the alphabet: `LRISAP?`. The meaning is `L` for left, `R` for right, `I` for inferior, `S` for superior, `P` for posterior, `A` for anterior. If the direction cannot be computed, all three characters are `?` for unknown. Of course, each axis (`L/R`, `I/S`, `A/P`) is only represented once in the string.
#'
#' @export
mghheader.crs.orientation <- function(header) {

  if(is.fs.volume(header)) {
    header = header$header;
  }

  if(!(mghheader.is.ras.valid(header))) {
    return('???');
  }

  mdc = header$internal$Mdc;
  return(get.slice.orientation(mdc)$orientation_string);
}


#' @title Constructor to init MGH header instance.
#'
#' @param dims integer vector of length 4, the header dimensions. Example: \code{c(256L, 256L, 256L, 1L)}.
#'
#' @param mri_dtype_code integer, a valid MRI datatype. See \code{\link[freesurferformats]{translate.mri.dtype}}.
#'
#' @return a named list representing the header
#'
#' @keywords internal
mghheader <- function(dims, mri_dtype_code) {
  if(length(dims) != 4L) {
    stop("Parameter dims must have length 4.");
  }

  if(! is.integer(mri_dtype_code)) {
    stop("Parameter 'mri_dtype_code' must be an integer.");
  }

  dtype_name = translate.mri.dtype(mri_dtype_code); # The function is (ab)used to check the passed value, the return value is not used.
  dtype_name = NULL; # avoid IDE warnings about unused var.

  header = list();
  header$internal = list();
  header$dtype = mri_dtype_code;
  header$nbytespervox = mri_dtype_numbytes(mri_dtype_code);
  header$ras_good_flag = 0L;
  header$internal$width = dims[1];
  header$internal$height = dims[2];
  header$internal$depth = dims[3];
  header$internal$nframes = dims[4];

  header$voldim = c(dims[1], dims[2], dims[3], dims[4]);
  header$voldim_orig = header$voldim;

  #cat(sprintf("Created MGH header with dimensions %s.\n", paste(header$voldim, collapse="x")));

  header$has_mr_params = 0L;
  header$mr = list("tr"=0.0, "te"=0.0, "ti"=0.0, "flip_angle_degrees"=0.0, "fov"=0.0);

  class(header) = c('mghheader', class(header));
  return(header);
}


#' @title Update mghheader fields from vox2ras matrix.
#'
#' @param header Header of the mgh datastructure, as returned by \code{\link[freesurferformats]{read.fs.mgh}}.
#'
#' @param vox2ras 4x4 numerical matrix, the vox2ras transformation matrix.
#'
#' @return a named list representing the header
#'
#' @export
mghheader.update.from.vox2ras <- function(header, vox2ras) {

  # see mri.cpp MRIsetVox2RASFromMatrix

  updated_header = header;

  if(! is.matrix(vox2ras)) {
    stop("Parameter 'vox2ras' must be a numerical 4x4 matrix.");
  }

  rx = vox2ras[1, 1];
  ry = vox2ras[1, 2];
  rz = vox2ras[1, 3];
  ax = vox2ras[2, 1];
  ay = vox2ras[2, 2];
  az = vox2ras[2, 3];
  sx = vox2ras[3, 1];
  sy = vox2ras[3, 2];
  sz = vox2ras[3, 3];

  # The next 3 values encode the RAS coordinate of the first voxel, i.e., the voxel at CRS=c(1,1,1) in R-indexing or (0,0,0 in C-indexing).
  P0r = vox2ras[1, 4];
  P0a = vox2ras[2, 4];
  P0s = vox2ras[3, 4];

  xsize = sqrt(rx * rx + ax * ax + sx * sx);
  ysize = sqrt(ry * ry + ay * ay + sy * sy);
  zsize = sqrt(rz * rz + az * az + sz * sz);

  if(any(abs(c(xsize, ysize, zsize) - c(updated_header$internal$xsize, updated_header$internal$ysize, updated_header$internal$zsize)) > 0.001)) {
    message(sprintf("mghheader.update.from.vox2ras: Voxel sizes inconsistent, matrix may contain shear, which is not supported."));
  }

  updated_header$internal$x_r = rx / xsize;
  updated_header$internal$x_a = ax / xsize;
  updated_header$internal$x_s = sx / xsize;

  updated_header$internal$y_r = ry / ysize;
  updated_header$internal$y_a = ay / ysize;
  updated_header$internal$y_s = sy / ysize;

  updated_header$internal$z_r = rz / zsize;
  updated_header$internal$z_a = az / zsize;
  updated_header$internal$z_s = sz / zsize;

  updated_header$internal$Mdc = matrix(c(updated_header$internal$x_r, updated_header$internal$x_a, updated_header$internal$x_s, updated_header$internal$y_r, updated_header$internal$y_a, updated_header$internal$y_s, updated_header$internal$z_r, updated_header$internal$z_a, updated_header$internal$z_s), nrow = 3, byrow = FALSE);

  # Compute and set the RAS coordinates of the center voxel, given the RAS coordinates of the first voxel.
  updated_header$ras_good_flag = 1L;
  center_voxel_ras_coords = mghheader.centervoxelRAS.from.firstvoxelRAS(updated_header, c(P0r, P0a, P0s));
  updated_header$internal$c_r = center_voxel_ras_coords[1];
  updated_header$internal$c_a = center_voxel_ras_coords[2];
  updated_header$internal$c_s = center_voxel_ras_coords[3];

  return(updated_header);
}


#' @title Compute RAS coords of center voxel.
#'
#' @param header Header of the mgh datastructure, as returned by \code{\link[freesurferformats]{read.fs.mgh}}. The `c_r`, `c_a` and `c_s` values in the header do not matter of course, they are what is computed by this function.
#'
#' @param first_voxel_RAS numerical vector of length 3, the RAS coordinate of the first voxel in the volume. The first voxel is the voxel with `CRS=1,1,1` in R, or `CRS=0,0,0` in C/FreeSurfer. This value is also known as *P0 RAS*.
#'
#' @return numerical vector of length 3, the RAS coordinate of the center voxel. Also known as *CRAS* or *center RAS*.
#'
#' @export
mghheader.centervoxelRAS.from.firstvoxelRAS <- function(header, first_voxel_RAS) {

  if(length(first_voxel_RAS) != 3L) {
    stop("Parameter 'first_voxel_RAS' must be a numerical vector of length 3.");
  }

  # Set the missing header values to arbitrary values for now, if needed.
  if(is.null(header$internal$c_r)) {
    header$internal$c_r = 0.0;
  }
  if(is.null(header$internal$c_a)) {
    header$internal$c_a = 0.0;
  }
  if(is.null(header$internal$c_s)) {
    header$internal$c_s = 0.0;
  }

  incomplete_vox2ras = mghheader.vox2ras(header);
  incomplete_vox2ras[1, 4] = first_voxel_RAS[1];
  incomplete_vox2ras[2, 4] = first_voxel_RAS[2];
  incomplete_vox2ras[3, 4] = first_voxel_RAS[3];

  center_voxel_CRS = c(header$internal$width / 2.0, header$internal$height / 2.0, header$internal$depth / 2.0, 1.0);
  center_voxel_RAS = incomplete_vox2ras %*% center_voxel_CRS;
  return(center_voxel_RAS[1:3]);
}


#' @title Adapt spatial transformation matrix for 1-based indices.
#'
#' @param tf_matrix 4x4 numerical matrix, the input spatial transformation matrix, suitable for 0-based indices. Typically this is a vox2ras matrix obtained from functions like \code{\link{mghheader.vox2ras}}.
#'
#' @return 4x4 numerical matrix, adapted spatial transformation matrix, suitable for 1-based indices.
#'
#' @family header coordinate space
#'
#' @seealso \code{\link{sm1to0}} for the inverse operation
#'
#' @export
sm0to1 <- function(tf_matrix) {
  q = matrix(rep(0, 16L), ncol = 4L);
  q[1:3,4] = 1;
  return(solve(solve(tf_matrix + q)));
}


#' @title Adapt spatial transformation matrix for 0-based indices.
#'
#' @param tf_matrix 4x4 numerical matrix, the input spatial transformation matrix, suitable for 1-based indices.
#'
#' @return 4x4 numerical matrix, adapted spatial transformation matrix, suitable for 0-based indices.
#'
#' @family header coordinate space
#'
#' @seealso \code{\link{sm0to1}} for the inverse operation
#'
#' @export
sm1to0 <- function(tf_matrix) {
  q = matrix(rep(0, 16L), ncol = 4L);
  q[1:3,4] = -1;
  return(solve(solve(tf_matrix + q)));
}

#' @title Translate surface RAS coordinates, as used in surface vertices and surface labels, to volume RAS.
#'
#' @param header_cras an MGH header instance from which to extract the cras (center RAS), or the cras vector, i.e., a numerical vector of length 3
#'
#' @param sras_coords nx3 numerical vector, the input surface RAS coordinates. Could be the vertex coordinates of an 'fs.surface' instance, or the RAS coords from a surface label. Use the orig surfaces.
#'
#' @param first_voxel_RAS the RAS of the first voxel, see \code{\link{mghheader.centervoxelRAS.from.firstvoxelRAS}} for details. Ignored if 'header_cras' is a vector.
#'
#' @param invert_transform logical, whether to invert the transform. Do not use this, call \code{link{ras.to.surfaceras}} instead.
#'
#' @note The RAS can be computed from Surface RAS by adding the center RAS coordinates, i.e., it is nothing but a translation.
#'
#' @return the RAS coords for the input sras_coords
#' @export
surfaceras.to.ras <- function(header_cras, sras_coords, first_voxel_RAS=c(1, 1, 1), invert_transform = FALSE) {
  if(is.mghheader(header_cras)) {  # its an MGH header, compute the center RAS from it
    cras = mghheader.centervoxelRAS.from.firstvoxelRAS(header_cras, first_voxel_RAS);
  } else { # it is the center RAS already
    cras = header_cras;
  }
  tf = matrix(c(1, 0, 0, cras[1], 0, 1, 0, cras[2], 0, 0, 1, cras[3], 0, 0, 0, 1), ncol = 4, byrow = TRUE);
  if(invert_transform) {
    tf = solve(tf);
  }
  sras_coords_hom = cbind(sras_coords, 1);
  ras = t(tf %*% t(sras_coords_hom));
  return(ras[,1:3]);
}


#' @title Translate RAS coordinates, as used in volumes by applying vox2ras, to surface RAS.
#'
#' @inheritParams surfaceras.to.ras
#'
#' @param ras_coords nx3 numerical vector, the input surface RAS coordinates. Could be the vertex coordinates of an 'fs.surface' instance, or the RAS coords from a surface label.
#'
#' @note The RAS can be computed from Surface RAS by adding the center RAS coordinates, i.e., it is nothing but a translation.
#'
#' @return the surface RAS coords for the input RAS coords
#' @export
ras.to.surfaceras <- function(header_cras, ras_coords, first_voxel_RAS=c(1, 1, 1)) {
  return(surfaceras.to.ras(header_cras, ras_coords, first_voxel_RAS = first_voxel_RAS, invert_transform = TRUE));
}


#' @title Compute MNI talairach coordinates from RAS coords.
#'
#' @inheritParams ras.to.surfaceras
#' @inheritParams surfaceras.to.ras
#'
#' @note You can use this to compute the Talairach coordinate of a voxel, based on its RAS coordinate.
#'
#' @param talairach the 4x4 numerical talairach matrix, or a character string which will be interpreted as the path to an xfm file containing the matrix (typically `$SUBJECTS_DIR/$subject/mri/transforms/talairach.xfm`).
#'
#' @param invert_transform logical, whether to invert the transform. Do not use this, call \code{link{talairachras.to.ras}} instead.
#'
#' @return the Talairach RAS coordinates for the given RAS coordinates
#'
#' @export
ras.to.talairachras <- function(ras_coords, talairach, invert_transform = FALSE) {
  if(is.character(talairach)) {
    talairach = read.fs.transform(talairach)$matrix;
  }
  if(invert_transform) {
    talairach = solve(talairach);
  }
  ras_coords_hom = cbind(ras_coords, 1);
  mni_talairach = t(talairach %*% t(ras_coords_hom));
  return(mni_talairach[,1:3]);
}


#' @title Compute MNI talairach coordinates from RAS coords.
#'
#' @param tal_ras_coords coordinate matrix in Talairach RAS space
#'
#' @note You can use this to compute the Talairach coordinate of a voxel, based on its RAS coordinate.
#'
#' @param talairach the 4x4 numerical talairach matrix, or a character string which will be interpreted as the path to an xfm file containing the matrix (typically `$SUBJECTS_DIR/$subject/mri/transforms/talairach.xfm`).
#'
#' @return the Talairach RAS coordinates for the given RAS coordinates. They are based on a linear transform.
#'
#' @references see \url{https://en.wikipedia.org/wiki/Talairach_coordinates}
#'
#' @export
talairachras.to.ras <- function(tal_ras_coords, talairach) {
  return(ras.to.talairachras(tal_ras_coords, talairach, invert_transform = TRUE));
}


#' @title Compute Talairach RAS for surface RAS (e.g., vertex coordinates).
#'
#' @inheritParams talairachras.to.ras
#' @inheritParams surfaceras.to.ras
#'
#' @return The Talairach RAS coordinates for the vertices of the orig surfaces (or coords in surface RAS space). Based on linear transform.
#'
#' @export
surfaceras.to.talairach <- function(sras_coords, talairach, header_cras, first_voxel_RAS=c(1, 1, 1)) {
  ras = surfaceras.to.ras(header_cras = header_cras, sras_coords = sras_coords, first_voxel_RAS = first_voxel_RAS);
  talras = ras.to.talairachras(ras, talairach);
  return(talras);
}


#' @title Apply a spatial transformation matrix to the given coordinates.
#'
#' @param coords nx3 (cartesian) or nx4 (homogeneous) numerical matrix, the input coordinates. If nx4, left as is for homogeneous notation, if nx3 (cartesian) a 1 will be appended as the 4th position.
#'
#' @param mtx a 4x4 numerical transformation matrix
#'
#' @param as_mat logical, whether to force the output coords into a matrix (even if the input was a vector/a single coordinate triple).
#'
#' @return the coords after applying the transformation. If coords was nx3, nx3 is returned, otherwise nx4.
#'
#' @examples
#'     coords_tf = doapply.transform.mtx(c(1.0, 1.0, 1.0), mni152reg());
#'     coords_tf;
#'     doapply.transform.mtx(coords_tf, solve(mni152reg()));
#'
#' @export
doapply.transform.mtx <- function(coords, mtx, as_mat = FALSE) {
  if(is.vector(coords)) {
    coords = matrix(coords, nrow = 1L);
  }
  was_cartesian = FALSE;
  if(ncol(coords) == 3L) {
    was_cartesian = TRUE;
    coords = cbind(coords, 1.0);
  }

  if(ncol(coords) != 4L) {
    stop(sprintf("Parameter coords must have 3 or 4 colums (or 3 or 4 entries for a vector), found %d.\n", ncol(coords)));
  }

  if(any(coords[,4] == 0)) {
    warning("Invalid 'coords': last column must not be zero.");
  }

  transformed_coords = t(mtx %*% t(coords));
  if(was_cartesian) {
    transformed_coords = transformed_coords[,1:3] / transformed_coords[,4]; # convert from homogeneous to cartesian
  }
  if(is.vector(transformed_coords)) {
    if(as_mat) {
      transformed_coords = matrix(transformed_coords, ncol = 3, byrow = TRUE);
    }
  }
  return(transformed_coords);
}


#' @title Get fsaverage (MNI305) to MNI152 transformation matrix.
#'
#' @description The uses the 4x4 matrix from the FreeSurfer CoordinateSystems documentation.
#'
#' @note There are better ways to achieve this transformation than using this matrix, see Wu et al., 'Accurate nonlinear mapping between MNI volumetric and FreeSurfer surface coordinate system', Hum Brain Mapp. 2018 Sep; 39(9): 3793–3808. doi: 10.1002/hbm.24213. The mentioned method is available in R from the 'regfusionr' package (GitHub only atom, not on CRAN).
#'
#' @examples
#'     coords_tf = doapply.transform.mtx(c(10.0, -20.0, 35.0), mni152reg());
#'     coords_tf; #  10.695, -18.409, 36.137
#'     doapply.transform.mtx(coords_tf, solve(mni152reg()));
#'
#' @export
mni152reg <- function() {
  return(matrix(c(0.9975, -0.0073, 0.0176, -0.0429, 0.0146, 1.0009, -0.0024, 1.5496, -0.0130, -0.0093, 0.9971, 1.1840, 0, 0, 0, 1), ncol = 4, byrow = TRUE));
}

