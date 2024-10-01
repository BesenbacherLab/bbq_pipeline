rule coverage_filter_PASS_variants:
    input:
        vcf="results/{sample}/variants/variants.vcf",
    output:
        "results/{sample}/variants/variants_cov_filter.vcf",
    params:
        extra=get_coverage_filter_params(),
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 2,
        runtime=lambda wildcards, attempt: attempt * 60,
    log:
        "logs/{sample}/filter_variants/coverage_filter_PASS_variants.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        "bbq filter_calls --vcf_file {input.vcf} --outfile {output} {params.extra} 2> {log}"


rule filter_PASS_calls:
    input:
        "results/{sample}/variants/variants_cov_filter.vcf",
    output:
        "results/{sample}/variants/variants_cov_filter_PASS.vcf",
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 60,
    log:
        "logs/{sample}/filter_variants/filter_PASS_calls.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        """awk '{{ if ($7 == "PASS") {{ print }} }}' {input} > {output} 2> {log}"""


rule plot_AF_coverage_muttypes:
    input:
        "results/{sample}/variants/variants_cov_filter_PASS.vcf",
    output:
        mut_type_counts=report(
            "results/{sample}/plots/mut_type_counts.png",
            caption="../report/mut_type_counts.rst",
            category="Plots",
            subcategory="Variant calls: {sample}",
            labels={"Figure": "Mutation type counts"},
        ),
        allele_frequency=report(
            "results/{sample}/plots/allele_frequency.png",
            caption="../report/allele_frequency.rst",
            category="Plots",
            subcategory="Variant calls: {sample}",
            labels={"Figure": "Allele frequency"},
        ),
        coverage=report(
            "results/{sample}/plots/coverage.png",
            caption="../report/coverage.rst",
            category="Plots",
            subcategory="Variant calls: {sample}",
            labels={"Figure": "Coverage"},
        ),
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 50,
        runtime=lambda wildcards, attempt: attempt * 60,
    log:
        "logs/{sample}/plot_AF_coverage_muttypes.out",
    conda:
        "../envs/R4_3_3.yaml"
    script:
        "../scripts/plot_cov_and_AF.R"
