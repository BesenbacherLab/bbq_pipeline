Somatic variants were called using the Better Base Quality (BBQ) tool: 

{% if snakemake.config["reference"]["twobit"] %}

* User provided twoBit reference file was used as a reference sequence. 
{% else %}

* User provided reference FASTA file was converted to a twoBit format and used as a reference sequence. 
{% endif %}

{% if snakemake.config["reference"]["chr_list"] %}
* Variants were called from chromosomes: {{ snakemake.config["reference"]["chr_list"] }}
{% else %}
* Variants were called from all chromosomes. 
{% endif %}


1. {{ (snakemake.config["bbq"]["kmer_counting"]["radius"]*2)+1 }}-mers surrounding concordant and discordant overlaps were counted for each base quality and mutation type combination. 

2. `kmerPaPa`_ model was trained using the {{ snakemake.config["bbq"]["kmerpapa"]["kmerpapa_method"] }} algorithm to partition the {{ (snakemake.config["bbq"]["kmer_counting"]["radius"]*2)+1 }}-mers into patterns. 
{% if snakemake.config["bbq"]["variant_calling"]["no_positional_update"] == True %}

3. Error rate estimation was done based on the {{ (snakemake.config["bbq"]["kmer_counting"]["radius"]*2)+1 }}-mer pattern counts. 
{% else %}

3. Error rate estimation was done based on the {{ (snakemake.config["bbq"]["kmer_counting"]["radius"]*2)+1 }}-mer pattern counts and position-specific information.
{% endif %}

4. Variant calling was carried out based on the likelihood-ratio test. All variants with quality above {{ snakemake.config["bbq"]["variant_calling"]["cutoff"] }} were returned. 


.. _kmerPaPa: https://www.nature.com/articles/s41467-022-35596-5