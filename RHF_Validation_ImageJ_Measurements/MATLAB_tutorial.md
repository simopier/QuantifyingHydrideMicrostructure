# Tutorial to use MATLAB and make measurements of Radial Hydride Fraction on real micrographs for validation. 

To validate the new definition and implementation of the RHF, the results are compared with human measurements made using ImageJ. 
This tutorial explains how to perform the measurements on MATLAB. 
Luckily, MATLAB does most of the work and the user is needed only to select the right parameters to binarize the images

## 0 - Download MATLAB
* As a PennState student, you can download MATLAB [here](https://softwarestore.psu.edu/mathworks-license/-8474).
* As a student, you can download MATLAB [here](https://www.mathworks.com/products/matlab/student.html).
* You can download MATLAB [here](https://www.mathworks.com/products/get-matlab.html?s_tid=gn_getml).

## 1 - Download the MATLAB code
You can download the MATLAB code for the Radial Hydride Fraction [here]()0000000000000000.

## 2 - Download folder containing the validation images. 
* You can download the folder containing the Validation images for RHF validation [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHF_Validation_Microstructures).
* Save the folder in the same folder where you saved the RHF MATLAB code folder (*do not save the image folder in the code folder itself, you should have two separate folders next to each other.*). 

## 3 - Download template_time.xlsx
You can download the template to enter the time it took to perform the measurements [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHF_Validation_ImageJ_Measurements/template_time.xlsx).
In this file, you can enter how much time it took you to perform the measurements. Active time corresponds to the amount of time you spent in front of the computer taking measurements, saving them, etc. Total time corresponds to the active time plus the time the computer took to perform analysis. When using MATLAB, the total time should be alittle more than the active time since the MATLAB code will perform the analysis. It should be around one or two minutes longer. 

## 4 - Open MATLAB
* Open the file called __RHFIntersection_main.m__ and make sure that MATLAB is in the code folder.

## 5 - Start timer
Make sure to start a timer to keep track of how much time it takes you to perform measurements.

## 6 - Launch the RHF code 
To launch the code, you need to call the function __RHFIntersection_main__ with the appropriate inputs:
```
RHFIntersection_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName)
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
RHFIntersection_main('RHF_MatLab_Code','RHF_Validation_Microstructures',240,255,90,10,0,inf,'RHF_Validation_Results')
```

* *The MATLAB code will open a GUI promptung you to modify the parameters to binarize the image.* 
* Modify the parameters until you are satisfied with the microstructure on the right. The goal is to keep only the hydrides on the image. Use the threshold values, the spot and hole size controls to remove the dust and other features from the micrographs.
* Click OK on the bottom right when you are done with one image.
* Repeat until you hve binarized all images.
* Record the active time.
* *The MATLAB code will then perform the measurements on its own. Which should take one to two minutes*

## 7 - Send measurements
Once you are done, please send the following files to pjs5523@psu.edu:
* The files from the result folder. It should include the binarized images, the binary parameters saved in a .csv file, and a .csv file with the RHF values. 
* The filled template_time.xlsx file
