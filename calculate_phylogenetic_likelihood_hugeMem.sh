#!/bin/sh -l
# Submit with sbatch --array=1-8 jobscript.sh
# Use this version of slurm workload manager script for cases where you need more RAM
#SBATCH --time=96:00:00
#SBATCH --partition=amd2tb
#SBATCH --cpus-per-task=2
#SBATCH --mem=750G
module load java
cd /path/to/altaic/Newick/Scens/
java -jar -Xmx750g PhyloNet_3.8.2.jar Scen$SLURM_ARRAY_TASK_ID.nex
