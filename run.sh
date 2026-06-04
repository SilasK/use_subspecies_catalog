#!/bin/bash
# Run the subspecies quantification pipeline
snakemake -s workflow/Snakefile --use-conda -j8 --scheduler greedy $@