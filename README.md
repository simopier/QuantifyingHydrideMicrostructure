# README document with important information

## Summary
This document contains important information on the content of the QuantifyingHydrideMicrostructure repository, and information on how to use the two MATLAB codes for Radial Hydride Fraction (RHF, Radial Hydride Continuous Path (RHCP), Hydride Continuity Coefficient (HCC), and Radial Hydride Continuous Factor (RHCF) to quantify hydride microstructures. 

## Outline
* 1. How to cite this work.
* 2. Description of the QuantifyingHydrideMicrostructure repository content.
* 3. Description of the MATLAB code for RHF.
* 4. Instructions on how to use the MATLAB code for RHF.
* 5. Decription of the MATLAB code for RHCP.
* 6. Instructions on how to use the MATLAB code for RHCP.
* 7. Decription of the MATLAB code for HCC.
* 8. Instructions on how to use the MATLAB code for HCC.
* 9. Decription of the MATLAB code for RHCF.
* 10. Instructions on how to use the MATLAB code for RHCF.
* 11. Instructions on how to use the GUI to binarize images.

## 1. How to cite this work.

When using this work, please appropriately cite the publication available [here]().

P.-C.A. Simon, C. Frank, L.-Q. Chen, M.R. Daymond, M.R. Tonks, A.T. Motta, Quantifying zirconium embrittlement due to hydride microstructure using image analysis. ----

## 2. Description of the QuantifyingHydrideMicrostructure repository content

* __HCC_MatLab_Code__ contains the MATLAB code for the Hydride Continuity Coefficient (HCC). 
* __RHCF_MatLab_Code__ contains the MATLAB code for the Radial Hydride Continuous Factor (RHCF).
* __RHCP_MatLab_Code__ contains the MATLAB code for the Radial Hydride Continuous Path (RHCP).
* __RHCP_Validation_Measurements__ contains the instructions to perform the validation of the MATLAB implementation of the RHCP.  
* __RHCP_Validation_Microstructures__ contains the microstructures for the validation of the MATLAB implementation of the RHCP.  
* __RHF_MatLab_Code__ contains the MATLAB code for the Radial Hydride Fraction (RHF).
* __RHF_Validation_Measurements__ contains the instructions to perform the validation of the MATLAB implementation of the RHF.
* __RHF_Validation_Microstructures__ contains the microstructures for the validation of the MATLAB implementation of the RHF. 
* __License.md__ contains the license for this repository.
* __README.md__ is the current document with information on the content of the QuantifyingHydrideMicrostructure repository, and information on how to use the two MATLAB codes for Radial Hydride Fraction (RHF), Radial Hydride Continuous Path (RHCP), Hydride Continuity Coefficient (HCC), and Radial Hydride Continuous Factor (RHCF) to quantify hydride microstructures.

## 3. Description of the MATLAB code for RHF.

The MATLAB code for the RHF is available [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHF_MatLab_Code).

The list of the files and their purpose is available below, along with a diagram showing the code architecture. 

* __RHF_main.m__ is the main function of the software. It initializes the workspace, determines the images resolution, launches image binarization, and launches the analysis using sub-functions.
* __RHF_folder.m__ is called by RHF_main and calls RHF_file for each microstructure to measure its RHF.
* __RHF_file.m__ is called by RHF_folder and measures the RHF of the microstructure given as input.
* __RHFCalculation.m__ is called by RHF_file and derives the RHF value of a hydride given its vertical and horizontal projected lengths.
* __Total_H_Length.m__ is called by RHF_file and determines the length of a hydride.
* __cleanWorkSpace.m__ clears the command window, closes all windows, and erases all existing variables in MATLAB. 
* __dir2.m__ provides information on the directory given as input. The list of file names, in particular.
* __imageBinary_folder.m__ is called by the main function of the algorithm and calls imageBinary.m to binarize the microstructures.
* __imageBinary.m__ is called by imageBinary_folder.m and calls thershold.m, the GUI function, to let the user select the appropriate binarization parameters.
* __threshold.m__ is called by imageBinary.m. It takes a greyscale .tif image and opens the GUI to help the user binarize the image. 
* __threshold.fig__ is the GUI to help the user binarize the image.
* __imageResolution.m__ defines the resolution of the images.
* __RHF_Verification_Script.m__ is the script used to perform the verification of the RHF definition and implementation. Run this script to reproduce the verification process.
* __RHF_Verification.m__ is used for the verification of the RHF definition and implementation. It is called by RHF_Verification_Script.m.
* __plotVerification.m__ is used for the verification of the RHF definition and implementation. It is called by RHF_Verification_Script.m to perform the analysis.
* __Validation_Measurements_Analysis.m__ is for RHF Validation. Analyzes the MATLAB and ImageJ measurements and produces statistical figures.
* __RHF_validation__ is used for the validation of the RHF method. It reads the results derived from MATLAB and compared them with the values measured using ImageJ


| Diagram of the code architecture           |
|-----------------------------------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHF_MatLab_Code/RHF_architecture.png" width="1000"> | 


## 4. Instructions on how to use the MATLAB code for RHF.
## 5. Decription of the MATLAB code for RHCP.
The MATLAB code for the RHCP is available [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHCP_MatLab_Code).

The list of the files and their purpose is available below, along with a diagram showing the code architecture. 

* __RHCP_main.m__ is the main function of the software. It initializes the workspace, determines the images resolution, launches image binarization, and launches the analysis using sub-functions.
* __RHCP_folder.m__ is called by RHF_main and calls RHF_file for each microstructure to measure its RHF.
* __RHCP_file.m__ is called by RHF_folder and measures the RHF of the microstructure given as input.
* __PrimaryNodes.m__ determines the position of the primary nodes, which are the nodes that are part of the genome.
* __RandomPathsGenerator.m__ generates a fixed number of random paths across the microstructure.
* __PlaceGuideNodes.m__ places the guide nodes in straight lines between the primary nodes.
* __EvalPaths.m__ derives the RHCP_x value for each paths.
* __GeneticAlgorithm.m__ is the main part of the genetic algorithm section of the algorithm. It takes an initial generation of paths and successively generates children paths that will replace their parents when they improve the population. A child is created by combining the nodes of two parent paths. A child improves the population when its RHCP_x value is better than one of its parents. The algorithm stops when one of the user-defined convergence criteria is met. 
* __ImprovePaths.m__ calls SmoothPaths.m and ZigZag.m to improve the existing paths.
* __SmoothPaths.m__ SmoothPaths takes the nodes of all paths described by nodes and the binary image, and makes sure that the paths go straight within each phase.
* __ZigZag.m__ takes the paths and the binaryImage and removes parts of the paths that go in and out of the ZrH phase to make the path more direct.
* __completePath.m__ completes the path between the current point and the aim point, and returns the updated path
* __bridgeBands.m__ is called by RHCP_file and creates new paths from the two best paths from the populations from two different bands. It creates new paths by merging the paths when they touch, or when the is enough hydride pixels between them. 
* __Annealing.m__ is an annealing algorithm called by RHCP_file to refine best path.
* __plotAcceptance.m__ plots and saves the evolution of the acceptance rate for new paths.
* __plotEval.m__ plots the evolution of the paths evaluations (min, max, median, mean).
* __plotPaths.m__ plots the current paths on the micrographs. 
* __cleanWorkSpace.m__ clears the command window, closes all windows, and erases all existing variables in MATLAB. 
* __dir2.m__ provides information on the directory given as input. The list of file names, in particular.
* __imageBinary_folder.m__ is called by the main function of the algorithm and calls imageBinary.m to binarize the microstructures.
* __imageBinary.m__ is called by imageBinary_folder.m and calls thershold.m, the GUI function, to let the user select the appropriate binarization parameters.
* __threshold.m__ is called by imageBinary.m. It takes a greyscale .tif image and opens the GUI to help the user binarize the image. 
* __threshold.fig__ is the GUI to help the user binarize the image.
* __imageResolution.m__ defines the resolution of the images.
* __Validation_Measurements_Analysis.m__ analyzes the MATLAB and ImageJ measurements and produces statistical figures.
* __Validation_User_paths_evaluation.m__ analyzes the ImageJ measurements made by users to derive the paths positions, as well as its RHCP value.
* __Verification_Continuity_script.m__ is a script that defines the parameters for the verification of the RHCP code
* __Verification_Continuity.m__ performs the verification of the HCC, RHCF, RHCP codes on the verification microstructures.
* __Verification_Plot_Best_Paths_Figures.m__ Plot on the same figure the microstructure and the two best paths derived with two different definitions of RHCP.

| Diagram of the code architecture           |
|-----------------------------------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_MatLab_Code/RHCP_architecture.png" width="1000"> | 
## 6. Instructions on how to use the MATLAB code for RHCP.
## 7. Decription of the MATLAB code for HCC.
The MATLAB code for the HCC is available [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/HCC_MatLab_Code).

The list of the files and their purpose is available below, along with a diagram showing the code architecture. 

* __HCC_main.m__ is the main function of the software. It initializes the workspace, determines the images resolution, launches image binarization, and launches the analysis using sub-functions.
* __HCC_folder.m__ is called by HCC_main and calls HCC_file for each microstructure to measure its HCC.
* __HCC_file.m__ is called by HCC_folder and measurses the HCC of the microstructure given as input.
* __HydrideSegments.m__ is called by HCC_file and measures the length of the projected hydrides. It also filters out hydrides that are too small to be taken into account.
* __cleanWorkSpace.m__ clears the command window, closes all windows, and erases all existing variables in MATLAB. 
* __dir2.m__ provides information on the directory given as input. The list of file names, in particular.
* __imageBinary_folder.m__ is called by the main function of the algorithm and calls imageBinary.m to binarize the microstructures.
* __imageBinary.m__ is called by imageBinary_folder.m and calls thershold.m, the GUI function, to let the user select the appropriate binarization parameters.
* __threshold.m__ is called by imageBinary.m. It takes a greyscale .tif image and opens the GUI to help the user binarize the image. 
* __threshold.fig__ is the GUI to help the user binarize the image.
* __imageResolution.m__ defines the resolution of the images.


| Diagram of the code architecture           |
|-----------------------------------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/HCC_MatLab_Code/HCC_architecture.png" width="1000"> | 


## 8. Instructions on how to use the MATLAB code for HCC.
## 9. Decription of the MATLAB code for RHCF.
The MATLAB code for the RHCF is available [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHCF_MatLab_Code).

The list of the files and their purpose is available below, along with a diagram showing the code architecture. 

* __RHCF_main.m__ is the main function of the software. It initializes the workspace, determines the images resolution, launches image binarization, and launches the analysis using sub-functions.
* __RHCF_folder.m__ is called by RHCF_main and calls RHCF_file for each microstructure to measure its RHCF.
* __RHCF_file.m__ is called by RHCF_folder and measurses the RHCF of the microstructure given as input.
* __HydrideSegments.m__ is called by RHCF_file and measures the length of the projected hydrides. It also filters out hydrides that are too small to be taken into account.
* __cleanWorkSpace.m__ clears the command window, closes all windows, and erases all existing variables in MATLAB. 
* __dir2.m__ provides information on the directory given as input. The list of file names, in particular.
* __imageBinary_folder.m__ is called by the main function of the algorithm and calls imageBinary.m to binarize the microstructures.
* __imageBinary.m__ is called by imageBinary_folder.m and calls thershold.m, the GUI function, to let the user select the appropriate binarization parameters.
* __threshold.m__ is called by imageBinary.m. It takes a greyscale .tif image and opens the GUI to help the user binarize the image. 
* __threshold.fig__ is the GUI to help the user binarize the image.
* __imageResolution.m__ defines the resolution of the images.


| Diagram of the code architecture           |
|-----------------------------------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCF_MatLab_Code/RHCF_architecture.png" width="1000"> | 

## 10. Instructions on how to use the MATLAB code for RHCF.
##11. Instructions on how to use the GUI to binarize images.

