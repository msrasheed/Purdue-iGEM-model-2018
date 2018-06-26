# Code for simple gene expression without delay

# Import relevant types
from bioscrape.types import Model
from bioscrape.simulator import DeterministicSimulator, SSASimulator
from bioscrape.simulator import ModelCSimInterface

import numpy as np
from libsbml import SBMLReader

# Load the model by creating a model with the file name containing the model
reader = SBMLReader()
# m = reader.readSBMLFromFile('splitEnzymeKinietics1.xml')
# m = m.getModel();
# print str(m.getNumSpecies()) + " species"
m = Model('splitEnzymeKinietics1.xml')
# Expose the model's core characteristics for simulation. (i.e. stoichiometry,
# delays, and propensities)
s = ModelCSimInterface(m)

# Set the initial simulation time
s.py_set_initial_time(0)

# This function uses sparsity to further optimize the speed of deterministic
# simulations. You must call it before doing deterministic simulations.
s.py_prep_deterministic_simulation()

# Set up our desired timepoints for which to simulate. 
# Must match with initial time.
timepoints = np.linspace(0,1000,1000)

# Create a DeterministicSimulator as well as an SSASimulator
ssa_simulator = SSASimulator()
det_simulator = DeterministicSimulator()

# Simulate the model with both simulators for the desired timepoints
stoch_result = ssa_simulator.py_simulate(s,timepoints)
det_result = det_simulator.py_simulate(s,timepoints)

# Process the simulation output.

# py_get_result() returns a numpy 2d array of timepoints x species.
# Each row is one time point and each column is a species.
stoch_sim_output = stoch_result.py_get_result()
det_sim_output = det_result.py_get_result()

# Get the indices for each species of interest

# From the model, we can recover which column corresponds to which species, so
# we then know which column of the result array is which species.
tysl_ind = m.get_species_index('tysl')
tase1_ind = m.get_species_index('tase1')
tase2_ind = m.get_species_index('tase2')
TT_ind = m.get_species_index('TT')
TTT_ind = m.get_species_index('TTT')
TTTHRP_ind = m.get_species_index('TTTHRP')
TMB_ind = m.get_species_index('TMB')
blueSub_ind = m.get_species_index('blueComp')


import matplotlib.pyplot as plt

# Plot the mRNA levels over time for both deterministic and stochastic simulation
plt.title("SSASimulator")
plt.plot(timepoints,stoch_sim_output[:,tysl_ind], label="tysl")
plt.plot(timepoints,stoch_sim_output[:,tase1_ind], label="tase1")
plt.plot(timepoints,stoch_sim_output[:,tase2_ind], label="tase2")
plt.plot(timepoints,stoch_sim_output[:,TT_ind], label="TT")
plt.plot(timepoints,stoch_sim_output[:,TTT_ind], label="TTT")
plt.plot(timepoints,stoch_sim_output[:,TTTHRP_ind], label="TTTHRP")
plt.plot(timepoints,stoch_sim_output[:,blueSub_ind], label="blueSub")
plt.xlabel('Time')
plt.ylabel('mRNA')

# Plot the protein levels over time 
# for both deterministic and stochastic simulation

plt.figure()
plt.title("DeterministicSimulator")
plt.plot(timepoints,det_sim_output[:,tysl_ind], label="tysl")
plt.plot(timepoints,det_sim_output[:,tase1_ind], label="tase1")
plt.plot(timepoints,det_sim_output[:,tase2_ind], label="tase2")
plt.plot(timepoints,det_sim_output[:,TT_ind], label="TT")
plt.plot(timepoints,det_sim_output[:,TTT_ind], label="TTT")
plt.plot(timepoints,det_sim_output[:,TTTHRP_ind], label="TTTHRP")
plt.plot(timepoints,det_sim_output[:,blueSub_ind], label="blueSub")
plt.xlabel('Time')
plt.ylabel('Protein')