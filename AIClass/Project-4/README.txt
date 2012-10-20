I have included two files:
  - src-gui.zip
  - src-cli-runner.zip

As described in the report, co-routines were not possible within the GUI
application (due to framework-specific issues). So, the "dynamic" portion
of the GUI was not implemented. However, instead of rewriting the structure
of the program to get that part working, I implemented a CLI runner that
I also used to collect the run-data (in a CSV format). 

This cli-runner uses co-routines (Ruby Fibers) to iteratively return
results of the GA as they are generated (by yielding control and a value
to the calling code in the "evolution" look).
