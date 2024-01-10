"""
Written by Jinseok Oh, Ph.D.
Translating S2_Combine_Adaptation_Data.m, prepared by Dr. James Finely.
Original code found from this Github repo:
    reprorehab/reprorehab2022

%% Combine the data for all participants into a single data structure
%
% By storing the data for all participants in a single, well-organized
% data structure, you can easily share your data with other MATLAB users in
% a self-explanatory format.
"""
import os
import glob
from collections import defaultdict
import pickle
import numpy as np
from numpy.random import default_rng
import matplotlib.pyplot as plt

os.chdir("./Simulated_Adaptation_Data")
Directory = glob.glob("2023*")

# Preallocate space for contents of data structure - not done here.
# Instead, we're preparing a defaultdict
# MATLAB script uses the data type: structure.
# Python equivalent could be dict or class - choosing dict for
# beginners...
Data = defaultdict(dict)

for Participant_Num in range(len(Directory)):
    # Read the step length asymmetry data from the .csv files
    SLAfilepath = os.path.join(Directory[Participant_Num],
                               Directory[Participant_Num]+'_pySLA.csv')
    # Reading a csv file in Python also has couple options.
    # Let's try NumPy's loadtxt option.
    SLA = np.loadtxt(SLAfilepath, delimiter=",", dtype=np.float64)

    # Visualize the data and determine if the data for each participant
    # seems reasonable.
    # MATLAB script uses "questdlg" for the manual sanity check.
    # You can emulate the behavior in Python, but that requires you to use
    # some modules that enable GUI options - tkinter, wxPython, or PyQt...
    # In this script we just check by pressing "enter" in the command line
    # (or the console window of your IDE)
    plt.scatter(np.arange(SLA.size), SLA, marker='o', c='none',
                edgecolors='#1f77b4', linewidths=0.8)
    plt.xlabel("Stride Number")
    plt.ylabel("SLA")
    plt.show()

    # Once the plot is closed, this question will be asked
    good = input("Does This Data Seem Reasonable? (Y/n): ")

    # Now prepare a dictionary for this participant
    # set rng again
    rng = default_rng(seed=0)
    Data[Participant_Num] = {'SLA': SLA,
                             'Good_Data': good.lower(),
                             'Age': rng.integers(20, 48, 1)[0],
                             'Weight': rng.integers(50, 90, 1)[0]}

# The last line stores the structure 'Data' as 'Data_All.mat'
# in the current working directory. Python's equivalent could be
# storing this dictionary as a pickle object.
with open('Data_All.pkl', 'wb') as f:
    pickle.dump(Data, f)

f.close()

# Later you can load the file using the following lines:
# with open('Data_All.pkl', 'rb') as f:
#   Data = pickle.load(f)
# f.close()
