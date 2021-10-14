# Davis *et al.*, 2021.

This repository contains the source code and source data from

Davis\*, Benigno\*, Fletterman\*, Desbordes, Steward, Sejnowski, Reynolds, Muller. 2021. Spontaneous traveling waves naturally emerge from horizontal fiber time delays and travel through locally asynchronous-irregular states. *Nature communications*. \*equal contribution

The simulated data from this paper were generated with NETSIM (github.com/mullerlab/NETSIM), an efficient spiking neural network simulator written in C, capable of simulating dynamics of networks on the order of one million neurons on a local machine.

## Repo layout:
-`realData.m` points to the real data used, which are located in the folder `real-data`.

-`simulatedData.m` contains source code to simulate any of the network models from the paper. First, save the "NETSIM" folder (github.com/mullerlab/NETSIM) into the root directory. Then, specify, in the form of a keyword string, which network model to simulate. The code will automatically create the folder `simulated-data` and an appropriately named subfolder for the outputs of the specified network. Simulation is accomplished from MATLAB via a wrapper function of NETSIM. Commands for the presented analyses (_e.g._, instantaneous wavelength calculation) are also contained here.

##
**Code Authorship:** Analysis MATLAB code by Zac Davis except where stated otherwise. Functional organization of MATLAB code by Gabriel Benigno.

**Contact:** zdavis@salk.edu
