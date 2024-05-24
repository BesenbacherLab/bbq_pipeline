#!/usr/bin/env python
import sys
import argparse
import os

# log and printing
os.makedirs(os.path.dirname(snakemake.log[0]), exist_ok=True)
sys.stderr = open(snakemake.log[0], "a")
sys.stdout = sys.stderr

input_files = list(snakemake.input.kmers)
parser = argparse.ArgumentParser(description='''
    combine tables with first columns being identifiers and remaining columns being counts
    ''')

parser.add_argument('--n_ids', '-n',
                    default=-1, type=int,
                    help='Number of identifier columns')

args = parser.parse_args()
n_cols = 0
D = {}
header = None

print(f"Number of files: {len(input_files)}")
file_counter = 0
for file_i in input_files:
    file_counter += 1
    print(f"Working on k-mer file: {file_counter}")
    file = open(file_i, 'r')
    for line in file:
        if n_cols == 0:
            n_cols = len(line.split())
            try:
                L = line.split()
                counts = [int(x) for x in L[args.n_ids:]]
            except:
                header = line
        if line == header:
            continue

        L = line.split()
        assert len(L) == n_cols
        counts = [int(x) for x in L[args.n_ids:]]
        key = tuple(L[:args.n_ids])
        if key not in D:
            D[key] = [0]*len(counts)
        for i in range(len(counts)):
            D[key][i] += counts[i]
    
if not header is None:
    a = header.strip()
    with open(snakemake.output[0], 'w') as outfile:
        outfile.write(a.strip('"') + '\n')
for key in D:
    a = [' '.join(key), ' '.join(str(x) for x in D[key])]
    a = ' '.join(a)
    with open(snakemake.output[0], 'a') as outfile:
        outfile.write(a.strip('"') + '\n')

    
