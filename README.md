# HuMSub subspecies quantification pipeline

Quantify bacterial subspecies from metagenomic reads using sourmash, based on the HuMSub (Human Microbiome Subspecies) catalog.

**Publication**: Trickovic et al. (2025) "Subspecies of the human gut microbiota carry implicit information for in-depth microbiome research". *Cell Host & Microbe*. https://doi.org/10.1016/j.chom.2025.07.015

This is an improved, standalone version of the pipeline from [trajkovski-lab/humsub](https://github.com/trajkovski-lab/humsub/tree/main/Workflows/use_catalog), updated for **sourmash >= 4.9**.

## Pipeline overview

```
raw reads (FASTQ) → sketch (sourmash) → gather (sourmash) → abundance table
```

1. **sketch_reads** — Creates sourmash DNA signatures from paired-end reads (`sourmash sketch dna`)
2. **gather** — Searches each sample signature against the HuMSub SBT database (`sourmash gather`)
3. **combine_results** — Merges per-sample gather CSVs into a combined abundance table

## Requirements

- [Snakemake](https://snakemake.readthedocs.io/) (>= 7.0)
- [Conda](https://docs.conda.io/) / Mamba (for environment management)
- 8+ GB RAM recommended

## Quick start

```bash
# 1. Clone the repo
git clone <this-repo>
cd use_subspecies_catalog

# 2. Download the HuMSub database (~132 MB)
bash scripts/download_db.sh

# 3. Prepare your sample table (tab-separated)
#    samples.tsv:
#  	Reads_QC_R1	Reads_QC_R2
#   sample1	/path/to/sample1_R1.fastq.gz	/path/to/sample1_R2.fastq.gz
#   sample2	/path/to/sample2_R1.fastq.gz	/path/to/sample2_R2.fastq.gz

# 4. Run the pipeline
snakemake -s workflow/Snakefile --use-conda -j8
```

## Test data

Two test datasets are available:

| Dataset | Size | Description |
|---------|------|-------------|
| **Test reads (small)** | 174 MB | 2 paired-end simulated samples at [zenodo.org/records/3992790](https://zenodo.org/records/3992790) |
| **humgut_samples** | 20.6 GB | 10 paired-end simulated samples from HumGut MAGs at [zenodo.org/records/15862096](https://zenodo.org/records/15862096) |
| **new_samples** | 20.7 GB | 10 paired-end simulated samples from non-HumGut MAGs at [zenodo.org/records/15862096](https://zenodo.org/records/15862096) |

To run with the small test set:

```bash
mkdir -p test
curl -L -o test/test_reads.tar.gz \
  "https://zenodo.org/records/3992790/files/test_reads.tar.gz?download=1"
tar -xzf test/test_reads.tar.gz -C test/
snakemake -s workflow/Snakefile --configfile config/test_config.yaml --use-conda -j2
```

## Database

The pipeline uses index 1 from the Zenodo record: **HuMSub_51_1000.sbt.zip** (k=51, scaled=1000, 132 MB).

Download: https://zenodo.org/records/15862096

Two versions are available:
1. **HuMSub_51_1000.sbt.zip** — for general subspecies quantification (k=51, scaled=1000)
2. **HuMSub_21_1000.sbt.zip** — for querying the Mastiff database (k=21, scaled=1000)

## R / Phyloseq import

```r
library(phyloseq)
abund <- read.csv("output/combined_results.csv", row.names = 1)
OTU <- otu_table(as.matrix(abund), taxa_are_rows = TRUE)
ps <- phyloseq(OTU)
```

See `scripts/import_to_phyloseq.R` for a complete example.

## Configuration

Edit `config/default_config.yaml` or pass `--configfile` to Snakemake:

```yaml
db_path: HuMSub_51_1000.sbt.zip
kmer_len: 51
scaled: 1000
threshold_bp: 15000
threads: 8
trim_reads: False
```

## Citation

If you use this pipeline, please cite:

> Trickovic, M., Kieser, S. D., Zdobnov, E., & Trajkovski, M. (2025). Subspecies of the human gut microbiota carry implicit information for in-depth microbiome research. *Cell Host & Microbe*. https://doi.org/10.1016/j.chom.2025.07.015

Also cite sourmash:

> Irber et al. (2024). sourmash v4: a multi-step approach to software sustainability. *Journal of Open Source Software*, 9(101), 6830. https://doi.org/10.21105/joss.06830
