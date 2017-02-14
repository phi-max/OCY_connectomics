# Osteocyte Connectomics
This is the _MATLAB_ code used to produce all data plots in the paper __"The small world of osteocytes: connectomics of the osteocyte lacuno-canalicular network"__ from the raw confocal image data.

## Dependencies
The following external dependencies need to be in your MATLAB path:

- _Skeleton3D_ (https://github.com/phi-max/skeleton3d-matlab)
- _Skel2Graph3D_ (https://github.com/phi-max/skel2graph3d-matlab)
- _MatlabBGL_ by David Gleich (https://github.com/dgleich/matlab-bgl/)

## Raw data
The data for the paper are available on Zenodo (coming soon).

## How to run
Two scripts need to be called to generate the plots. All other `.m` files and external dependencies (see above) must be on your _MATLAB_ path. The data should be located in the current working directory.

1. `OCY_analyze_all.m`: main script to analyze data, using parallel pool if available.
2. `OCY_generate_figures.m`: collects analyzed data from subfolders and generates the plots.

## Data structures
Data structures are saved as `.mat` files of the same name as the variable in each folder.

- **bin_thr**: Binary image volume after smoothing and thresholding.
- **bin**: Binary image volume after morphological filtering.
- **cell**: Binary volume containing only the cells.
- **skel_ini**: Initial result of 3D thinning.
- **skel**: Final result of 3D thinning after filtering and cleaning.
- **dist**: Distance transform of the complete network.
- **celldist**: Distance transform of the cells only.
- **didx**: Index of the closest canalicular voxel.
- **node**: Struct containing all nodes with their properties.
- **link**: Struct containing all links with their properties.
- **cell**: Struct containing all cells with their properties.
- **A**: Connectivity matrix, where A<sub>ij</sub> ist the length of a link between nodes i and j.
- **n**: Struct containing the results of the topological analysis.
