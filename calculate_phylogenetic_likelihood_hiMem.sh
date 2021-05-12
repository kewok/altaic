#!/bin/sh -l
# Submit with sbatch --array=1-8 jobscript.sh
#SBATCH --time=96:00:00
#SBATCH --partition=amdsmall
#SBATCH --cpus-per-task=2
#SBATCH --mem=100G
module load java
cd /path/to/altaic/Newick/Scens/
java -jar -Xmx100g PhyloNet_3.8.2.jar Scen$SLURM_ARRAY_TASK_ID.nex
