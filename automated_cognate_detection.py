from lingpy import *
from lebor.borrowings import external_cognates
from lebor.util import flatten
from tabulate import tabulate
from lebor.algorithm import cogids2cogid
from lebor.cognates import internal_cognates
from lingpy.compare.sanity import average_coverage

def make_cognates(qlc_file_name):
	# Identify the cognates within each language family, using the same threshold in the SEA case study
	wl = Wordlist(str(qlc_file_name) + '.QLC')
	internal_cognates(wl,debug=True,threshold=0.5,bins='bins')
	cogids2cogid(wl, ref='cogids', cognates='cogid', morphemes='morphemes')
	wl.output('tsv', filename=qlc_file_name, ignore='all',prettify=True)

	# Identify the browings across each language family, using the same threshold in the SEA case study
	wl = Wordlist(str(qlc_file_name) + '.tsv')
	external_cognates(wl, verbose=False,threshold=0.3,method='parsody') # Note default uses SCA
	wl.output('tsv', filename=qlc_file_name,ignore='all',prettify=False)

	# Print summary statistics 
	etd = wl.get_etymdict('cogid')
	etd2 = wl.get_etymdict('borid')
	allcogs = len(etd)
	fullcogs = len([x for x, y in etd.items() if len(flatten(y)) > 1])
	table = [['languages', wl.width],
		['cognates', wl.height],
		['words', len(wl)],
		['cognate sets', allcogs], 
		['non-unique', fullcogs], 
		['singletons', allcogs-fullcogs],
		['borrowing candidates', len(etd2)-1]
		]
	print(tabulate(table))


