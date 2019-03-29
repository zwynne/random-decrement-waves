
These MATLAB scripts originate from a study where the principles of operational modal analysis, through the Random Decrement Technique (RDT), currently used primarily in the analysis of high rise structures and in the aeronautical industry and not previously applied within the fields of limnology or ecology, were applied to barotropic seiches through the analysis of water level data for Lake Geneva, Switzerland, and Lake Tahoe, USA.  Using this technique, the autocorrelation of the measurements was estimated using the RDT and modal analysis carried out on this time-domain signal to estimate the periods of the dominant surface seiches (low frequency surface waves) and their corresponding damping ratios.


Provided within this repository are a set of example MATLAB scripts for the application of the Random Decrement Technique to the analysis of surface waves, alongside a set of sample water elevation data for Lake Geneva used within "A novel technique for experimental modal analysis of barotropic seiches for assessing lake energetics" (Wynne et al, 2019).


These MATLAB scripts may be easily modified for modal analysis using the Random Decrement Technique for other forms of data including vibrations and oscillations.



A section of the fMatPen.m script is provided with permission of Professor T Zielinski, for a full description of the marked section of code please refer to http://www.kt.agh.edu.pl/~tzielin/papers/M&MS-2011/.


To cite this repository please cite:

Wynne, Zachariah; Reynolds, Thomas; Bouffard, Damien; Schladow, Geoffrey; Wain, Danielle. (2019). A novel technique for experimental modal analysis of barotropic seiches for assessing lake energetics, [dataset]. University of Edinburgh. https://doi.org/10.7488/ds/2512.

And for information on the study discussed above please refer to:

Wynne, Z., Reynolds, T., Bouffard, D., Schladow, G., & Wain, D. (2019). A novel technique for experimental modal analysis of barotropic seiches for assessing lake energetics. Environmental Fluid Mechanics. Springer Netherlands. https://doi.org/10.1007/s10652-019-09677-x

http://links.springernature.com/f/a/CBgQlYANEDJKnX4XTFd54w~~/AABE5gA~/RgRefpBIP0QwaHR0cDovL3d3dy5zcHJpbmdlci5jb20vLS8xL0FXbkdzbWs0RGZ4blZWYnpWUFMzVwNzcGNCCgAAyFydXKmZAh9SFFouV3lubmVAc21zLmVkLmFjLnVrWAQAAAbn




Dataset Description:
		--------	
MAIN_Random_decrement_model.m - A MATLAB script for applying the Random Decrement Technique for analysis of barotropic seiches. Provided within this file is a description of the application of the Random Decrement model. All other .m files (bandpass_filter.m, FastFourierTransform.m, fMatPen.m, RDT_level_crossing.m) are called by this script. MATLAB scripts are licensed under the CC-BY 4.0 International License. Copyright 2019 Zachariah Wynne, Thomas Reynolds, Damien Bouffard, Geoffrey Schladow, Danielle Wain. A section of the fMatPen.m script is provided with permission of Professor T Zielinski, for a full description of the marked section of code please refer to http://www.kt.agh.edu.pl/~tzielin/papers/M&MS-2011/.
		--------		
water_elevation_2028_2018.mat - An example dataset provided for use with MAIN_Random_decrement_model.m.


A version of this repository, including water level data for Lake Geneva, Switzerland, and Lake Tahoe, USA is available at :

datashare.is.ed.ac.uk/handle/10283/3278

