#!/usr/bin/python3
"""
Written by Jinseok Oh, Ph.D.
Translating S1_Simulate_Adaptation_Data.m, prepared by Dr. James Finley
The original code can be found at this repo:
    reprorehab/reprorehab2022
Original comments also copied here. If you have any questions about this code,
please send an email to joh@chla.usc.edu.

% Here, we will simulate data from a study of split-belt treadmill
% adaptation. Changes in performance during motor adaptation tasks are
% often modeled using a double-exponential function that can capture early,
% rapid changes in performance, as well as more gradual changes that impact
% performance during the latter portions of adaptation.
% 
% We will use this knowledge to generate artifial data from a
% double-exponential function that has the following form. 
%
% $$SLA = A_f*e^{-B_f*n} + B_f*e^{-B_s*n}$$
%
% To generate a realistic dataset, we simulate three sources of variability
% covered observed in this type of data. First, we simulate intersubject
% variability by randomly selecing coefficients (A_f and A_s) and rate
% terms (B_s and B_f) from normal distributions centered at values taken
% from the literature. Second, we simulate noisy measurements and
% stride-by-stride variability by adding noise to the simulated step length
% asymmetry values. Lastly, since typical adaptation studies use a fixed
% _duration_ of adaptation, each participant may take a different number of
% total strides (largely because of differences in leg length). We simulate
% this source of variability by having each participant take between 800
% and 1100 total strides.
"""
import os
import numpy as np
from numpy.random import default_rng
import matplotlib.pyplot as plt
import argparse

# Only useful when using the CLI
parser = argparse.ArgumentParser()
parser.add_argument("N_Participant", help="Number of participants", type=int)
args = parser.parse_args()

def S1_Simulate_Adaptation_Data(N_Participants):
    # This is NOT equal to rng('default')
    # [Note] The difference comes from the choice of algorithm
    # to generate random numbers. NumPy's default is PCG64.
    # MATLAB's default seems to be MT19937, but not sure.
    rng = default_rng(seed=0)

    # MATLAB's `mkdir` == Python's `os.mkdir`
    data_outdir = os.path.abspath("./Simulated_Adaptation_Data")
    if not os.path.exists(data_outdir):
        os.mkdir(data_outdir)
    # MATLAB's `cd`
    Home = os.path.abspath(os.curdir)

    # [Note] In the original script, the numbers are 16 and 4
    # Shouldn't 16 actually be N_Participants?
    True_Parameters = np.zeros((N_Participants, 4))

    # Prepare to plot figures
    NN = np.ceil(np.sqrt(N_Participants)).astype('int')
    Q, R = divmod(N_Participants, NN)
    if Q == NN or all((Q == NN-1, R > 0)):
        fig, ax = plt.subplots(nrows=NN, ncols=NN, sharex=True, sharey=True)
    else:
        fig, ax = plt.subplots(nrows=NN-1, ncols=NN, sharex=True, sharey=True)

    for Participant_Num in range(N_Participants):
        os.chdir(data_outdir)

        # Create subdirectory for each participant: 00-99
        pfolder = ''.join(['20230925_S', "{:02}".format(Participant_Num)])
        if not os.path.exists(pfolder):
            os.mkdir(pfolder)
        os.chdir(pfolder)

        # Specify the number of strides for each participant as a random value
        # between 800 and 1100.
        Total_Strides = rng.integers(800, 1100, 1)[0]

        # Create a "time" vector with units of strides
        Stride_Num = np.arange(Total_Strides)

        # Specify the fast and slow coefficients. The sum of A_Fast and A_Slow
        # are approximately equal to the initial step length asymmetry.
        # Note that each coefficient has a nominal value of -0.05 and we
        # introduce between-subjects variability by taking a random value
        # between -0.5 and 0.5 and multiplying that number by 0.1. This results
        # in coefficients that range from -0.1 to 0.
        # [Note] MATLAB's rand: uniformly distributed pseudorandom numbers
        A_Fast = -0.05 + 0.1*(rng.uniform(0, 1, 1)[0] - 0.5)
        A_Slow = -0.05 + 0.1*(rng.uniform(0, 1, 1)[0] - 0.5)

        # B_Fast and B_Slow are the time constants of the fast and slow
        # components of adaptation. The fast time constant should be larger
        # than the slow time constant. Again, we add some random variability to
        # these parameters to introduce between-subjects variance. The nominal
        # values for these parameters were taken from Mawase et al., 2013,
        # Journal of Neurophysiology.
        B_Fast = 0.025 + 0.01*(rng.uniform(0, 1, 1)[0] - 0.5)
        # [Note] MATLAB code uses randn where randn(N) returns
        # an N-by-N matrix containing pseudorandom values drawn from the
        # standard normal distribution.
        B_Slow = 0.0011 + 0.0004*(rng.standard_normal(1)[0] - 0.5)

        # Store the true values of the parameters for each participant. We will
        # use this as our ground truth to determine if we can accurately
        # estimate these parameters from our simulated data. Generating data
        # from a model with known parameters and then estimating those
        # parameters is useful tool for validating your model fitting procedure.
        True_Parameters[Participant_Num, :] = [A_Slow, B_Slow, A_Fast, B_Fast]

        # Assume that each participant has normally distributed measurement
        # noise, and that the amplitude of this noise varies uniformly across
        # participants. The values used for noise amplitude were hand picked to
        # generate data sets that lookk fairly realistic. It would also be
        # possible to directly measure the variability of true experimental
        # data to obtain realistic values of noise.
        Noise_Amplitude = 0.02*rng.uniform(0, 1, 1)[0] + 0.005
        Measurement_Noise = Noise_Amplitude*rng.standard_normal(Stride_Num.size)

        # Generate step length asymmetries (SLA) for each participant by adding
        # measurement noise to the step length asymmetries that would be
        # generated by the double exponential model.
        # [Note] "\" and newline is equal to "..." in MATLAB
        SLA = A_Fast * np.exp(-B_Fast*Stride_Num) +\
                A_Slow*np.exp(-B_Slow*Stride_Num) +\
                Measurement_Noise

        # Switch order and save SLA first to a csv file.
        csvname = ''.join(['20230925_S', f"{Participant_Num:02d}_pySLA.csv"])
        np.savetxt(csvname, SLA, delimiter=',')

        os.chdir(data_outdir)
        np.savetxt('True_Parameters.csv', True_Parameters, delimiter=',')
        os.chdir(Home)

        # Plot the raw step length asymmetry data for all participants
        q, r = divmod(Participant_Num, NN)
        ax[q, r].scatter(Stride_Num, SLA, marker='o', c='none',
                         edgecolors='#1f77b4', linewidths=0.8, alpha=0.8)
        # ax[q, r].set_xlabel("Stride Number")
        # ax[q, r].set_ylabel("Step Len. Asym")

    fig.text(0.5, 0.03, "Stride Number", ha="center")
    fig.text(0.03, 0.5, "Step Len. Asym", va="center", rotation="vertical")
    # save each participant's figure.
    plt.savefig("Simulation_Result.png")

    plt.show()


# If you're not using the CLI, provide the specific value of N_Participant
# (ex. 16)
S1_Simulate_Adaptation_Data(args.N_Participant)
