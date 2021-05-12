library(phangorn)
library(readr)

# Collect the word trees and generate the inputs for Phylonet

# Subdirectory with word-wise distance matrices 
dist_mat_dict <- 'WordTrees/'

construct_trees <- function(dist_mat_dict)
	{
	# Read each distance matrix
	words <- list.files(dist_mat_dict,pattern = '\\.csv$')
	word_trees <- list()

	# Prepare the UPGMA trees
	for (i in 1:length(words))
		{
		distMat <- as.matrix(read.csv(paste(dist_mat_dict,words[i],sep='')))

		# Fix some formatting for easier use downstream:
		colnames(distMat) <- c('Bashkir',colnames(distMat)[2:ncol(distMat)])

		# Remove NAs. Since Khalkha is complete as a dataset:
		bad_langs <- which(is.na(distMat[,'Khalkha.Mongolian']))
		if (length(bad_langs))
			{
			distMat <- distMat[-bad_langs,-bad_langs]
			}
		word_trees[[i]] <- upgma(distMat)
		}

	# Prepare the formatting for phylonet of the word trees
	TREES <-''
	print('preparing TREES argument for Phylonet input file')
	pb <- txtProgressBar(style=3, min=0,max=length(words))
	for (i in 1:length(words))
		{
		# Create a temporary file. A hack as write_nexus doesn't let you directly interact with the text string. 
		write.nexus(word_trees[[i]], file='temp.txt', translate=FALSE)
		raw_lines <- read_lines('temp.txt') 
		tree_line <- raw_lines[which(grepl('TREE \\* UNTITLED',raw_lines))]
		tree <- strsplit(tree_line,'\\[\\&R\\] ')[[1]][2]
		TREES <- paste(TREES, paste('\nTree gt', i,sep=''), '=', tree)
		system('rm temp.txt')
		setTxtProgressBar(pb, i)
		}

	return(paste('BEGIN TREES;',TREES,'END;',sep='\n'))
	}




