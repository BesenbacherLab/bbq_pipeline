# Snakemake workflow: Better Base Quality (BBQ)

[![Snakemake](https://img.shields.io/badge/snakemake-≥6.3.0-brightgreen.svg)](https://snakemake.github.io)
[![GitHub actions status](https://github.com/carmenoroperv/bbq_pipeline/workflows/Tests/badge.svg?branch=master)](https://github.com/carmenoroperv/bbq_pipeline/actions?query=branch%master+workflow%3ATests)


## Description

Snakemake workflow for running the Better Base Quality (BBQ) tool for somatic variant calling. 


## Usage

The usage of this workflow is also described in the [Snakemake Workflow Catalog](https://snakemake.github.io/snakemake-workflow-catalog/?usage=carmenoroperv/bbq_pipeline). (Will be published once the repo is public)

### Step 1: Install snakemake

Snakemake is best to be installed via the [Mamba package manager](https://github.com/mamba-org/mamba) (a drop-in replacement for conda). If you have neither Conda nor Mamba, it can be installed via [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge). For other options see [here](https://github.com/mamba-org/mamba).

Given that Mamba is installed, run:

```
mamba create -c conda-forge -c bioconda --name snakemake 'snakemake>=8'
```

to install Snakemake in an isolated environment. Activate the environment via: 

```
conda activate snakemake
```

### Step 2: Clone this repo

Download and extract the repository: 

```
git clone https://github.com/carmenoroperv/bbq_pipeline.git && cd bbq_pipeline
```

### Step 3: Configure workflow and install BBQ

#### Workflow confifuration
To configure this workflow, modify config/config.yaml and samples.tsv according to your needs, following the explanations provided [here](https://github.com/carmenoroperv/bbq_pipeline/tree/master/config).

#### BBQ installation
The source code and instructions for installing BBQ can be found [here](https://github.com/besenbacher/BetterBaseQuals/tree/main).
If you have not installed BBQ before running the workflow, BBQ will be installed to the working directory during the execution. 

If you have already installed BBQ, you can provide a full path to the executable in the `config/config.yaml` by specifiying the `bbq_path` key under the `bbq/global` property. 

### Step 4: Run workflow 

After you have activated the conda environment with snakemake. You can test your configuration by performing a dry-run:

```
snakemake --use-conda -n
```

You can run the workflow locally with: 

```
snakemake --software-deployment-method conda --cores all
```

For cluster execution set up a profile configuration. An example workflow profile configuration for slurm is provided [here](https://github.com/carmenoroperv/bbq_pipeline/tree/master/workflow/profiles/default/config.yaml). To use the example profile, adjust the snakemake command line parameters to your needs and install the [snakemake slurm executor plugin](https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html) with `pip install snakemake-executor-plugin-slurm`. 

A cluster account is specified in the example profile as an environment variable. Set the account name as an environment variable by running `export ACCOUNT_NAME=<your_account_name>` or modify the profile config file to include your account name directly.

After setting up the profile configuration, you can run snakemake with a workflow specific profile with: 

```
snakemake --workflow-profile "path/to/workflow_profile/config.yaml"
```

For further options, for cluster and cloud execution, see the [docs](https://snakemake.readthedocs.io/).

### Step 5: Generate report (optional)

After running the workflow, you can automatically generate an HTML report with an overview of the results via: 

```
snakemake --report report.html
```
