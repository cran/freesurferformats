## ------------------------------------------------------------------------
    library("freesurferformats")
    mgh_file = system.file("extdata", "brain.mgz", package = "freesurferformats", mustWork = TRUE)
    brain = read.fs.mgh(mgh_file)
    cat(sprintf("Read voxel data with dimensions %s. Values: min=%d, mean=%f, max=%d.\n", paste(dim(brain), collapse = 'x'), min(brain), mean(brain), max(brain)));

## ------------------------------------------------------------------------
    brain_with_hdr = read.fs.mgh(mgh_file, with_header = TRUE);
    brain = brain_with_hdr$data;   # as seen before, this is what we got in the last example (the data).
    header = brain_with_hdr$header;   # the header

## ---- eval = FALSE-------------------------------------------------------
#      header$dtype           # int, one of: 0=MRI_UCHAR; 1=MRI_INT; 3=MRI_FLOAT; 4=MRI_SHORT
#      header$ras_good_flag   # int, 0 or 1. Whether the file contains a valid vox2ras matrix and ras_xform (see header$vox2ras_matrix below)
#      header$has_mr_params   # int, 0 or 1. Whether the file contains mr_params (see header$mr_params below)
#      header$voldim          # integer vector or length 4. The volume (=data) dimensions. E.g., c(256, 256, 256, 1) for 3D data.
#  

## ------------------------------------------------------------------------
    if(header$has_mr_params) {
        mr_params = header$mr_params;  
        cat(sprintf("MR acquisition parameters: TR [ms]=%f, filp angle [radians]=%f, TE [ms]=%f, TI [ms]=%f\n", mr_params[1], mr_params[2], mr_params[3], mr_params[4]));
    }

## ------------------------------------------------------------------------
    if(header$ras_good_flag) {
        print(header$vox2ras_matrix);
    }

## ------------------------------------------------------------------------
    if(header$ras_good_flag) {
        print(header$ras_xform);
    }

## ---- eval = FALSE-------------------------------------------------------
#      mgh_file = system.file("mystudy", "subject1", "surf", "lh.thickness.fwhm25.fsaverage.mgh")
#      cortical_thickness_standard = read.fs.mgh(mgh_file)

## ---- eval = FALSE-------------------------------------------------------
#      oro.nifti::orthographic(oro.nifti::nifti(brain))

## ------------------------------------------------------------------------
    library("freesurferformats")
    curvfile = system.file("extdata", "lh.thickness", package = "freesurferformats", mustWork = TRUE)
    ct = read.fs.curv(curvfile)

## ------------------------------------------------------------------------
    cat(sprintf("Read data for %d vertices. Values: min=%f, mean=%f, max=%f.\n",  length(ct), min(ct), mean(ct), max(ct)))
    hist(ct, main="lh cortical thickness", xlab="Cortical thickness [mm]", ylab="Vertex count")

## ------------------------------------------------------------------------
    morphfile1 = system.file("extdata", "lh.thickness", package = "freesurferformats", mustWork = TRUE)
    thickness_native = read.fs.morph(morphfile1)

## ------------------------------------------------------------------------
    morphfile2 = system.file("extdata", "lh.curv.fwhm10.fsaverage.mgz", package = "freesurferformats", mustWork = TRUE)
    curv_standard = read.fs.morph(morphfile2)
    curv_standard[curv_standard < -1] = 0; # remove extreme outliers
    curv_standard[curv_standard > 1] = 0;
    hist(curv_standard, main="lh std curvature", xlab="Mean Curvature [mm^-1], fwhm10", ylab="Vertex count")

## ------------------------------------------------------------------------
    annotfile = system.file("extdata", "lh.aparc.annot.gz", package = "freesurferformats", mustWork = TRUE);
    annot = read.fs.annot(annotfile);

## ------------------------------------------------------------------------
    num_vertices_total = length(annot$vertices);
    for (vert_idx in c(1, 5000, 123456)) {
        cat(sprintf("Vertex #%d with zero-based index %d has label code '%d' which stands for atlas region '%s'\n", vert_idx, annot$vertices[vert_idx], annot$label_codes[vert_idx], annot$label_names[vert_idx]));
    }

## ------------------------------------------------------------------------
    ctable = annot$colortable$table;
    regions = annot$colortable$struct_names;
    for (region_idx in seq_len(annot$colortable$num_entries)) {
        cat(sprintf("Region #%d called '%s' has RGBA color (%d %d %d %d) and code '%d'.\n", region_idx, regions[region_idx], ctable[region_idx,1], ctable[region_idx,2], ctable[region_idx,3], ctable[region_idx,4], ctable[region_idx,5]));
    }

## ------------------------------------------------------------------------
    r_index = 50;                       # one-based index as used by R and Matlab
    fs_index = annot$vertices[r_index];  # zero-based index as used in C, Java, Python and many modern languages
    cat(sprintf("Vertex at R index %d has FreeSurfer index %d and lies in region '%s'.\n", r_index, fs_index, annot$label_names[r_index]));

## ------------------------------------------------------------------------
    region = "bankssts"
    thickness_in_region = thickness_native[annot$label_names == region]
    cat(sprintf("Region '%s' has %d vertices and a mean cortical thickness of %f mm.\n", region, length(thickness_in_region), mean(thickness_in_region)));

## ------------------------------------------------------------------------
    surface_file = system.file("extdata", "lh.tinysurface", package = "freesurferformats", mustWork = TRUE);
    surf = read.fs.surface(surface_file);
    cat(sprintf("Loaded surface consisting of %d vertices and %d faces.\n", nrow(surf$vertices), nrow(surf$faces)));

## ------------------------------------------------------------------------
    vertex_index = 5;
    v5 = surf$vertices[vertex_index,];
    cat(sprintf("Vertex %d has coordinates (%f, %f, %f).\n", vertex_index, v5[1], v5[2], v5[3]));

## ------------------------------------------------------------------------
    face_index = 2;
    f2 = surf$faces[face_index,];
    cat(sprintf("Face %d consistes of the vertices %d, %d, and %d.\n", face_index, f2[1], f2[2], f2[3]));

## ------------------------------------------------------------------------
    labelfile = system.file("extdata", "lh.entorhinal_exvivo.label", package = "freesurferformats", mustWork = TRUE);
    label = read.fs.label(labelfile);
    cat(sprintf("The label consists of %d vertices, the first one is vertex %d.\n", length(label), label[1]));

