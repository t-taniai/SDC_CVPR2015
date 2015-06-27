# Superdifferential Cuts for Binary Energies

## ABOUT THIS SOFTWARE
This software implements the binary energy minimization method presented in

> [1]  "Superdifferential Cuts for Binary Energies"  
>      Tatsunori Taniai, Yasuyuki Matsushita, and Takeshi Naemura  
>      In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2015)  
>      pp.2030--2038, Boston MA, US, June 2015.  

If you use this software for research purposes, you should cite
the aforementioned paper in any resulting publication.


## HOW TO USE
You need to additionally download the following data and code:

1. GrabCut Dataset  
   Available at http://research.microsoft.com/en-us/um/cambridge/projects/visionimagevideoediting/segmentation/grabcut.htm

2. MATLAB Wrapper of the Boykov-Kolmogorov max-flow min-cut algorithm  
   Availabe at http://vision.csd.uwo.ca/code/

Modify the file paths in Run_Benchmark.m and run it.
Note that this code may produce slightly different results from the ones originally reported in [1], 
where another C++ implementation was used.


## FEATURES
Currently the code only implements the histogram matching segmentation using L1 and L2-distance (Type-1).
Algorithms for Type-2 (fractional higher-order energies) and Type-3 (pairwise non-submodular energies)
will be implemented in the future.


## HISTORY
#### v.1.0.0	(06/26/2015)  
- Released the MATLAB implementation for the Type-1 algorithm.

Copyright (c) Tatsunori Taniai  All Rights Reserved.
