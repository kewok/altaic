write_queue_script <- function(scens)
	{
	cat(
	paste(
'#!/bin/sh
# Submit with qsub
# Tell the SGE that this is an array job, with "tasks" to be numbered 1 to 10000
#$ -q all.q
# Try to request four cores
#$ -pe default 4
#$ -l h_vmem=75G
#$ -t 1-',
scens,
'\n#$ -V
#$ -e /home/kwo/alt_temp
#$ -o /home/kwo/alt_temp
cd ~/Altaic/Newicks/Scenario_$SGE_TASK_ID\n
java -jar PhyloNet_3.8.2.jar Sen$SGE_TASK_ID.nex', sep='')
	)
	}
