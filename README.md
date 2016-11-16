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

A few notes on the usn-predictor app:
(1) Some predictors were omitted to optimize the USN data for purposes of the presentation,
    notably, the peer assessment and judges' assessment.  Predictions are much more accurate
    when these predictors are included.
(2) A linear regression model works well for this model should one wish to implement it in an institutional setting
(3) The Reset button is not wired up properly in the present version.  You have to hit reset and then Predict to 
    reset to default values.  Still working on that!
(4) It is clear that US News is basically a brand recognition survey.  There is much more reliability at the
    high end of the scale (i.e., the "top" brands), but much less so at the low end.  As a consequence, estimates
    become noisier and more uncertain as one moves down the scale.  (This hold true for ALL US News ranking scores).
(5) Because the Overall Score is built using the predictors, any model (MLR, CART, Random Forest, SVR) will produce
    quite large R-squared values.
    
Anyone with questions about my code, implementation, or even questions about setup and use are encouraged to contact me directly:
jcasey4@nd.edu
jazzerj@gmail.com

--Jason
