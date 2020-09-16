# Statistical-inferential-and-prediction-modeling
## 1 Introduction
Analyzing data from Wave 6 of the World Values Survey. These data are freely
available online.

### 1.1 Data Access
 - To access the data, follow these steps:
1. Follow this link:
http://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp
2. Download the file named: WV6_Data_R_v20180912 from the “Statistical
Data Files” cell in the table.
    - You will be re-directed to a page from which you can initiate the download.
3. Under “PERSONAL DATA,” provide the requested information.
4. Under “FILE USAGE,” give an appropriate project title and description (just
explain that you’ll use the data for a class project), and set the “Intended use”
field to *Instructional*.
5. Check the box labeled: *I have read the ’Conditions of use’ and agree with them*,
and hit the *Download* button.
    – The downloaded file should be a ZIP archive.
6. Extract the contents of the downloaded ZIP archive into the *data* subdirectory of
the directory tree for this project.
    – You should now have the data saved as an RDS file in the *data* subdirectory.
    
### 1.2 Data Processing
- Process the raw data by running the **processWvsData.R** script located in
the *code* subdirectory of the directory tree for this project.
    - For the dataDir argument, specify the relative filepath to the
data directory.
    - For the fileName argument, give the filename of the
downloaded RDS file (don’t forget the file extension).
    - After defining these two variables, execute the entire script.
    - The processed data will be saved in the data subdirectory as wvs_data.rds.
- Use these processed data for all of the analyses requested in Section 2.

## 2 Analytic Tasks
This section outlines the analyses for this assignment.

### 2.1 Data Preparation
The data contained in the “wvs_data.rds” file have been minimally processed, but they still
need to be cleaned and prepared for analysis. As the first part of this assignment, we will
clean the data in preparation for inferential and predictive modeling.

### 2.2 Inferential Modeling
Using the cleaned data to conduct an inferential modeling task. Using
multiple linear regression to answer the question:
- Are conservative attitudes good or bad for your psychological well-being?

### 2.3 Predictive Modeling
Using the cleaned data to conduct an predictive modeling task. Using multiple
linear regression to build a model predicting the outcome of:
- Satisfaction with life
