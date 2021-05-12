from lingpy import *
import numpy as np
import os

lex = LexStat('MicroAltaic_with_Dravs.QLC')
lex.get_scorer(rands=100000,limit=100000)
# so that you don't have to rerun the long get_scorer() function again:
#import jsonpickle
#import json
#import jsonpickle.ext.numpy as jsonpickle_numpy
#jsonpickle_numpy.register_handlers()
#lex_temp = jsonpickle.encode(lex)
#json.dump(lex_temp, open('microaltaic_lexstat.json','w'))
# To restore this:
#import jsonpickle
#import json
#import jsonpickle.ext.numpy as jsonpickle_numpy
#jsonpickle_numpy.register_handlers()
#lex_temp = json.load(open('microaltaic_lexstat.json'))
#lex = jsonpickle.decode(lex_temp)


for concept in lex.rows:
	if concept is lex.rows[0]:
		os.makedirs('WordTrees', exist_ok=True)
	for language1 in lex.cols:
		lang_dist_by_word = np.array([])
		for language2 in lex.cols:
			if ((len(lex.get_dict(language2)[concept])>0) & (len(lex.get_dict(language1)[concept])>0)):
				lang_dist = np.array([])
				# If there are multiple entries, take the average distances across all entries
				for word1 in lex.get_dict(language1)[concept]:
					for word2 in lex.get_dict(language2)[concept]:
						lang_dist = np.append(lang_dist, lex.align_pairs(word1, word2, method='lexstat',pprint=False)[2]) # since the third output is distance
				# make the language distance from the average if there are multiple entries
				lang_dist_by_word = np.append(lang_dist_by_word, np.average(lang_dist))
			else:
				lang_dist_by_word = np.append(lang_dist_by_word, np.nan)
		# if we are dealing with the first comparison
		if language1 == lex.cols[0]:
			word_dist = [lang_dist_by_word]
		else:
			word_dist = np.append(word_dist, [lang_dist_by_word], axis=0)
	np.savetxt(''.join(['WordTrees/', concept,'.csv']), word_dist, delimiter=',',header=','.join(lex.cols))


#exec(open("generate_gene_trees.py").read())

