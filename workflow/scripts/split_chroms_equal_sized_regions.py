#!/usr/bin/env python
import sys
import py2bit
import os

os.makedirs(os.path.dirname(snakemake.log[0]), exist_ok=True)
sys.stderr = open(snakemake.log[0], "a")
sys.stdout = sys.stderr

#TwoBit File:
print(f"Input twobit file: {snakemake.input[0]}")
t = py2bit.open(snakemake.input[0])
#region size
region_len = int(snakemake.params.region_length)
print(f"Region length: {region_len}")

#target chromosomes
target_chr = (snakemake.params.target_chr)
target_chr = [str(x) for x in target_chr]
print(f"Target chromosomes: {target_chr}")

for chrom in t.chroms():
    print(f"Splitting chromosome {chrom}")
    if str(chrom) in target_chr or target_chr[0] == "all":
        clen = t.chroms()[chrom]
        start = 0
        end = region_len
        
        if int(end) >= int(clen):
            with open(snakemake.output[0], 'a') as outfile:
                outfile.write('\t'.join([str(chrom), str(start), str(clen)]) + '\n')
            continue

        with open(snakemake.output[0], 'a') as outfile:
            outfile.write('\t'.join([str(chrom), str(start), str(end)]) + '\n')

        while int(end) <= int(clen):
            start = end
            end = start + region_len
            if int(end) < int(clen):
                with open(snakemake.output[0], 'a') as outfile:
                    outfile.write('\t'.join([str(chrom), str(start), str(end)]) + '\n')
            else:
                with open(snakemake.output[0], 'a') as outfile:
                    outfile.write('\t'.join([str(chrom), str(start), str(clen)]) + '\n')