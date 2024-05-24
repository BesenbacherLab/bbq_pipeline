
# General settings
To configure this workflow, modify ``config/config.yaml`` according to your needs. 
``config/config.yaml`` handles the reference genome details and all tunable parameters of BBQ. 

A complete list of accepted keys with default values, expected types and human readable descriptions is available in schemas.

## Reference genome: 
As a requirement, you need to provide a path to the reference genome FASTA file.
The workflow will then create a twoBit file of the reference genome that is used by several BBQ commands. If you already have the reference genome in the twoBit format, you can provide a path to it using the ``twobit`` key.

By default the full reference genome is used for the analysis. You can specify regions of interest or blacklist regions with ``split_bed`` and ``exclude_bed`` parameters, respectively. 

To speed up the k-mer counting and variant calling, the reference genome is split non-overlapping regions of 8Mb by default. The region length can be changed by adjusting the ``split_region_length`` parameter. 

## BBQ
All tunable parameters of BBQ are set to the default values by the config schema (see ../workflow/schemas/config.schema.yaml). To modify parameter values, specify the intended key,value pair in the ``config/config.yaml``. 

# Sample and unit sheet

You can specify the samples you want to call variants for in the `config/samples.tsv` file. 
As a requirement, sample name and bam_file need to be specified. Optionally, you can add the filter_bam_file path, which represents the germline sequence of the respective sample and is used to exclude germline variants during variant calling. 
