# Tutorial to use MATLAB and make measurements of Radial Hydride Fraction on real micrographs for validation. 

To validate the new definition and implementation of the RHF, the results are compared with human measurements made using ImageJ. 
This tutorial explains how to perform the measurements on MATLAB. 
Luckily, MATLAB does most of the work and the user is needed only to select the right parameters to binarize the images

## 0 - Download and install MATLAB
* As a PennState student, you can download MATLAB [here](https://softwarestore.psu.edu/mathworks-license/-8474).
* As a student, you can download MATLAB [here](https://www.mathworks.com/products/matlab/student.html).
* You can download MATLAB [here](https://www.mathworks.com/products/get-matlab.html?s_tid=gn_getml).

* __When selecting the toolboxes, install the Image Processing Toolbox, which will be used by the software.__ 

To test if the image processing toolbox is installed in MATLAB, you can open MATLAB and copy and run the following lines in the MATLAB console:
```
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway (Not recommended, as this will not work)? \n To install the toolbox, visit: https://www.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
else
 message = sprintf('You have the the Image Processing Toolbox.');
end
```
To install the toolbox, visit [this page](https://www.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab) for instructions.


## 1 - Download the MATLAB code
You can download the MATLAB code for the Radial Hydride Fraction in __RHF_Matlab_Code__ [here](https://github.com/simopier/QuantifyingHydrideMicrostructure). Download the whole folder, not just the files.

## 2 - Download folder containing the validation images. 
* You can download the folder containing the Validation images for RHF validation [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHF_Validation_Microstructures).
* Save the folder in the same folder where you saved the RHF MATLAB code folder (*do not save the image folder in the code folder itself, you should have two separate folders next to each other.*). 

## 3 - Download template_time.xlsx
You can download the template to enter the time it took to perform the measurements [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHF_Validation_ImageJ_Measurements/template_time.xlsx).
In this file, you can enter how much time it took you to perform the measurements. Active time corresponds to the amount of time you spent in front of the computer taking measurements, saving them, etc. Total time corresponds to the active time plus the time the computer took to perform analysis. When using MATLAB, the total time should be a little more than the active time since the MATLAB code will perform the analysis. It should be around one or two minutes longer. Please enter the times in minutes.

## 4 - Open MATLAB
* Open the file called __RHF_main.m__ and make sure that MATLAB is in the code folder.

## 5 - Start timer
Make sure to start a timer to keep track of how much time it takes you to perform measurements.

## 6 - Launch the RHF code 
*This section seems long, but it actually requires very little time. I just gave many details about all the inputs. If you want to save time, simply look at the end of this step, copy the example call for the function __RHF_main__ into the  MATLAB console, press enter, and that's it!*


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

## 3 - Binarize the microstructures
* *The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 
* Modify the parameters until you are satisfied with the microstructure on the right. The goal is to keep only the hydrides on the image. 
  * If the background light is non-uniform, you can compensate for it. Select the desired option and then enter the desired value. If needed, 10 would be a good place to start. However, you shouldn't need it for the validation images. 
  * Use the threshold values to binarize the image. The max value typically stays at the maximum value on the scale. The minimum value depends on the image. You can use the histogram below on the GUI to see where pixel intensity stands.
  * Use the spot size control to remove the dust and other features from the micrographs.
  * Use the hole size control to remove white pixels within hydrides.
* Click OK on the bottom right when you are done with the image (See below for an example of binarization).
* Repeat until you hve binarized all images.
* Record the active time. (Please enter the time in minutes.)
* *The MATLAB code will then perform the measurements on its own. Which should take one to two minutes*

| Microstructure      | Binarized microstructure      |
|------------|-------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure.png" width="250"> | <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure_binary.png" width="250"> |

## 7 - Send measurements
Once you are done, please send the following files to pjs5523@psu.edu:
* The files from the result folder. It should include the binarized images, the binary parameters saved in a .csv file, and a .csv file with the RHF values. 
* The filled template_time.xlsx file
