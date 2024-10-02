rule call_variants:
    input:
        unpack(get_bam),
        twobit=twobit,
        kmerpapa="results/{sample}/kmerpapa/kmerpapa_model.txt",
    output:
        temp("results/{sample}/variants/{region}_variants.vcf"),
    params:
        extra=get_var_calling_params,
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 4,
        runtime=lambda wildcards, attempt: attempt * 60 * 6,
    log:
        "logs/{sample}/call_variants/{region}.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        "bbq call_only --bam_file {input.bam} --twobit_file {input.twobit} --input_file_kmerpapa {input.kmerpapa} --outfile {output} {params.extra} 2> {log}"


rule combine_variant_regions:
    input:
        var_calls=aggregate_var_calls,
    output:
        "results/{sample}/variants/variants.vcf",
    params:
        input_list=lambda wildcards, input: " ".join(input.var_calls),
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 60 * 2,
    log:
        "logs/{sample}/call_variants/combine_variant_regions.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        """cat {params.input_list} > {output} 2> {log}"""