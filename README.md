# WGT-Altruism-Model-Code
Code used for the simulations that are reported in the submission to BMC Ecology and Evolution, "The role of the ecological scaffold in the origin and maintenance of whole-group trait altruism in microbial populations.", September 2022

Single_Population_Simulation.m - Simulates the macroevolutionary dynamics of a single microbial population in which cells can sometimes switch by mutation between A-type (whole-group trait altruist, produces a publicg good at a cost) S-type (selfish, does not produce the publicg good).

Metapopulation_Simulation.m - Simulated the macroevolutionary dynamics in a metapopulation.

PopModel.m - MATLAB function, maps an ancestral population some generations forward in time to produce a descendant population.

RandomMigration.m - MATLAB function, implements a round of random migration events, where migration propagules are drawn from donor groups and places into recipient groups within a metapopulation.

SelectiveMigration.m - MATLAB function, implements a round of selective migration events, where migration propagules are drawn from donor groups and places into recipient groups within a metapopulation.

TraitGroup.m - MATLAB function, implements trait-group selection, where the members of all groups within a metapopulation are places into a common pool and then randomly redistributed to form a new groups.

LatticeNetwork.m - MATLAB function, contructs the metapopulation structure.

bubblePlot.m - MATLAB function, generates a graphic representation of the metapopulation.
