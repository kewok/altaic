# Read in the full database that was downloaded:

prepare_wordList <- function(outgroup, scope='Micro')
	{
	BigWordList <- read.delim('WordLists/northeuralex-0.9-forms.tsv')

	# The language ISO codes are:
	all_langs <- read.delim('WordLists/northeuralex-0.9-language-data.tsv')
	all_langs[,1] <- as.character(all_langs[,1])
	for (i in 1:nrow(all_langs))
		{
		all_langs[i,1] <- ifelse(grepl(' ', all_langs[i,1]), sub(' ','_',all_langs[i,1]), all_langs[i,1]) 
		all_langs[i,1] <- ifelse(grepl('-', all_langs[i,1]), sub('-','_',all_langs[i,1]), all_langs[i,1]) 
		}

	if (scope=='Macro')
		{
		alt_langs <- c(which(all_langs[,'family']=='Turkic'), which(all_langs[,'family']=='Mongolic'), which(all_langs[,'family']=='Tungusic'), which(all_langs[,'family']=='Japonic'), which(all_langs[,'family']=='Koreanic'))
		}
	else
		{
		alt_langs <- c(which(all_langs[,'family']=='Turkic'), which(all_langs[,'family']=='Mongolic'), which(all_langs[,'family']=='Tungusic'))
		}

	# For outgroups:
	if(length(which(all_langs[,'family']==outgroup)))
		{
		otgrp <- which(all_langs[,'family']==outgroup)
		}
	if(length(which(all_langs[,'subfamily']==outgroup)))
		{
		otgrp <- which(all_langs[,'subfamily']==outgroup)
		}

	Altaic_WordList <- BigWordList[1,]
	for (i in alt_langs)
		{
		lang_words <- which(BigWordList[,'Language_ID']==as.character(all_langs[i,'iso_code']))
		Altaic_WordList <- rbind(Altaic_WordList, BigWordList[lang_words,])
		}
	Altaic_WordList <- Altaic_WordList[-1,]

	# Add the outgroups:

	for (i in otgrp)
		{
		lang_words <- which(BigWordList[,'Language_ID']==as.character(all_langs[i,'iso_code']))
		Altaic_WordList <- rbind(Altaic_WordList, BigWordList[lang_words,])
		}

	find_family <- function(x)
		{	
		as.character(all_langs[which(all_langs[,'iso_code']==as.character(x)),'family'])
		}

	Altaic_WordList <- cbind(Altaic_WordList, sapply(Altaic_WordList[,'Language_ID'], find_family))
	colnames(Altaic_WordList) <- c(colnames(Altaic_WordList[,1:(ncol(Altaic_WordList)-1)]), 'Family')

	# Exclude entries that are not present in all languages:
	words <- unique(Altaic_WordList[,'Concept_ID'])
	Altaic_WordList2 <- Altaic_WordList[1,]
	for (i in 1:length(words))
		{
		subset <- Altaic_WordList[which(Altaic_WordList[,'Concept_ID']==words[i]),]
		if (length(unique(subset[,'Language_ID'])) == length(unique(Altaic_WordList[,'Language_ID'])))
			{
			Altaic_WordList2 <- rbind(Altaic_WordList2, subset)
			}
		}
	Altaic_WordList2 <- Altaic_WordList2[-1,]
	Altaic_WordList <- Altaic_WordList2[order(Altaic_WordList2[,'Language_ID'], Altaic_WordList2[,'Concept_ID']),]

	return(Altaic_WordList)
	}
