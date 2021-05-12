source('write_queue_script.R')
setwd('Newick')

k <- 1

scens <- list.files(pattern = '\\.nex$')

system('mkdir ~/alt_temp')

for (val in 1:length(scens))
	{
	system(paste('mkdir Scenario_', val, sep=''))
	setwd(paste('Scenario_', val, sep='')) # enter the Newick-combination directory
	system(paste('cp ../Sen', val, '.nex .', sep=''))
	setwd('..')
	}

write_queue_script(length(scens))
