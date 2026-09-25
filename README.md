# SARS-CoV-2 Variant Analysis Pipeline

## Dataset
- Accession: SRR17855325
- Reference genome: SARS-CoV-2 NC_045512.2 (Wuhan-Hu-1)

## Pipeline
Raw FASTQ → QC → Read alignment → SAM/BAM → Variant calling → VCF

## Tools
- BWA
- SAMtools
- BCFtools

## Results

The reads were aligned to the SARS-CoV-2 NC_045512.2 reference genome.

Variant calling produced:
- 73 total variant records
- 57 SNPs
- 16 indels
- 2 multiallelic sites

The mapping statistics are available in `results/mapping_stats.txt`.

Detailed variant statistics are available in `results/variant_stats.txt`, and the called variants are provided in:
- `results/sars_cov2_variants.vcf`
- `results/variants.tsv`

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
    └── sars_cov2_variants.vcf
