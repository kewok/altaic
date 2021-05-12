source('prepare_wordLists.R')
source('make_QLC.R')
source('gml_to_newick.R')

reticulate::use_virtualenv((paste(system('git rev-parse --show-toplevel',intern=TRUE),'env',sep='/')))

construct_mln <- reticulate::import('construct_mln')$construct_mln

# Start with MicroAltaic and Dravidian:
outgroup <- 'Dravidian'
altaic_file <- 'MicroAltaic_with_Dravs'
wL <- prepare_wordList(outgroup)
make_QLC(wL, altaic_file)
# Create the gene trees
system('python calculate_word_distances.py')
source('WordLists/generate_gene_trees.R')
tree_txt <- construct_trees(dist_mat_dict)
cat(tree_txt, file='dravidian_wordTrees.txt')

fix_cognates(wL, altaic_file)

# Microaltaic is false:
tree <- 'Newick/EuralexAltaic_False_NoStruct.nex'

mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen1.nex')

# Microaltaic is false, but Tungusic and Mongolic are a group:
tree <- 'Newick/EuralexAltaic_False_TungMong.nex'

mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen2.nex')

# Microaltaic is false, but Turkic and Mongolic are a group:
tree <- 'Newick/EuralexAltaic_False_TurkMong.nex'

mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen3.nex')

# Microaltaic is false, but Turkic and Tungusic are a group:
tree <- 'Newick/EuralexAltaic_False_TurkTung.nex'

mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen4.nex')

# Microaltaic is true, but no internal structure:
tree <- 'Newick/EuralexAltaic_True_NoStruct.nex'
mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen5.nex')

# Microaltaic is true, with Tungusic and Mongolic as a group
tree <- 'Newick/EuralexAltaic_True_TungMong.nex'
mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen6.nex')

# Microaltaic is true, with Turkic and Mongolic as a group
tree <- 'Newick/EuralexAltaic_True_TurkMong.nex'
mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen7.nex')

# Microaltaic is true, with Turkic and Tungusic as a group
tree <- 'Newick/EuralexAltaic_True_TurkTung.nex'
mln_name <- construct_mln('micro_altaic', tree)
gml_to_newick(paste('micro_altaic.tsv_phybo/mln-',mln_name,'.gml',sep=''), tree, 'Newick/Scens/Scen8.nex')

system('python updateNewick.py')

