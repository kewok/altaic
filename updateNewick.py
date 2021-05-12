import os
import natsort

num_gene_trees = int(sys.argv[1:][0])

# Generated from WordLists/generate_genetrees.R 
filename = 'WordTrees/dravidian_wordTrees.txt'

with open(filename) as F:
	wordTrees = F.read()

os.chdir('Newick/Scens')
newicks = os.listdir()
newicks = natsort.natsorted(newicks)

counter = 0

for filename in newicks:
	with open(filename) as f:
		file_str = f.read()
	counter = counter + 1

	file_str = '#NEXUS\n\nBEGIN NETWORKS;\n\nNetwork net = ' + file_str + '\n\nEND;\n\n' + wordTrees + '\n\nBEGIN PHYLONET;\n\n'

	gt = '(gt1, '
	for i in range(2, num_gene_trees):
		gt = gt + ' gt' + str(i) + ','
	gt = gt + ' gt' + str(num_gene_trees) + ')'
	file_str = file_str + 'CalGTProb net ' + gt + ' -o -pl 2 -r 1000' + ' output_scen_' + str(counter) + '.txt;\n\nEND;'
 
	with open(filename, 'w') as f:
		f.write(file_str)
