# HWRF_largescale_crh

Adding a repo to share my large scale scripts with the rest of the Hurricane Task.

A few notes about the contents:

run_seranl.ksh
  - Loops through different experiments, variables, levels to submit the SerAna_run.sh job to the batch system
  - Using the forecast hour loop in the submit script results in hundreds of jobs submitted to queue, so I moved it to the SerAna_run.sh and it loops through all fcst hours in one batch job.
  - I typically only did daily large scale analysis. 6 hour was too much data, but can be done.

SerAna_run.sh
  - Give it an experimental file list and an analysis file list
  - It calls config_template.sh to make a config file for running MET
  - Config is set in a loop in run_seranl.ksh 
  - Runs series_analysis with given configuration

config_template.sh
  - Creates a config file and stores it in a subdirectory for each of the configurations defined in the loops of run_seranl.ksh and SerAna_run.sh
  - Vertical level units check is crude for choice between pressure and height since I only did 2 and 10 m height levels and no high atmospheric pressure levels. 
  - Hard coded for the statistical output types.

plot_stats_template.sh
  - Loops through experiments, variables, and levels in the shell and gives on template ncl script then runs it 
  - Each template ncl script loops through the forecast hours
  - Writes the averages over EP, AL, and entire domain (mega domain of years past) on the plots, and to a text file named text_fn.

** dir: matlab_scripts **

plot_expt_hov.m
  - So sorry about the lack of comments!
  - Plots the averaged data on height vs time plots 


