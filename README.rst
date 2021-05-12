Scripts for "Phylogenetic Perspectives on the Relative Importance of Identity by Descent versus Borrowing in the Lexica of Altaic Languages"
========================================================================================================================================================

``R``, ``python`` and ``bash`` shell scripts for the analyses that went into "Phylogenetic Perspectives on the Relative Importance of Identity by Descent versus Borrowing in the Lexica of Altaic Languages". The different branches (``main`` and ``cluster``) reflect a version of the code that prepares the input `Rich-Newick <https://wiki.rice.edu/confluence/download/attachments/5216841/RichNewick-2012-02-16.pdf?version=1&modificationDate=1330535426168&api=v2>`_ formatted files, and the instructions that were used to carry out the analyses on an HPC environment (`Minnesota Supercomputing Institute <https://www.msi.umn.edu/>`_), respectively. These scripts were run under a python virtual environment, which can be recreated via:

``python3 -m pip install -r requirements.txt``.

Basic Workflow
----------------------------------

#. Create the input files by running ``prepare_nexus.R``. The script assumes a virtual environment called ``env`` that has installed the python dependencies described in ``requirements.txt``. Some facets of the scripts may need to be uncommented in order to recreate the analyses reported in the manuscript.
#. Run the bash scripts in the branch ``cluster``.

