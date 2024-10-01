rule train_kmerpapa:
    input:
        kmers="results/{sample}/kmers/kmers.txt",
    output:
        kmerpapa="results/{sample}/kmerpapa/kmerpapa_model.txt",
        no_ratio="results/{sample}/kmerpapa/no_ratios.txt",
    params:
        extra=get_kmerpapa_params(),
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024 * 4,
        runtime=lambda wildcards, attempt: attempt * 60 * 6,
    log:
        "logs/{sample}/train_kmerpapa.out",
    conda:
        "../envs/bbq0_2_0.yaml"
    shell:
        "bbq train_only --input_file_kmers {input.kmers} --output_file_kmerpapa {output.kmerpapa} --output_file_EQ {output.no_ratio} {params.extra} 2> {log}"


rule plot_error_rates_and_NO_ratio:
    input:
        "results/{sample}/kmerpapa/no_ratios.txt",
    output:
        error_rates=report(
            "results/{sample}/plots/single_read_error_rates.png",
            caption="../report/single_read_error_rates.rst",
            category="Plots",
            subcategory="Error rates: {sample}",
            labels={"Figure": "Error rates"},
        ),
        NO_ratio=report(
            "results/{sample}/plots/NO_ratios.png",
            caption="../report/NO_ratios.rst",
            category="Plots",
            subcategory="Error rates: {sample}",
            labels={"Figure": "NO-ratios"},
        ),
    resources:
        mem_mb=lambda wildcards, attempt: attempt * 1024,
        runtime=lambda wildcards, attempt: attempt * 60,
    log:
        "logs/{sample}/plot_error_rates_and_NO_ratio.out",
    conda:
        "../envs/R4_3_3.yaml"
    script:
        "../scripts/error_rates_and_NO_ratio_plot.R"
