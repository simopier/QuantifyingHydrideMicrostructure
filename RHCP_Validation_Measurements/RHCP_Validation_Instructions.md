# Instructions to use MATLAB and ImageJ and make measurements of Radial Hydride Continuous Path on real micrographs for validation. 

To validate the new definition and implementation of the RHCP, the results are compared with human measurements made using ImageJ. 
The Micrographs are first binarized using MATLAB.
The user then defines a path using ImageJ and saves it.
In the meantime, the user can choose to let MATLAB run to determine the RHCP of each image, or not. 

## 0 - Download MATLAB and ImageJ
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


* You can download ImageJ [here](https://imagej.nih.gov/ij/download.html).

## 1 - Download the MATLAB code
You can download the MATLAB code for the Radial Hydride Continuous Path in __RHCP_Matlab_Code__ [here](https://github.com/simopier/QuantifyingHydrideMicrostructure). Download the whole folder, not just the file.

## 2 - Download folder containing the validation images. 
You can download the Validation images for RHCP validation [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHCP_Validation_Microstructures).

## 3 - Download RHCP_template_time.xlsx
You can download the template to enter the time it took to perform the measurements [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/RHCP_template_time.xlsx).
In this file, you can enter how much time it took you to perform the measurements. 
* __Binarization time__ corresponds to the time it took you to binarize all the images using MATLAB (see step 7). Please enter the time in minutes.
* __ImageJ analysis time__ corresponds to the time it took you to plot the paths on the hydride microstructures and save all the results. Please enter the time in minutes.
* __MATLAB measurements time__ corresponds to the time it took for MATLAB to perform the analysis once you were done binarizing the images. You will not have to do anything during that time. Please enter the time in minutes.

## 4 - Open MATLAB
Open the file called __RHCP_main.m__ and make sure that MATLAB is in the code folder.

## 5 - Start timer
Make sure to start a timer to keep track of how much time it takes you to perform the binarization process.

## 6 - Launch the RHCP code 
*This section seems long, but it actually requires very little time. I just gave many details about all the inputs. If you want to save time, simply look at the end of this step, copy the example call for the function __RHCP_main__ into the MATLAB console, press enter, and that's it!*


To launch the code, you need to call the function __RHCP_main__ with the appropriate inputs:
```
RHCP_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing, fracParamZr, fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step)
```
with:
- codeFolderName: The name of the folder in which the RHF code is stored.
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
## 7 - Binarize the microstructures
* *The MATLAB code will open a GUI prompting you to modify the parameters to binarize the image.* 
* Modify the parameters until you are satisfied with the microstructure on the right. The goal is to keep only the hydrides on the image. 
  * If the background light is non-uniform, you can compensate for it. Select the desired option and then enter the desired value. If needed, 10 would be a good place to start. However, you shouldn't need it for the validation images. 
  * Use the threshold values to binarize the image. The max value typically stays at the maximum value on the scale. The minimum value depends on the image. You can use the histogram below on the GUI to see where pixel intensity stands.
  * Use the spot size control to remove the dust and other features from the micrographs.
  * Use the hole size control to remove white pixels within hydrides.
* Click OK on the bottom right when you are done with one image (see example of image binarization below).
* Repeat until you hve binarized all images.
* Record the active time. (Please enter the time in minutes in __RHCP_template_time.xlsx__.)
* *The MATLAB code will then perform the measurements on its own. However, the RHCP calculations can take a long time (several hours for all images). If you want, you can stop the algorithm and I can perform the MATLAB calculations from your binarized images. If you decide to perform the analysis (Thank you!), you might want to make sure your computer will not go in screen saving mode by changing your settings. On Mac, you can also type the 'caffeinate' command in the terminal*
* __When you are done binarizing all images, please do not forget to stop the time and save the time it took you to binarize the images__.

| Microstructure      | Binarized microstructure      |
|------------|-------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure.png" width="250"> | <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Example_microstructure_binary.png" width="250"> |

## 8 - Open ImageJ
* On MAC OS: Open ImageJ
* On Windows: run ImageJ.exe

## 9 - Save Macro
We will need to save a macro to help us perform the measurements.
* Go in __Plugins > New > Macro__.
* *A tab called __Macro.txt__ will open.*
* Copy and paste the following lines in the file:
```
getSelectionCoordinates(xVect, yVect);
values = getProfile();
Array.show(xVect,yVect);
for (i = 1; i <yVect.length; i++){
        if (yVect[i] <=yVect[i-1]){
	showMessage("The path goes backward at some point, please modify it so that the path always goes downwards.");
        }
}
```
* Go to __File > Save As...__.
* Save the new macro in __ImageJ > macros__ with the name: __Get_line_positions.txt__.
* *It will be easier later if you keep that tab open, but you can close it.*

## 10 - Start timer
Make sure to start a timer to keep track of how much time it takes you to perform measurements using ImageJ.

## 11 - Open images
* Go in __File__ and select __Open__.
* Then select the image from computer. *Make sure you open the __jpeg__ binarized image from the __result folder__ created by MATLAB.*
* *At this point you should see another ImageJ tab open with the binary image*.

## 12 - Perform measurements / Draw a vertical path on ImageJ

* If needed, to zoom in and out of certain regions of the image, select the magnifying glass tool on ImageJ main tab, and press the '+' and '-' keys. 
* Select the __Straight__ box on the ImageJ main tab (fifth one to the right) to be able to draw lines on the microstructure.
* Make sure you are drawing __segmented__ lines by right clicking on the line box and selecting __Segmented line__.
* Draw a path from __top__ to __bottom__ on the microstructure following what you consider to be the best path along the hydrides. Make sure the path is as direct as possible from top to bottom, using hydrides as much as possible to progress. (See example below)
  * To do so, click on the top of the image where you want to place your first point. 
  * The keep going down and click where you want the path to go. Note that ImageJ will draw traight lines between clicked positions to create the path. Make sure you always go from top to bottom.
  * Once you have reached the bottom of the microstructure, click back on the top point to finish drawing. 
  * If you want to change the line you just drew, you can drag the three little squares on the line to change their position.
* When you are satisfy with your path, press the 't' key on your keyboard to save your line.

Here is an example of a microstructure and an appropriate path:
| Binarized Microstructure      | Appropriate path      |
|------------|-------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Microstructure_example_RHCP.jpeg" width="250"> | <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHCP_Validation_Measurements/Microstructure_example_RHCP_path.png" width="250"> |


## 13 - Save measurements
* To obtain the position of your clicks, you can either:
  * Activate the macro tab by clicking on it, and then go to __Macros > Run Macro__.
  * Or go to __Plugins > Macros > Run ...__ and select the file named __Get_line_positions.txt__ that we saved at step 9. 
* * This will create a tab with the x and y positions of the line you just drew. If you did not go from top to bottom when drawing the line, it will give you an error message. You will need to plot a new line.*
* Select __Files > Save As...__ to save this file in the results folder (RHCP_Validation_Results) as a .csv file with the name: __ImageNumber.csv__ (example: 14.csv).
* Repeat this for all images. (Please remember to pause the timer if/when you take breaks).
* __When you are done binarizing all images, please do not forget to stop the time and save the time it took you to take measurements with imageJ__.

## 14 - Send measurements
Once you are done, please send the following files to pjs5523@psu.edu:
* The files from the result folder created by MATLAB. It should include the binarized images, the binary parameters saved in a .csv file, and the results from the genetic algorithm if you let the MATLAB code run. 
* One .csv file for each image with the path position. (which should also be in the result folder RHCP_Validation_Results)
* The filled RHCP_template_time.xlsx file
