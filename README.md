# SARS-CoV-2 Variant Analysis Pipeline

## Dataset

* Accession: `SRR17855325`
* Reference genome: SARS-CoV-2 `NC_045512.2` (Wuhan-Hu-1)

## Pipeline

Raw FASTQ → Quality Control → Read Alignment → SAM/BAM → Variant Calling → VCF/TSV → PhysIQ Machine Learning

The bioinformatics pipeline generates the variant files, while PhysIQ Dynamic is used as a downstream exploratory machine-learning analysis step.

## Tools

* BWA
* SAMtools
* BCFtools
* PhysIQ Dynamic

## Bioinformatics Analysis

Reads were aligned to the SARS-CoV-2 `NC_045512.2` reference genome.

Variant calling produced:

* 73 total variant records
* 57 SNPs
* 16 indels
* 2 multiallelic sites

Mapping and variant-calling results are available in:

* `results/mapping_stats.txt`
* `results/variant_stats.txt`
* `results/variants.tsv`
* `results/sars_cov2_variants.vcf`

## Machine Learning Analysis

The VCF-derived variant table was transferred to PhysIQ Dynamic for exploratory machine-learning analysis.

### Input Data

* Total observations: 73
* Input features: `POS`, `QUAL`
* Target variable: `DP`
* Analysis type: Regression
* Train/test split: 80/20
* Training observations: 58
* Test observations: 15

The target `DP` represents the read depth associated with each variant record. The PhysIQ analysis therefore evaluates regression performance for predicting DP from the selected variant-level features.

### Models

Five regression models were evaluated:

1. Linear Regression
2. Ridge Regression
3. Elastic Net
4. Random Forest
5. Gradient Boosting

### Test-Set Results

| Model             |      R² |  RMSE |   MAE |
| ----------------- | ------: | ----: | ----: |
| Linear Regression | -0.7103 | 83.87 | 78.32 |
| Ridge Regression  | -0.7005 | 83.63 | 78.18 |
| Elastic Net       | -0.5129 | 78.88 | 75.26 |
| Random Forest     | -0.3743 | 75.18 | 64.97 |
| Gradient Boosting | -1.3074 | 97.41 | 76.92 |

All reported test-set R² values were negative, indicating that the models did not outperform a simple test-set mean baseline under this particular split and feature/target configuration.

These results are presented as an exploratory machine-learning demonstration of the pipeline rather than as a validated biological or clinical prediction model.

## PhysIQ Results

PhysIQ outputs are stored under:

`results/physiq/`

The directory contains:

* Prediction CSV files
* Prediction Excel file
* Model comparison visualizations
* Advanced analysis visualizations
* PhysIQ experiment JSON files

## Repository Structure

```text
.
├── README.md
├── .gitignore
├── pipeline.sh
└── results/
    ├── mapping_stats.txt
    ├── variant_stats.txt
    ├── variants.tsv
    ├── sars_cov2_variants.vcf
    └── physiq/
        ├── predictions-test.csv
        ├── predictions-test (1).csv
        ├── predictions-test.xlsx
        ├── advanced-chart.png
        ├── advanced-chart (1).png
        ├── advanced-chart.svg
        ├── model-chart.png
        ├── model-chart (1).png
        ├── model-chart.svg
        ├── ml-studio-experiment.json
        └── ml-studio-experiment (1).json
```
