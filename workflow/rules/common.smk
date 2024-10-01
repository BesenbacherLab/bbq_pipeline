import os
import pandas as pd
import numpy as np

from snakemake.utils import validate
from snakemake.utils import min_version

min_version("8.0.0")


report: "../report/workflow.rst"


###### Config file and sample sheets #####
configfile: "config/config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

##### reference files #####
ref_dict = config["reference"]
if "twobit" not in ref_dict:
    fasta = ref_dict["fasta"]
    twobit_prefix = ".".join(os.path.basename(fasta).split(".")[:-1])
    twobit = f"resources/{twobit_prefix}.2bit"
else:
    twobit = ref_dict["twobit"]

if "split_bed" not in ref_dict:
    region_length = ref_dict["split_region_length"]
    twobit_prefix = ".".join(os.path.basename(twobit).split(".")[:-1])
    ref_split_bed = f"resources/{twobit_prefix}.bed"
else:
    ref_split_bed = ref_dict["split_bed"]


##### Helper functions #####


def get_target_chr():
    # select only a set of chromosomes, if chrom list is given in config else include all chrom
    if "chr_list" in config["reference"]:
        target_chr = config["reference"]["chr_list"]
    else:
        target_chr = ["all"]
    return target_chr


def get_regions(wildcards):
    regions = []
    # select only a set of chromosomes, if chrom list is given in config else include all chrom
    target_chr = get_target_chr()

    if "split_bed" in config["reference"]:
        ref_split_bed = ref_dict["split_bed"]
    else:
        ref_split_bed = checkpoints.make_ref_split_bed.get().output[0]

    with open(ref_split_bed) as f:
        for line in f:
            chrom, start, end = line.split()[0:3]
            if chrom in target_chr or target_chr[0] == "all":
                regions.append(f"{chrom}:{start}-{end}")
    return regions


def aggregate_kmer_counts(wildcards):
    regions = get_regions(wildcards)

    return expand(
        "results/{{sample}}/kmers/{region}_kmers.txt",
        region=regions,
    )


def aggregate_var_calls(wildcards):
    regions = get_regions(wildcards)

    return expand("results/{{sample}}/variants/{region}_variants.vcf", region=regions)


def get_bam(wildcards):
    return {"bam": samples.loc[wildcards.sample]["bam_file"]}


def get_region_str(wildcards):
    return "--region {} ".format(wildcards.region)


def lookup_config(prop, step, param):
    try:
        if step != "":
            step = f"{step}/"
        value = lookup(dpath=f"{prop}/{step}{param}", within=config)
        param_str = "--{} {} ".format(param, value)
    except LookupError:
        param_str = ""
    except WorkflowError:
        param_str = ""

    return param_str


def check_filter_bam(wildcards):
    if "filter_bam_file" in samples.columns:
        return "--filter_bam_file {}".format(
            samples.loc[wildcards.sample]["filter_bam_file"]
        )
    else:
        return ""


def get_global_bbq_params(extra):
    if "global" in config["bbq"]:
        for param in config["bbq"]["global"]:
            if param != "bbq_path":
                extra += lookup_config("bbq", "global", param)
    return extra


def get_count_kmer_params(wildcards):
    extra = ""

    if "bbq" in config:
        extra += get_global_bbq_params(extra)
        if "kmer_counting" in config["bbq"]:
            for param in config["bbq"]["kmer_counting"]:
                extra += lookup_config("bbq", "kmer_counting", param)

    extra += lookup_config("reference", "", "exclude_bed")
    extra += get_region_str(wildcards)
    extra += check_filter_bam(wildcards)

    return extra


def get_kmerpapa_params():
    extra = ""

    if "bbq" in config and "kmerpapa" in config["bbq"]:
        for param in config["bbq"]["kmerpapa"]:
            extra += lookup_config("bbq", "kmerpapa", param)

    return extra


def get_var_calling_params(wildcards):
    extra = ""

    if "bbq" in config:
        extra += get_global_bbq_params(extra)
        if "variant_calling" in config["bbq"]:
            for param in config["bbq"]["variant_calling"]:
                extra += lookup_config("bbq", "variant_calling", param)

    if (
        "no_positional_update" in config["bbq"]["variant_calling"]
        and config["bbq"]["variant_calling"]["no_positional_update"]
    ):
        extra += "--no_update "

    extra += lookup_config("reference", "", "exclude_bed")
    extra += get_region_str(wildcards)
    extra += check_filter_bam(wildcards)

    return extra


def get_coverage_filter_params():
    extra = ""

    extra += lookup_config("bbq", "coverage_filtering", "lower_q")
    extra += lookup_config("bbq", "coverage_filtering", "upper_q")

    return extra
