# README document with important information

## Summary
This document contains important information on the content of the QuantifyingHydrideMicrostructure repository, and information on how to use the two MATLAB codes for Radial Hydride Fraction (RHF, Radial Hydride Continuous Path (RHCP), Hydride Continuity Coefficient (HCC), and Radial Hydride Continuous Factor (RHCF) to quantify hydride microstructures. 

## Outline
* 1. How to cite this work.
* 2. Description of the QuantifyingHydrideMicrostructure repository content.
* 3. Prerequisite to use the MATLAB Code.
* 4. Description of the MATLAB code for RHF.
* 5. Instructions on how to use the MATLAB code for RHF.
* 6. Decription of the MATLAB code for RHCP.
* 7. Instructions on how to use the MATLAB code for RHCP.
* 8. Decription of the MATLAB code for HCC.
* 9. Instructions on how to use the MATLAB code for HCC.
* 10. Decription of the MATLAB code for RHCF.
* 11. Instructions on how to use the MATLAB code for RHCF.
* 12. Instructions on how to use the GUI to binarize images.

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

## 3. Prerequisite to use the MATLAB Code.

#### 1. Download MATLAB
* As a PennState student, you can download MATLAB [here](https://softwarestore.psu.edu/mathworks-license/-8474).
* As a student, you can download MATLAB [here](https://www.mathworks.com/products/matlab/student.html).
* You can download MATLAB [here](https://www.mathworks.com/products/get-matlab.html?s_tid=gn_getml).

* __When selecting the toolboxes, install the Image Processing Toolbox, which will be used by the software.__ 

To test if the image processing toolbox is installed in MATLAB, you can open MATLAB and copy and run the following lines in the MATLAB console:
```
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway (Not recommended, as this will not work)? \n To install the toolbox, if you have a recent version, on the main MATLAB window, go to __Home>Adds-Ons>Get Adds-Ons__ and find the Image processing toolbox. Otherwise, visit: https://www.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
else
 message = sprintf('You have the the Image Processing Toolbox.');
end
```
To install the toolbox, if you have a recent version, on the main MATLAB window, go to __Home>Adds-Ons>Get Adds-Ons__ and find the Image processing toolbox. Otherwise, visit [this page](https://www.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab) for instructions.

#### 2. Download the repository or the specific MATLAB code you want to use
You can download the repository [here](https://github.com/simopier/QuantifyingHydrideMicrostructure).

When the running the code, if you are getting error messages involving 'imcomplement', you might have to reinstall the image processing toolbox as described above in __3-1. Download MATLAB__.

## 4. Description of the MATLAB code for RHF.

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


## 5. Instructions on how to use the MATLAB code for RHF.

#### 1. Save your micrographs

If you want to use the RHCP code, I imagine that you have micrgraphs that you would like to analyze. Save these micrographs as greyscale '.tif' file in a folder sitting next to the __RHF_MatLab_code__ folder you downloaded at step *5.2. Download the repository or the specific MATLAB code you want to use*.

#### 4. Open MATLAB
Open the file called __RHF_main.m__ and make sure that MATLAB is open in the code folder.

#### 5. Launch the RHF code
To launch the code, you need to call the function __RHF_main__ with the appropriate inputs:
```
RHF_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,lengthCut,resultsFolderName)
```
with:
- codeFolderName: The name of the folder in which the RHF code is stored.
- imageFolderName: The name of the folder in which images are stored.
- startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
- startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
- SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- resolution: The image resolution  in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
- lengthCut: The length used to cut the hydrides to approximate them a straight lines. Use InF to select the whole hydrides.
- resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

An example of a call is:

```
RHF_main('RHF_MatLab_Code','RHF_Validation_Microstructures',240,255,90,10,0,Inf,'RHF_Validation_Results')
```
#### 6. Binarize the microstructures
*The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 

To use the GUI, you can refer to section *12 .Instructions on how to use the GUI to binarize images.* of this document. You will be asked to define the binarization parameters for each micrograph in the image folder.  

#### 7. Monitor the algorithm
Once you are done binarizing the micrographs, the MATLAB code will start the analysis. At this point, you do not need to do anything since the analysis is automated.

#### 8. Analyze results
To analyze the results, go to the result folder, which name you defined in resultsFolderName at step *3. Launch the RHF code.*.

You should find:
* a .csv file with the name of the result folder, which contains the list of the names of the micrographs with their corresponding RHF.
* for each micrograph:
  * a .csv file containing the binary parameters, ending with *_BinaryParam.csv*.
  * a .tif and a .jpeg images showing the binarized micrograph, ending with *_binary.jpeg*.
  * a results .csv file containing the list of all the hydrides in the micrograph and their corresponding RHF and hydride length. 

## 6. Decription of the MATLAB code for RHCP.
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


## 7. Instructions on how to use the MATLAB code for RHCP.

#### 1. Save your micrographs

If you want to use the RHCP code, I imagine that you have micrgraphs that you would like to analyze. Save these micrographs as greyscale '.tif' file in a folder sitting next to the __RHCP_MatLab_code__ folder you downloaded at step *5.2. Download the repository or the specific MATLAB code you want to use*.

#### 2. Open MATLAB
Open the file called __RHCP_main.m__ and make sure that MATLAB is open in the code folder.

#### 3. Launch the RHCP code 

To launch the code, you need to call the function __RHCP_main__ with the appropriate inputs:
```
RHCP_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing, fracParamZr, fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step)
```
with:
- codeFolderName: The name of the folder in which the RHCP code is stored.
- imageFolderName: The name of the folder in which images are stored.
- startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
- startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
- SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- resolution: The image resolution  in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
- resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.
- PerCut: For the genetic algorithm convergence. The acceptance rate for new generations under which the porgram should stop. We recommend using 0.01.
- tolConvergence: For the genetic algorithm convergence. The tolerance for the difference between the RHCP value of the best and worst paths. The algorithm stops when the difference is smaller than this tolerance. We recommend using 1e-4. 
- numPaths: For the genetic algorithm. The number of paths in each generation. We recommend using between 50 and 100.
- Mutation: For the genetic algorithm. The chance of random mutation when deriving a child path. We recommend using 0.05.
- primary_nodes_dist: For the genetic algorithm. The distance between points of the path that constitute the genome. To ensure that the algorithm will pick up circumferential hydrides, we recommend using 1.
- disp_num: For the genetic algorithm. Number of displacements imposed on the path during annealing. We recommend using 20.
- disp_size: For the genetic algorithm. Maximum magnitude of the displacements imposed on the path during annealing. We recommend using 20.
- annealingTime: For the genetic algorithm. Number of annealing steps. We recommend using 1000.
- numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
- CPMax: For the genetic algorithm. Maximum number of generations. We recommend using 50001.
- num_smoothing: For the genetic algorithm. Number of times the path is smoothed. We recommend using 1, doing it more than that does not really increase the path quality..
- fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
- fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
- valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
- num_bands: For the genetic algorithm. Number of bands used to divide the image. We recommend using 5.
- bridge_criteria_ratio: For the genetic algorithm. Fraction of hydride that should be present between two path to justify building a bridge between two paths from two different bands. We recommend using 0.6.
- plotFrequency: For the genetic algorithm. Number of generation between plots of the paths. Having a small number here slows down the algorithm as it wastes time plotting figures. Use 1 to minimize the number of plots. We recommend using 1000.
- desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4. Please use __nan__ for the validation.
- W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
- y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.

An example of a call is:

```
RHCP_main('RHCP_Matlab_code','RHCP_Validation_Microstructures',100,255,60,10,0,'RHCP_Validation_Results', 0.01, 1e-4, 50, 0.05, 1, 20, 20, 1000, 1, 50001, 1, 50, 1, 1, 5, 0.6, 1, nan, 13, 10)
```
#### 4. Binarize the microstructures
*The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 

To use the GUI, you can refer to section *12 .Instructions on how to use the GUI to binarize images.* of this document. You will be asked to define the binarization parameters for each micrograph in the image folder.  

#### 5. Monitor the algorithm
Once you are done binarizing the micrographs, the MATLAB code will start the analysis. At this point, you do not need to do anything since the analysis is automated. To help you monitor the advancement of the algorithm, the MATLAB code will produce figures showing the convergence of the algorithm, as well as the paths on the micrographs. These figures are saved in the results folder for future reference.

#### 6. Analyze results
To analyze the results, go to the result folder, which name you defined in resultsFolderName at step *3. Launch the RHCP code.*.

You should find:
* a .csv file with the name of the result folder, which contains the list of the names of the micrographs with their corresponding RHCP.
* for each micrograph:
  * a .csv file containing the binary parameters, ending with *_BinaryParam.csv*.
  * a .tif and a .jpeg images showing the binarized micrograph, ending with *_binary.jpeg*.
  * a .pdf image showing the binarized micrograph with the best path found by the algorithm, ending with *_Micrograph_Final_Paths.pdf*.
  * a .csv file containing the positions of the best path found for this microstructure, ending with *best_path_results.csv*.
  * Several images showing the binarized micrograph with the current paths at several stages of the convergence. 
  * Several images showing the Histogram of the RHCP values currently found for this micrograph at several stages of the convergence.
  * Several .csv files containing the RHCP values currently found for this micrograph at several stages of the convergence.
  * Several .fig and .pdf files showing the evolution of the percentage of accepted paths as a function of the number of iterations during convergence, ending with *_RHCP_percentage_acceptance*
  * Several .fig and .pdf files showing the evolution of the RHCP values (min, max, mean, median) as a function of the number of iterations during convergence , ending with *_RHCP_evaluation*

## 8. Decription of the MATLAB code for HCC.
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


## 9. Instructions on how to use the MATLAB code for HCC.

Please note that in this implemetation, the whole micrograph is used to determine HCC. If you want to use the initial definition from Bell et al. 1975, make sure that the width of the microstructures corresponds to the definition. 

#### 1. Save your micrographs

If you want to use the RHCP code, I imagine that you have micrgraphs that you would like to analyze. Save these micrographs as greyscale '.tif' file in a folder sitting next to the __HCC_MatLab_code__ folder you downloaded at step *5.2. Download the repository or the specific MATLAB code you want to use*.

#### 2. Open MATLAB
Open the file called __HCC_main.m__ and make sure that MATLAB is open in the code folder.

#### 3. Launch the HCC code 

To launch the code, you need to call the function __HCC_main__ with the appropriate inputs:
```
HCC_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, Min_Segment_Length, band_width)
```
with:
- codeFolderName: The name of the folder in which the HCC code is stored.
- imageFolderName: The name of the folder in which images are stored.
- startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
- startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
- SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- resolution: The image resolution  in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
- resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.
- Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC.
- band_width: is the width of the band used to derive HCC. The unit depends on the unit of the variable 'resolution'. d = 0.11 mm. Use Inf to use the entire image.

An example of a call is:

```
HCC_main('HCC_Matlab_code','RHCP_Verification_Microstructures',100,255,60,10,0,'HCC_Validation_Results', 5,100)
```
#### 4. Binarize the microstructures
*The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 

To use the GUI, you can refer to section *12 .Instructions on how to use the GUI to binarize images.* of this document. You will be asked to define the binarization parameters for each micrograph in the image folder.  

#### 5. Monitor the algorithm
Once you are done binarizing the micrographs, the MATLAB code will start the analysis. At this point, you do not need to do anything since the analysis is automated.

#### 6. Analyze results
To analyze the results, go to the result folder, which name you defined in resultsFolderName at step *3. Launch the HCC code.*.

You should find:
* a .csv file with the name of the result folder, which contains the list of the names of the micrographs with their corresponding HCC.
* for each micrograph:
  * a .csv file containing the binary parameters, ending with *_BinaryParam.csv*.
  * a .tif and a .jpeg images showing the binarized micrograph, ending with *_binary.jpeg*.
  
  
## 10. Decription of the MATLAB code for RHCF.
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

## 11. Instructions on how to use the MATLAB code for RHCF.

Please note that in this implemetation, the whole micrograph is used to determine RHCF. If you want to use the initial definition from Billone et al. 2013, make sure that the width of the microstructures corresponds to the definition. 

#### 1. Save your micrographs

If you want to use the RHCP code, I imagine that you have micrgraphs that you would like to analyze. Save these micrographs as greyscale '.tif' file in a folder sitting next to the __RHCF_MatLab_code__ folder you downloaded at step *5.2. Download the repository or the specific MATLAB code you want to use*.

#### 2. Open MATLAB
Open the file called __RHCF_main.m__ and make sure that MATLAB is open in the code folder.

#### 3. Launch the RHCF code 

To launch the code, you need to call the function __RHCF_main__ with the appropriate inputs:
```
RHCF_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, band_width)
```
with:
- codeFolderName: The name of the folder in which the RHCF code is stored.
- imageFolderName: The name of the folder in which images are stored.
- startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
- startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
- SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
- resolution: The image resolution  in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
- resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.
- band_width: is the width of the band used to derive RHCF. The unit depends on the unit of the variable 'resolution'. d = 0.150 mm. Use Inf to use the entire image.

An example of a call is:

```
RHCF_main('RHCF_Matlab_code','RHCP_Verification_Microstructures',100,255,60,10,0,'RHCF_Validation_Results',150)
```
#### 4. Binarize the microstructures
*The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 

To use the GUI, you can refer to section *12 .Instructions on how to use the GUI to binarize images.* of this document. You will be asked to define the binarization parameters for each micrograph in the image folder.  

#### 5. Monitor the algorithm
Once you are done binarizing the micrographs, the MATLAB code will start the analysis. At this point, you do not need to do anything since the analysis is automated.

#### 6. Analyze results
To analyze the results, go to the result folder, which name you defined in resultsFolderName at step *3. Launch the RHCF code.*.

You should find:
* a .csv file with the name of the result folder, which contains the list of the names of the micrographs with their corresponding RHCF.
* for each micrograph:
  * a .csv file containing the binary parameters, ending with *_BinaryParam.csv*.
  * a .tif and a .jpeg images showing the binarized micrograph, ending with *_binary.jpeg*.
  
  
## 12. Instructions on how to use the GUI to binarize images.

When using one of these MATLAB algorithm, you will be prompt to use a GUI to binarize the microstructures being analyzed. Please note that if the microstructure have already been binarized and that the binarization parameters are saved in the results folder, then the MATLAB code will use these parameters instead of asking you to binarize them again. If you want to binarize them again, input a different result folder name. The GUI will appear as shown in the following image:

| GUI        | 
|------------|
<img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/MATLAB_CODE_GUI.png" width="1000"> |

* 1 shows the initial microstructure being analyzed.
* 2 shows the binarized microstructure. Parts of the microstructure are kept (shown in black), and the rest of the microstructure is filtered out (shown in white). Inthis image, holes and small particules of the desired size have been filled and removed, respectively (See '4' to see how to change the desired sizes of holes and particles).
* 3 shows the final binarized microstructure, i.e. the one that will be analyzed by the algorithm. The hydrides have been skeletonized. 
* 4 allows you to determine the parameters for the binarization process. Each change made on 4 affects images 2 and 3.
	* Min Threshold corresponds to the value of the lower threshold. Decreasing it removes the lighter pixels. 
	* Max threshold corresponds to the value of the higher threshold. Decreasing it includes lighter pixels. It it usually set to the maximum value
	* Size spot removal corresponds to the size in pixels of the particles that you wish to filter out. Increasing this value will filter out larger particules. 
	* Size holes removal corresponds to the size in pixels of the holes that you wish to fill out. Holes are groups of white pixels completely surrounded by black pixels. Increasing this value will fill out larger holes.
	* You can filter out, or not, the groups of pixels that are in contact with the border of the image. 
* 5 allows you to compensate, or not, for a non-uniform background lighting. The value for the non-uniform ighting compensation can be changed from 0 to a large number if necessary. It's effect can change depending on the image, do not be afraid to play with it and find a value that provides the best results. I recommend that you first try to obtain the best binary picture possible using commands described in 4 before trying to compensate for non-uniform background lighting. 4 and 5 will then probably have to be used together to find the optimum values.
* 6 shows the histogram of the grayscale pixels. It can be used to set up the Min and Max values for the threaholds in 4.
* 7 shows the number of hydrides counted by the algorithm.
* 8 is the OK button, that you can press once you are satisfied with the parameters you chose and the microstructure on the right, in 3. Once pressed, the algorithm will save these parameters and move on the the next image, or to the analysis if you went through every images.

The following figure shows an example of a microstructure and it's binarized version.

| Microstructure      | Binarized microstructure      |
|------------|-------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure.png" width="250"> | <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure_binary.png" width="250"> |

