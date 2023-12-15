#!/usr/bin/python3
"""
Written by Jinseok Oh, Ph.D.
Visualize summary data and save as a publication-quality figure
Based on S4_Create_Figures.m written by Dr. James Finley.

t-test portion in the original code is omitted.

If you're using the CLI, the command will be:
    python3 S4_Create_Figures.py {csv of estimated coefficients} \
            {csv of true parameters}

I prepared Group_Data.csv and True_Parameters.csv, so you can try it out.
If you're not using the CLI, manually read the files and run.
"""
import argparse
from itertools import repeat
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Learned that loadmat does NOT load MATLAB tables.
# So we're limiting input files to be csv files.
parser = argparse.ArgumentParser()
parser.add_argument('ef',
                    help='Name of the csvfile that saved estimated coefficients',
                    type=str)
parser.add_argument('tf',
                    help='Name of the csvfile that has true coefficients',
                    type=str)
parser.add_argument('-W', '--fig_width',
                    help="Width of the figure",
                    type=int)
parser.add_argument('-H', '--fig_height',
                    help="Height of the figure",
                    type=int)
arg = parser.parse_args()

ERRMSG = "Only .csv format is allowed!"

print(f"First input's file extension: {arg.ef.split('.')[1]}")
print(f"Second input's file extension: {arg.tf.split('.')[1]}")

if not all((arg.ef.split('.')[1] == 'csv',
            arg.tf.split('.')[1] == 'csv')):
    raise ValueError(ERRMSG)

Coefficients_All = pd.read_csv(arg.ef)
# Make column names of True_Parameters the same as those of Coefficients_All.
colnames = Coefficients_All.columns
True_Parameters = pd.read_csv(arg.tf,
                              header=None,
                              names=colnames)

# In the MATLAB script, Not_NAN, indices of non-NaN values was used for
# further processing.
Not_NAN = np.where(Coefficients_All['A_Slow'].isna())[0]

# pid: participant id
# Need this categorical variable to plot "individual" data
Coefficients_All['pid'] = np.arange(Coefficients_All.shape[0])
Coefficients_All['pid'] = Coefficients_All['pid'].astype("category")
True_Parameters['pid'] = np.arange(True_Parameters.shape[0])
True_Parameters['pid'] = True_Parameters['pid'].astype("category")

# Concatenate the two data frames, with NaN rows removed
merged = pd.concat([Coefficients_All.drop(Not_NAN, axis=0),
                    True_Parameters.drop(Not_NAN, axis=0)], axis=0)

#####################################################################
# ctype: Coefficient type                                           #
# Another categorical variable introduced for the plotting purpose  #
# Why RN = int(merged.shape[0]/2)?                                  #
# Coefficients_All and True_Parameters, even after NaN rows removed,#
# should be identical in the number of rows.                        #
#####################################################################
RN = int(merged.shape[0]/2)
merged['ctype'] = np.concatenate((list(repeat("Estimated", RN)),
                                  list(repeat("True", RN))))
merged['ctype'] = merged['ctype'].astype("category")

#####################################################################
# Plotting begins here.                                             #
# In my opinion, making neat figures using matplotlib/Seaborn       #
# requires more work than using MATLAB. Do suggest if there's a     #
# better way than what I drafted below!                             #
#####################################################################
if arg.fig_width:
    W = arg.fig_width
else:
    W = 8
if arg.fig_height:
    H = arg.fig_height
else:
    H = 6
fig, ax = plt.subplots(nrows=2, ncols=2, figsize=(W, H),
                       gridspec_kw={'wspace': 0.5, 'hspace': 0.5})
#####################################################################
# Let's think about what's common among the figures:                #
# 0) Overall design features
# 1) No x-axis label                                                #
# 2) Padding to the left and the right of the plotted points        #
# These can be done using for loop!                                 #
#                                                                   #
# Here I chose seaborn's lineplot option.                           #
# Go for other options if you are not satisfied!                    #
#####################################################################
# colnames = ['A_Slow', 'B_Slow', 'A_Fast', 'B_Fast']
# colnames[[0, 2, 1, 3]] = ??
for i, txts in enumerate(zip(colnames[[0, 2, 1, 3]], ['A', 'B', 'C', 'D'])):
    q, r = divmod(i, 2)
    """
    Here I will explain what all different arguments mean (not in order).
    1. markers=['o', 'o']
    seaborn's lineplot basically draws lines. However, we're trying to
    have points at each end of individual lines. So we set 'markers' to
    be ['o', 'o'], or filled points.
    2. markersize=8
    easy - change the value as you wish
    3. markerfacecolor='gray'
    The color to fill the points with
    4. markeredgecolor='black'
    The color of a marker's edge.
    5. color='black'
    Based on my testing, this just sets the color of all components
    (e.g., line connecting points, point edges, point) to the designated
    color. If you want to change the marker edge's color independently,
    use 'markeredgecolor=...'
    6. style='pid'
    In order to use 'markers', you need to define the grouping variable,
    'style'. Here we're plotting each individual's estimated and true
    coefficient pair.
    7. dashes=False
    The default of this argument is True. This determines how to draw
    the lines for different levels of the 'style' variable. We instead want
    to use 'markers', so set this to False.
    8. estimator=None
    Method for aggregating across multiple observations of the y variable
    at the same x level. We want all observations to be drawn, so None.
    9. legend=False
    Don't include a legend
    10. ax=ax[q, r]
    Designate which axis this lineplot will be placed.
    Think about how q, r is derived!
    """
    sns.lineplot(data=merged, x='ctype', y=txts[0],
                 style='pid', dashes=False,
                 estimator=None, markers='o',
                 markersize=8, markerfacecolor='gray',
                 markeredgecolor='black', color='black',
                 legend=False, ax=ax[q, r])
    ax[q, r].set_xlabel('')
    ax[q, r].set_xlim(-0.5, 1.5)
    ylim = ax[q, r].get_ylim()
    ax[q, r].text(-1.1, ylim[1]+0.1*(ylim[1]-ylim[0]),
                  txts[1], fontsize=10, fontweight='bold')

# Then let's take care of plot-specific details
ax[0, 0].set_ylabel('Slow Coefficient')
ax[0, 1].set_ylabel('Fast Coefficient')
ax[1, 0].set_ylabel('Slow Rate Constant')
ax[1, 1].set_ylabel('Fast Rate Constant')

plt.savefig('Coefficient_Estimates-Group.pdf')

plt.show()
