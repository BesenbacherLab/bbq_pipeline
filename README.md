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

to install Snakemake in an isolated environment. If you need to use conda, `--conda-frontend conda` flag needs to be added to the snakemake commands given below. 

Activate the environment via: 

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
To specify the parameters for running BBQ, reference genome and sample paths, modify the configuration files [`config.yaml`](https://github.com/carmenoroperv/bbq_pipeline/blob/master/config/config.yaml) and [`samples.tsv`](https://github.com/carmenoroperv/bbq_pipeline/blob/master/config/samples.tsv) according to your needs, following the explanations provided [here](https://github.com/carmenoroperv/bbq_pipeline/tree/master/config).

#### BBQ installation
The source code and instructions for installing BBQ can be found [here](https://github.com/besenbacher/BetterBaseQuals/tree/main).
If you have not installed BBQ before running the workflow, BBQ will be installed to the working directory during the execution. 

If you have already installed BBQ, you can provide a full path to the executable in the config file [`config.yaml`](https://github.com/carmenoroperv/bbq_pipeline/blob/master/config/config.yaml) by specifiying the `bbq_path` key under the `bbq/global` property. 

### Step 4: Run workflow 

#### Cluster exection

For cluster execution of the workflow, the [snakemake slurm executor plugin](https://snakemake.github.io/snakemake-plugin-catalog/plugins/executor/slurm.html) needs to be installed with `pip install snakemake-executor-plugin-slurm`. If the slurm plugin is not installed, the `-e` flag needs to be specified for the snakemake commands listed below. 

The specifics for cluster execution should be defined in the workflow profile configuration file. An example workflow profile for slurm is provided [here](https://github.com/carmenoroperv/bbq_pipeline/tree/master/workflow/profiles/default/config.yaml). To use the example profile, adjust the snakemake command line parameters to your needs. Importantly, a cluster account is specified in the example profile as an environment variable. To set the account name as an environment variable run `export ACCOUNT_NAME=<your_account_name>` or modify the profile config file to include your account name directly.


After you have activated the conda environment with snakemake, installed the slurm executor plugin and set the account name as an environment variable, you can test the workflow remote execution by performing a dry-run:

```
snakemake -n
```

To run the workflow for a new data set, use the `--directory` flag that specifies the path to the directory where the pipeline will be executed. The target directory needs to include a config folder with `config.yaml` and `samples.tsv` files, which specify the BBQ parameters, reference genome and paths to sample files that will be used during execution. You can execute the workflow with: 

```
snakemake --directory "path/to/new/directory/"
```

For example, to run the workflow with the provided test data in the .test folder run: 

```
snakemake --directory ".test"
```

The workflow profile that specifies the details for the cluster execution will be still automatically detected from the pipeline directory ([`workflow/profiles/default/config.yaml`](https://github.com/carmenoroperv/bbq_pipeline/blob/master/workflow/profiles/default/config.yaml)) even when the execution directory is changed. If you want to specify a new cluster execution profile as well, use the `--workflow-profile` flag: 

```
snakemake --workflow-profile "path/to/workflow_profile/config.yaml"
```

For further options for local, cluster and cloud execution, see the [docs](https://snakemake.readthedocs.io/).


### Step 5: Generate report (optional)

After running the workflow, you can automatically generate an HTML report with an overview of the results via: 

```
snakemake --report report.html
```
