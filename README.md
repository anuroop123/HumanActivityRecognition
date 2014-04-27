HumanActivityRecognition
========================

run_analysis.R contains the code for getting the samsung human activity data. 

The script first looks to see if the dataset is present in the current directory. If not, it will download and unzip the data. The script will then read the training and test datasets and join them and only keeps the features related to means and standard deviations. I have also included meanFreq features here. This dataset is written to disk in a TSV file called meanAndStdData.txt. This can be read back into R using the read.table command.

Next the script computes the mean for each feature conditioned on the activity and subject. This gives us a new data frame with 180 rows (= 6 activities * 30 subjects). This new dataset is written to disk as a TSV file called meanData.tsv.

The script can be run from command line using:
  $ R run_analysis.R
Alternatively, it can be sourced from RStudio.

The script uses the stringr and plyr packages and these need to be installed using install.packages("<package_name>") command from R.
