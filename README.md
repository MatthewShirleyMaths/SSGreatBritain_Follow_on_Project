# SSGreatBritain_Follow_on_Project
Code and files generated during the Knowledge Exchange Hub for Mathematical Sciences Study Group Follow on Project with the SS Great Britain Trust

Author: Matthew Shirley. contact: matthewshirley.maths@gmail.com 27/02/2026


This repository contains the main code developed during the 3 week KE Hub Study Group Follow on project. It can simulate airflow and moisture transport in a 2D cross-section of the dry dock of the SS Great britain.


The main file is SSGreatBritainCrossSectionSimulation.mph which is a COMSOL model file containing the problem formulation, geometry, mesh, plotting, and exports used to analyse the problem.  The physical parameters are all set as global paramteters.  The geometry is created by loading a .dxf file, then manually assigning each boudary to the correct selection (The group by continuous tangent option speeds this up). The mesh is created using COMSOL's default finer settings. The physical x,y dimensions are in mm to match those given in the .dxf file.

For the airflow we solve the incompressible Navier-Stokes equations with a k-omega turbulence models. No flux and no slip boundary conditions are applied on all boundaries except the jet inlets, which are unidirectional flow, and the outlet, which has a fixed pressure.  

The transport of water vapour concentration is governed by an advection diffusion eqaution. Both the molar and turbulent diffusion coefficients are defined in global parameters, and can be switched between in the fluid sub-node. There is no flux of water vapour through the roof and hull. The concentration on the walls and floor is equivalent to a RH of 100% at 10 degrees Celsius. The concentration of the air exiting the jets is equivalent to a RH of 5% at 25 degC.


The solution consists of two studies.  
Study 1 is a parameteric sweep slowly increasing the velocity of airflow out the jet, so that solutions at a higher velocity can be found via continuation.

Study 2 takes the solution found by Study 1 at a particular jet velocity and solves the advection diffusion equation. The 1D plot groups are set up to calculate the resulting relative humidity on the hull.


To create additional geometries, other slices of the drydock could be traced in inkscape to create neww .dxf files. It is recommended to slightly round every sharp corner while tracing as it improves solver convergence.


To analyse the relative humidity distribution along the hull further, it can be exported as a .txt file. A helper function is included to load this data into matlab.


