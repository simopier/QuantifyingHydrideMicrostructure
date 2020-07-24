# Tutorial to use ImageJ and make measurements of Radial Hydride Fraction on real micrographs for validation. 

To validate the new definition and implementation of the RHF, the results are compared with human measurements made using ImageJ. 
The hydrides are approximated as lines drawn with ImageJ on the microstructure. 
These lines are then analyzed and used to determine the RHF of the microstructure.

## 0 - Download ImageJ
You can download ImageJ [here](https://imagej.nih.gov/ij/download.html).

## 1 - Download folder containing the validation images. 
You can download the Validation images for RHF validation [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/tree/master/RHF_Validation_Microstructures).

## 2 - Download RHF_template_time.xlsx
You can download the template to enter the time it took to perform the measurements [here](https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHF_Validation_ImageJ_Measurements/RHF_template_time.xlsx).
In this file, you can enter how much time it took you to perform the measurements. Active time corresponds to the amount of time you spent in front of the computer taking measurements, saving them, etc. Total time corresponds to the active time plus the time the computer took to perform analysis. When using imageJ, the total time should be equal to the active time.  

## 3 - Open ImageJ
* On MAC OS: Open ImageJ
* On Windows: run ImageJ.exe

## 4 - Start timer
Make sure to start a timer to keep track of how much time it takes you to perform measurements.

## 5 - Open images
* Go in __File__ and select __Open__.
* Then select the image from computer.
* *At this point you should see another ImageJ tab open with the image*.

## 6 - Perform measurements  
* On ImageJ toolbar select __Analyze__. In drop-down menu go under __Tools__ and open __ROI Manager...__.
* * A third tab called __ROI manager__ should come up*.
* Check box __Show All__ at bottom of __ROI Manager__ tab
* If needed, to zoom in and out of certain regions of the image, select the magnifying glass tool on ImageJ main tab, and press the '+' and '-' keys. 
* Select the __Straight__ box on the ImageJ main tab (fifth one to the right) to be able to draw lines on the microstructure.
* Make sure you are drawing straight lines by right clicking on the line box and selecting __Straight line__.
* Draw lines along the hydrides on image tracing hydrides. 
  * To do so, click on one end, and drag until the other end of the hydride you want to approximate with a line, and release. 
  * If you want to change the line you just drew, you can drag the three little squares on the line to change it.
  * Once you are satisfied with the line, __press the 't' key on your keyboard__ (this adds the line to the __ROI manager__, you should see a new set of coordinates pop up in the __ROI manager__)
* Repeat drawing lines until all the hydrides are approximated with lines.

*Always make sure you press the 't' key to save the line you drew, otherwise it won't be saved. If you save a line, it will stay on the image as you draw new ones, otherwise it will disapear.* 

| Example of a few lines drawn on a microstructure with ImageJ           |
|--------------------------|
| <img src="https://github.com/simopier/QuantifyingHydrideMicrostructure/blob/master/RHF_Validation_ImageJ_Measurements/RHF_Example_lines.png" width="300"> |


## 7 - Save measurements
* Once you are done approximating the hydrides with the lines you can save your measurements
* On the __ROI manager__ tab, select __Measure__.
* *A table should come up with the data*
* Select __Files > Save As...__ to save this file in the results folder (RHF_Validation_Results) as a .csv file with the name: __ImageNumber.csv__ (example: 14.csv).
* Repeat this for all images. (Please remember to pause the timer if/when you take breaks)

## 8 - Send measurements
Once you are done, please send the following files to pjs5523@psu.edu:
* One .csv file for each image with the line measurements
* The filled RHF_template_time.xlsx file

