% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_fs_surface.R
\name{write.fs.surface}
\alias{write.fs.surface}
\title{Write mesh to file in FreeSurfer binary surface format}
\usage{
write.fs.surface(filepath, vertex_coords, faces, format = "auto")
}
\arguments{
\item{filepath}{string. Full path to the output curv file. If it ends with ".gz", the file is written in gzipped format. Note that this is not common, and that other software may not handle this transparently.}

\item{vertex_coords}{n x 3 matrix of doubles. Each row defined the x,y,z coords for a vertex.}

\item{faces}{n x 3 matrix of integers. Each row defined the 3 vertex indices that make up the face. WARNING: Vertex indices should be given in R-style, i.e., the index of the first vertex is 1. However, they will be written in FreeSurfer style, i.e., all indices will have 1 substracted, so that the index of the first vertex will be zero.}

\item{format}{character string, the format to use. One of 'bin' for FreeSurfer binary surface format, 'asc' for FreeSurfer ASCII format, 'vtk' for VTK ASCII legacy format, 'ply' for Standford PLY format, 'off' for Object File Format, 'obj' for Wavefront object format, 'gii' for GIFTI format, 'mz3' for Surf-Ice MZ3 fomat, 'byu' for Brigham Young University (BYU) mesh format, or 'auto' to derive the format from the file extension given in parameter 'filepath'. With 'auto', a path ending in '.asc' is interpreted as 'asc', a path ending in '.vtk' as vtk, and so on for the other formats. Everything not matching any of these is interpreted as 'bin', i.e., FreeSurfer binary surface format.}
}
\value{
character string, the format that was written. One of "tris" or "quads". Currently only triangular meshes are supported, so always 'tris'.
}
\description{
Write vertex coordinates and vertex indices defining faces to a file in FreeSurfer binary surface format.
   For a subject (MRI image pre-processed with FreeSurfer) named 'bert', an example file would be 'bert/surf/lh.white'. This function writes the triangle version of the surface file format.
}
\examples{
\dontrun{
    # Read a surface from a file:
    surface_file = system.file("extdata", "lh.tinysurface",
     package = "freesurferformats", mustWork = TRUE);
    mesh = read.fs.surface(surface_file);

    # Now save it:
    write.fs.surface(tempfile(), mesh$vertices, mesh$faces);
}

}
\seealso{
Other mesh functions: 
\code{\link{faces.quad.to.tris}()},
\code{\link{read.fs.surface.asc}()},
\code{\link{read.fs.surface.bvsrf}()},
\code{\link{read.fs.surface.geo}()},
\code{\link{read.fs.surface.gii}()},
\code{\link{read.fs.surface.ico}()},
\code{\link{read.fs.surface.obj}()},
\code{\link{read.fs.surface.off}()},
\code{\link{read.fs.surface.ply}()},
\code{\link{read.fs.surface.vtk}()},
\code{\link{read.fs.surface}()},
\code{\link{read.mesh.brainvoyager}()},
\code{\link{read_nisurfacefile}()},
\code{\link{read_nisurface}()},
\code{\link{write.fs.surface.asc}()},
\code{\link{write.fs.surface.byu}()},
\code{\link{write.fs.surface.gii}()},
\code{\link{write.fs.surface.mz3}()},
\code{\link{write.fs.surface.vtk}()}

Other mesh export functions: 
\code{\link{write.fs.surface.obj}()},
\code{\link{write.fs.surface.off.ply2}()},
\code{\link{write.fs.surface.off}()},
\code{\link{write.fs.surface.ply2}()},
\code{\link{write.fs.surface.ply}()}
}
\concept{mesh export functions}
\concept{mesh functions}
