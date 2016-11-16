# neair-predictives

Predictive techniques for institutional researchers using open source software.

This project was created in support of the following presentation:

Using Machine Learning Techniques to do Prediction in IR
Jason P. Casey
University of Notre Dame

NEAIR Annual Conference
Baltimore, Maryland
November 12-15, 2016

The main presentation diplays can be found in the presentation folder.  Several scripts are available in the root directory
for use in producing sample output and plots using techniques that were used in the presentation.

Contents:
presentation (folder): Shiny app that produces basic output from the models presented
usn-predictor (folder): Shiny app that models US News Law School Scores using restricted columns for demo purposes
data (folder): all data files used in presentation
LICENSE: MIT license -- basically use freely, attribute if you share
proc-data.R: data processing script that creates testing and training files for summaries
README.md: You're reading it!
samples.R: playing with models using random data.  Alter seed statement to create different sequences of samples
svm-example-plots.R: SVM sample plots for presentation
test-SVR.R: worked example of SVR using nonlinear data after this article:
            http://www.svm-tutorial.com/2014/10/support-vector-regression-r/
tree-plots.R: example tree plot using mtcars dataset
