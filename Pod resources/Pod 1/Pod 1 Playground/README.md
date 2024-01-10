# ReproRehab2023_POD1_Playground
This is a repository prepared for ReproRehab2023 POD1 learners.

To learn more about ReproRehab, please visit www.reprorehab.usc.edu.

There's also a GitHub repository: github.com/reprorehab/reprorehab2023

POD1 focused on learning how to use MATLAB for your research. 
Here's a list of materials presented and discussed over the 7 weeks. 
All materials are in the folders of this repository as well.

Week 1: Tools for reproducible science I
------
- What is 'metadata'?
- How can one prepare metadata? (ft. JSON)
- Git/GitHub: a tool for reproducibility

_activity_ : generate a JSON file using a MATLAB script,
            upload the file to a forked repo,
            and make a pull request to the upstream.

Week 2: Tools for reproducible science II
------
- Different ways to collaborate using Git/GitHub
  (forking, branching, inviting collaborators)
- GitHub Desktop: how to push commits from a local machine

_activity_ : push commits from local machines using GitHub Desktop, create a new branch
            in a repository and merge the new branch with the main.

Week 3: FAIR principles and MATLAB data types
------
- What is FAIR (data) principles?
  (video: 'Unit3: Introduction to FAIR Data' of ReproRehab)
- Data types of MATLAB: numeric, character/string, categorical,
                        table

_activity_ : Run a MATLAB script, understand what lines of code mean, and modify several lines as requested.

All work pushed to the upstream repository.
(MATLAB script used: S1_Simulate_Adaptation_Data.m prepared by Dr. James Finley)

Week 4: MATLAB tips to improve productivity
------
- Understanding different data types more: `char` and `string`
- Different functions/features to work with table arrays
  (ex. varfun, rowfun, function handle)
- Memory preallocation: a demo on its usefulness
- format specifier: what is it, and how to use it

_activity_ : transform a csv output of Vicon Motion Capture System to have organized column names of a table.
The activity highlighted...

using `detectImportOptions` to read csv files in MATLAB effectively

accessing and modifying a table's variable names using table `Properties`

using `cellfun` with function handles to apply changes to multiple items of a cell array

writing a for-loop to run an iterative job.

Week 5: Visualization in MATLAB
------
- Learning how to visualize data in MATLAB
- Configuring plots by setting parameters in advance

_activity_ : modify a MATLAB script to add simulated data and
            plot the simulated data
            
_extra_activity_ : complete another MATLAB script to read files in different folders, compile them to one `struct` and save it

(MATLAB script used: CompileJoingAngleData.m prepared by Dr. James Finley)

(DATASET used: https://doi.org/10.6084/m9.figshare.c.4494755)

Week 6: Doing statistical analysis in MATLAB
------
- Learning how to calculate group statistics, run one-way ANOVA,
  repeated-measures ANOVA and fit a linear mixed model to data
- Learning how to visulize analysis results
  (ex. using * to indicate significant difference)

_activity_ : complete a MATLAB script to read multiple csv files,
            run repeated measures ANOVA, and plot the results

Week 7: How to write functions using inputParser (Optional)
------
- Learning how to write custom functions to perform a task
- Understanding the mechanism of inputParser
 
_activity_ : complete a MATLAB function script to pass test cases;
            the activity also introduced different tips discussed
            in the previous weeks.

All questions related to each week's content or activity will be directed to
Devin Austin (austid@udel.edu) or Jinseok Oh (joh@chla.usc.edu)
