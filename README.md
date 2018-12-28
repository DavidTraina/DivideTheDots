# DivideTheDots
This Project is written in Processing 3, a graphical library for Java.

# Quick Start
You can run a slightly altered version of this project online at: https://www.openprocessing.org/sketch/648372
This online version does not run as well as the original (Version 1 below) and the visuals are slightly distorted 
because it is ported to JavaScript in order to run in a web browser. However, it requires no installation or setup.

# Program Description:
This ia "game" or simply just a program where the user must must move the cursor around to divide the single 
initial dot into continually smaller groups of dots to reveal the hidden picture. Each dot divides into 4 new 
dots, each with half the radius of the original. This group of 4 occupies the same space as original, larger dot.
Each dot takes on the average color of the portion of the image that it overlaps. As the number of dots grows and 
the size of the dots decreases, the hidden image becomes increasingly clear.

# Instructions 
There are 3 different folders included in this repositroy, each contains a slightly different version of the project.

# Version 1 (DivideTheDots). This is the original version and will provide the best user experience.
You will need Processing 3, which can be downloaded here: https://processing.org/download/
Once you download the .zip and run keep the folder hierarchy as-is and open DivideTheDots.pde in the PDE (Processing 
Development Environment). If you experience trouble getting to this stage, follow the instructions at 
https://processing.org/tutorials/gettingstarted/ . Change the file-path in the setupPhoto() method appropriately for 
your machine. Click run at the top and the program will begin.

# Version 2 (DivideTheDots-processing_dot_js). This version gets ported to JavaScript and is runnable in a web-browser.
The visuals may be distorted and the program may not run as well since it it ported. To run the program, simply open
DivideTheDots.html in a web-browser. See the README.md in that folder if you have issues.

# Version 3 (DivideTheDots-Android) This version is slightly altered to be buildable into an Android application.
Follow the instructions from Version 1 to open DivideTheDots.pde in the PDE and then follow the instructions in the 
README.md in the folder.
