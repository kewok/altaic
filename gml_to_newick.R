library(multiplex)
library(igraph)
library(ape)
library(stringr)

gml_to_newick <- function(gml_file, tree_file, output_file='Hypothesized_Tree.nex')
	{
	el <- read.gml(gml_file) # For some reason this doesn't work on igraphs only read_gml stuff
	write.table(el,'parent_child.txt', col.names=F,row.names=F)
	#z <- graph_from_edgelist(u,directed=T)

	# Note the core tree:
	core_tree <- read.tree(tree_file)
	edgeList <- matrix(nrow=nrow(core_tree$edge), ncol=ncol(core_tree$edge))

	for (i in 1:nrow(edgeList))
		{
		for (j in 1:ncol(edgeList))
			{
			edgeList[i,j] <- ifelse(core_tree$edge[i,j] <= length(core_tree$tip.label),  core_tree$tip.label[core_tree$edge[i,j]], core_tree$node.label[core_tree$edge[i,j]-length(core_tree$tip.label)])
			}
		}

	# everything else has to be a borrowing
	borrowings <- matrix(nrow=1, ncol=2)

	for (i in 1:nrow(el))
		{
		ismatch <- 0
		for (j in 1:nrow(edgeList))
			{
			if ((el[i,1] == edgeList[j,1] && el[i,2] == edgeList[j,2]))
				{
				ismatch <- 1
				}
			}
		if (!ismatch)
			{
			borrowings <- rbind(borrowings, as.character(el[i,1:2]))
			}
		}
	borrowings <- borrowings[-1,]

	# Remove borrowings from root language
	rootCases <- which(borrowings[,1]=='root')
	if (length(rootCases))
		{
		borrowings <- borrowings[-rootCases,]
		}

	N <- nrow(borrowings)

	# Now, construct the newick string; mannually put the newick string in:
	core <- readLines(tree_file)

	sourceLang_code <- c('Turkish'='tr', 'North_Azerbaijani'='na', 'ProtoOghuz'='po', 'Northern_Uzbek'='nu','Kazakh'='kz', 'Bashkir'='bk', 'Tatar'='tt','ProtoKipchak'='pk', 'Sakha'='sk','Chuvash'='cv','ProtoTurkic'='pt','Khalkha_Mongolian'='km', 'Buryat'='by','Kalmyk'='kl','ProtoMongolic'='pm', 'Evenki'='ev','Manchu'='mn', 'Nanai'='nn', 'ProtoTungus'='ptg','ProtoAltaic'='pa','Kannada'='kn','Telugu'='tg','Malayalam'='ml', 'Tamil'='tm','ProtoDravidian'='pd', 'Nganasan'='nn', 'Forest_Enets'='fe', 'Tundra_Nenets'='tn','Northern_Selkup'='ns', 'ProtoSameyadic'='ps', 'ProtoTungMong'='ptnm',  'ProtoTurkMong'='ptrm', 'ProtoTurkTung'='ptrtn', 'Japanese'='jp', 'Korean'='kr')

	descendants <- list()
	nodes <- unique(c(edgeList))
	current_borrowing <- 1
	borrowing_event_id <- c()
	for (i in 1:length(nodes))
		{
		if (length(which(borrowings[,1]==nodes[i])))
			{
			descendants[[i]] <- c(nodes[i], rep('#LGT', length(which(borrowings[,1]==nodes[i]))))
			for (j in 2:length(descendants[[i]]))
				{
				descendants[[i]][j] <- paste(sourceLang_code[nodes[i]], descendants[[i]][j], current_borrowing, sep='')
				borrowing_event_id[current_borrowing] <- descendants[[i]][j]
				current_borrowing <- current_borrowing + 1
				}
			}
		else
			{
			descendants[[i]] <- nodes[i]
			}
		}

	destinations <- list()
	for (i in 1:length(nodes)) 
		{
		current_borrowing <- 1
		destinations[[i]] <- nodes[i]

		# Check if node was ever a destination
		is_destination <- which(borrowings[,2]==nodes[i])
		if (length(is_destination))
			{
			# For each time that node was a destination
			for (j in is_destination)
				{
				source_lang <- borrowings[j,1]
				if (j != 1)
					{
					# Count how many times the entry has appeared before:
					previous_appearances <- sum(grepl(source_lang,borrowings[1:(j-1),1]))
					if (previous_appearances)
						{
						# Get the name of the borrowing event
						borrowing_event <- descendants[[which(nodes==source_lang)]][previous_appearances + 2] 		}
					else
						{
						borrowing_event <- descendants[[which(nodes==source_lang)]][2]
						}
					}
				else
					{
					borrowing_event <- descendants[[which(nodes==source_lang)]][2]
					}
				current_borrowing <- current_borrowing + 1
				destinations[[i]][current_borrowing] <- borrowing_event
				}
			}
		}

	# clean up the borrowing event name:
	for (i in 1:length(destinations))
		{
		if (length(destinations[[i]]) > 1)
			{
			for (j in 2:length(destinations[[i]])) # again, because the vector includes the language itself
				{
				destinations[[i]][j] <- paste('#', strsplit(destinations[[i]][j], '#')[[1]][2], sep='')
				}
			}
		}

	for (i in 1:length(destinations))
		{
		if (length(destinations[[i]]) > 1)
			{
			revised_destination <- paste(paste(destinations[[i]],collapse=')'),')',sep='')
			dest_lang <- destinations[[i]][1]
			if (grepl('Proto', dest_lang))
				{
				# Find the corresponding parentheses to this one: (x,y,z ->)<- Proto
				tempString <- strsplit(strsplit(core, dest_lang)[[1]][1], '')[[1]]
				counter <- 0
				answer <- 0
				# Note the length(tempString) th  should always be ')'
				for (j in length(tempString):1)
					{
					if (answer == 0)
						{
						if (tempString[j] == ')')
							{
							counter <- counter + 1
							}
						if (tempString[j] == '(')
							{
							counter <- counter - 1
							}
						if (counter == 0)
							{
							answer = j
							}
						}
					}
				tempString[answer] <- paste(rep('(', length(destinations[[i]])+1), collapse='')
				# The "+1" is needed because you are adding an edge to change (x,y,z)P -> ((x,y,z)P)
				core <- paste(paste(tempString,collapse=''), revised_destination, strsplit(core, dest_lang)[[1]][2],sep='')
				}
			else
				{
				tempString <- strsplit(revised_destination, '')[[1]]
				revised_destination <- paste(paste(rep('(', length(which(tempString==')'))), collapse=''), revised_destination, sep='') # Add the corresponding parentheses
				core <- gsub(dest_lang, revised_destination, core)
				}
			}
		}

	for (i in 1:length(descendants))
		{
		if (length(descendants[[i]]) > 1)
			{
			source_lang <- descendants[[i]][1]
			if (grepl('Proto', source_lang))
				{
				# Insert the branches into the immediately preceding parentheses
				tempBreak <- strsplit(core, paste(')', source_lang, sep=''))
				tempBreak[[1]][1] <- paste(tempBreak[[1]][1], ',', paste(descendants[[i]][2:length(descendants[[i]])], collapse=','),sep='')
				core <- paste(tempBreak[[1]][1], paste(')', source_lang, sep=''), tempBreak[[1]][2], sep='') 
				}
			else
				{
				revised_source <- paste('(', paste(descendants[[i]], collapse=','), ')',sep='')
				core <- gsub(source_lang, revised_source, core)
				}
			}
		}
	core <- gsub('_','.',core)

	cat(core, file=output_file)
	}
