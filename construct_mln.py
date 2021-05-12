"""
Carry out MLN analyses following the script of JM List et al. used in the paper "Networks of lexical borrowing and lateral gene transfer in language and genome evolution"
"""

__author__="Based off of script by Johann-Mattis List"
__date__="2020-08-27"


from lingpy import *
from lingpy.compare.phylogeny import PhyBo
from lingpy.settings import rcParams
import matplotlib as mpl

# switch to verbose output
rc(verbose=True)

def construct_mln(tsv_file, newick_tree):
	tre = PhyBo(str(tsv_file)+'.tsv', degree=175, missing=0, tree=newick_tree)
	tre.analyze(runs = 'default', plot_dists = True, gpl = 1, push_gains = True, missing_data = 0, homoplasy = 0.05)
	# get the minimal lateral network. Assume, for now a threshold of 1% of the total number of words to count as a borrowing
	tre.get_MLN(tre.best_model, method='mr', threshold=10) 
	# plot the MLN
	tre.plot_MLN(tre.best_model)
	return(tre.best_model)


