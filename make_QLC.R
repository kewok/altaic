library(reticulate)

make_QLC <- function(wordList, LanguageGroup)
	{
	all_langs <- read.delim('WordLists/northeuralex-0.9-language-data.tsv')
	all_langs[,1] <- as.character(all_langs[,1])
	
	frontMatter <- paste("#wL\nID\tDOCULECT\tCONCEPT\tGlossID\tOrthography\tIPA\tTokens\tCOGID\tFamily\n#")

	GlossIDS <- unique(wordList[,'Concept_ID'])
	QLC_file <- c(frontMatter)
	for (i in 1:nrow(wordList))
		{
		# Add instructions for using the original language name instead of iso code
		QLC_file <- c(QLC_file, '\n', paste(i,all_langs[which(as.character(all_langs[,'iso_code'])==wordList[i,'Language_ID']),1], wordList[i,'Concept_ID'], which(GlossIDS==wordList[i,'Concept_ID']), wordList[i,'Word_Form'], wordList[i,'rawIPA'], wordList[i,'IPA'],wordList[i,'concept_ID'],wordList[i,'Family'],sep="\t"))
		}
	cat(QLC_file, file=paste(LanguageGroup,".QLC",sep=""))
	}

# fix_cognates conducts the automated cognate/borrowing detection from lebor, and updates the micro_altaic.tsv to use borrowed cognates as the COGID variable for each entry
fix_cognates <- function(wordList, LanguageGroup)
	{
	# Use lebor functionality to detect borrowings 
	cognates <- reticulate::import('automated_cognate_detection')
	cognates$make_cognates(LanguageGroup)

	# Then fix the cognate IDs in R
	ji <- read.delim(paste(LanguageGroup, '.tsv', sep=''),sep='\t', stringsAsFactors=FALSE)

	# Remove spaces
	fix_space <- which(grepl(' ', ji[,'DOCULECT']))
	for (i in 1:length(fix_space))
		{
		ji[fix_space[i],'DOCULECT'] <- as.character(gsub(' ', '_', ji[fix_space[i],'DOCULECT']))
		}

	## Replace the cognate ID by the borrowed ID:
	ji[,'COGID'] <- ifelse(ji[,'BORID'], ji[,'BORID'],ji[,'COGID'])

	ji <- ji[,-which(names(ji)=='BORID')]
	write.table(ji, file='micro_altaic.tsv',sep='\t',row.names=F, quote=F)
	}
