context("Test HDF5array")

library(HDF5Array)

set.seed(12345)
L = ruvSimulate(m = 100, n = 1000, nc = 400, 
                nCelltypes = 3, nBatch = 2, 
                lambda = 0.1, sce = TRUE)

sce_matrix <- scMerge(
  sce_combine = L,
  ctl = paste0("gene",1:100),
  kmeansK = c(3, 3),
  cell_type = L$cellTypes,
  replicate_prop = 1,
  assay_name = 'matrix_output')

counts = assay(sce_matrix, "counts")
logcounts = assay(sce_matrix, "logcounts")
################################################

sce_hdf = sce_matrix
assay(sce_hdf, "counts") = as(counts, "HDF5Array")
assay(sce_hdf, "logcounts") = as(logcounts, "HDF5Array")

sce_hdf <- scMerge(
  sce_combine = sce_hdf,
  ctl = paste0("gene",1:100),
  kmeansK = c(3, 3),
  cell_type = sce_hdf$cellTypes,
  replicate_prop = 1,
  assay_name = 'hdf_output')

expect_identical(as.matrix(assay(sce_hdf, "hdf_output")), 
                 assay(sce_matrix, "matrix_output"))