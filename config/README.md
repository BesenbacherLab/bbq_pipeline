
# General settings
To configure this workflow, modify ``config/config.yaml`` file according to your needs, which handles the reference genome details and all tunable parameters of BBQ. 

A complete list of accepted keys with default values, expected types and human readable descriptions is available in the [config schema](https://github.com/carmenoroperv/bbq_pipeline/blob/master/workflow/schemas/config.schema.yaml).

### Reference genome
As a requirement, you need to provide a path to the reference genome FASTA file.
The workflow will then create a twoBit file of the reference genome that is used by several BBQ commands. If you already have the reference genome in the twoBit format, you can provide a path to it using the ``twobit`` key.

By default, the full reference genome is used for the analysis. You can specify regions of interest or blacklist regions with ``split_bed`` and ``exclude_bed`` keys, respectively. 

The reference genome is split into non-overlapping regions of 8Mb by default to speed up the k-mer counting and variant calling. The region length can be changed by adjusting the ``split_region_length`` key.

### BBQ
All tunable parameters of BBQ are set to the default values by the [config schema](https://github.com/carmenoroperv/bbq_pipeline/blob/master/workflow/schemas/config.schema.yaml). To modify parameter values, specify the intended key,value pair in the ``config/config.yaml`` file. 

# Sample sheet

The samples you want to call variants for should be specified in the `config/samples.tsv` file. 
As a requirement, sample name and bam_file path need to be specified. 
Optionally, you can add the `filter_bam_file` column, where you can specify the path to the aligned germline sequence data of the respective sample. The germline data will then be used to exclude germline variants during variant calling. The schema for the `samples.tsv` file can be found [here](https://github.com/carmenoroperv/bbq_pipeline/blob/master/workflow/schemas/samples.schema.yaml).
