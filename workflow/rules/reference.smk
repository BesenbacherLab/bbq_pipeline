if not "twobit" in config["reference"]:
    rule faToTwoBit_fa:
        input:
            fasta
        output:
            twobit,
        resources:
            mem_mb=lambda wildcards, attempt: attempt * 1024 * 6,
            runtime=lambda wildcards, attempt: attempt * 45,
        log:
            "logs/fa_to_2bit.log",
        wrapper:
            "v3.9.0-14-g476823b/bio/ucsc/faToTwoBit"

if not "split_bed" in config["reference"]:
    checkpoint make_ref_split_bed: 
        input:
            twobit,
        output: 
            ref_split_bed,
        params: 
            region_length = region_length,
            target_chr = get_target_chr(),
        resources:
            mem_mb=lambda wildcards, attempt: attempt * 1024,
            runtime=lambda wildcards, attempt: attempt * 45,
        log:
            "logs/make_ref_split_bed.log",
        conda: 
            "../envs/py3_12.yaml",
        script:
            "../scripts/split_chroms_equal_sized_regions.py"
