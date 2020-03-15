# rodent-behavior-analysis
Code for analyzing rodent behavioral data

The most useful function for analyzing and visualizing the rat data is analyzeTaskData.m. Below is the usage guide. 
You must provide the working directory for where the trial data is stored. 
Default is '/snel/share/data/trialLogger/RATKNOBTASK/' stored in a basedir directory.

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  Authors: Tony Corsten, Feng Zhu, and Sean O'Connell
  
  Purpose: this is an automated analysis suite that takes rat name and
  pulls available tasks that rat has completed. You can then select one or
  multiple sessions to produce task-related results and plots.
  
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    Function Usage:
  
                 0) analyzeTaskData() <-this will plot with traditional GUI
 
                 1) analyzeTaskData('xy') <-- for rats X and Y (default number of sessions is 1)
 
                 2) analyzeTaskData('ZX',numSessEachRat) <--for rats X and Z
 
                 3) analyzeTaskData('vwxy',numSessEachRat,plotStr) <--
                      --> plotStr can equal 'scat','kin','cyc', or 'png'
                          ^^^ set plotStr to 'png' to skip plotting and ^^^
                          generate png's of the default plot type (scatter)
 
                 4) analyzeTaskData(('xyz',numSessEachRat,plotStr,pngFlag)) <--
                      --> pngFlag can be set to 'png' this will create a
                          png in the appropriate folder for the selected
                          plot type (chosen with plotStr)
 
  By default, PNGs are saved to:
  /snel/share/data/trialLogger/RATKNOBTASK_PNGfiles/[sessionDate]/[ratName]_[plotType].png
  
  -------------------------------------------------------------------------
  
   If you have the Parallel Computing Toolbox, this function will execute
   50-70% faster (runs in about 60% of the time) because we used a parfor()
   on the most computationally intensive line of this function: loading the
   trials inside selectedSessionsToTrials()
   
   -------------------------------------------------------------------------
