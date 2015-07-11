#calibrator
A series of bash scripts to perform a simple method for species delimitation (Basically just a Qiime wrapper). 

Dependencies:
---
[Qiime](http://qiime.org/). Specifically, the "pick\_otus.py" script, which in turn has its own dependencies.

WARNING: this pipeline has only been tested on Ubuntu (versions 12 and 14). No guarantees or warranties provided. Feel free to email me at silas(dot)tittes(at)colorado(dot)edu with any and all questions.

Inputs:
---
- A multi fasta file.
The name of the species must appear somewhere in the header. The genus and species name should be separated by an underscore and must exactly match the name as it appears .
- A "speciesNames" file
This file should contain each species name (format genus name underscore species name) that you wish to use for calibration. One name per line. 

Within script defaults:
Within the "OTU\_calibrator.sh" script are a few integer parameters that appear in the top of the script. This is what you should see when you open the script:



DEFAULTS, MAKE SURE YOU EDIT!!!!!
percent similarity cutoffs to be used in qiimeLoop.sh
simLow=80
simHigh=100

the largest and smallest acceptable sequence lengths
lenLow=100
lenHigh=4000


I encourage you to modify the "lenLow=100 and lenHigh=4000" values if you have sequences outside that length range you would like to consider for calibration. Quality of estimation and time spent waiting may vary. The "simLow" and "simHigh" parameters are the lowest and highest percent similarity cutoff that are used in the pick\_otus.py script.

Calling the script. Be sure all files in this repositoriy are included in your current local directory (or fully install them if you dare). To run the script, simply type the following in the bash terminal command prompt:
bash "OTU\_calibrator.sh" your-fasta-file your-speciesNames-file
NOTE: not sure if the "\" symbol appears before the underscore, but don't include that in your command if so. Silly markdown formatting.

Example: 
---
This repository includes some example scripts. Feel free to try out the following to see if everything is working properly:
bash OTU\_calibrator.sh siphonaptera.fasta speciesNames


OUTPUTS:
---
-There will be several outputs.
The ones to pay attention to are:
bestSpeciesSim.txt
and the pdf files to visualize concordance between names and sequences and how the parameter space looks.

That's it. Good luck!
---  
