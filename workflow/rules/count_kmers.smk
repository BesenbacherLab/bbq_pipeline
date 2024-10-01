rule count_kmers:
    input:
        unpack(get_bam),
        twobit=twobit,
    output:
        temp("results/{sample}/kmers/{region}_kmers.txt"),
    params:
        extra=get_count_kmer_params,
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 4,
        runtime=lambda wildcards, attempt: attempt * 60 * 6,
    log:
        "logs/{sample}/count_kmers/{region}.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        "bbq count --bam_file {input.bam} --twobit_file {input.twobit} --output_file_kmers {output} {params.extra} 2> {log}"


rule combine_counted_kmers:
    input:
        kmers=aggregate_kmer_counts,
    output:
        "results/{sample}/kmers/kmers.txt",
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 60,
    log:
        "logs/{sample}/count_kmers/combine_counted_kmers.out",
    conda:
        "../envs/py3_12.yaml"
    script:
        "../scripts/combine_tables.py"
