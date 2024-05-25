if (
    "bbq" not in config
    or "global" not in config["bbq"]
    or "bbq_path" not in config["bbq"]["global"]
):

    rule clone_bbq_repo:
        output:
            bbq_dir=directory("BetterBaseQuals"),
        resources:
            mem_mb=lambda wildcards, attempt: attempt * 1024,
            runtime=lambda wildcards, attempt: attempt * 45,
        log:
            "logs/clone_bbq_repo.log",
        conda:
            "../envs/poetry1_8_3.yaml"
        shell:
            """
            git clone https://github.com/besenbacher/BetterBaseQuals.git 2> {log}
            """

    rule install_bbq_poetry:
        input:
            bbq_dir=rules.clone_bbq_repo.output.bbq_dir,
        output:
            "results/bbq_path.txt",
        resources:
            mem_mb=lambda wildcards, attempt: attempt * 1024 * 10,
            runtime=lambda wildcards, attempt: attempt * 45,
        params:
            output_rel_path="../results/bbq_path.txt",
            log_rel_path="../logs/install_bbq_poetry.log",
        log:
            "logs/install_bbq_poetry.log",
        conda:
            "../envs/poetry1_8_3.yaml"
        shell:
            """
            cd BetterBaseQuals && poetry install && poetry run which bbq > {params.output_rel_path} 2> {params.log_rel_path}
            """
