#!/bin/bash

# Hata oluşursa betiğin çalışmasını durdur
set -e

echo "=== 1. Adım: Çalışma Dizininin Oluşturulması ==="
mkdir -p data results
cd data

echo "=== 2. Adım: Ham Verinin İndirilmesi (SRR17855325) ==="
fasterq-dump SRR17855325 --split-files

echo "=== 3. Adım: Ham Veriler İçin Kalite Kontrol (FastQC) ==="
fastqc SRR17855325_1.fastq SRR17855325_2.fastq

echo "=== 4. Adım: Kalite Kontrol ve Temizleme (fastp) ==="
fastp -i SRR17855325_1.fastq -I SRR17855325_2.fastq \
      -o temiz_1.fastq -O temiz_2.fastq \
      --html fastp_rapor.html --json fastp_rapor.json

echo "=== 5. Adım: Referans Genomun İndirilmesi ve Hazırlanması ==="
wget -O NC_045512.2.fasta "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_045512.2&rettype=fasta&retmode=text"
mv NC_045512.2.fasta referans.fasta

echo "=== 6. Adım: Referans Genom İndeksleme ==="
bwa index referans.fasta
samtools faidx referans.fasta

echo "=== 7. Adım: Hizalama (BWA MEM) ==="
bwa mem referans.fasta temiz_1.fastq temiz_2.fastq > hizalama.sam

echo "=== 8. Adım: SAM -> BAM Dönüştürme, Sıralama ve İndeksleme ==="
samtools view -bS hizalama.sam | samtools sort -o hizalama_sirali.bam
samtools index hizalama_sirali.bam
samtools flagstat hizalama_sirali.bam > ../results/mapping_stats.txt

echo "=== 9. Adım: Varyant Çağırma (bcftools) ==="
bcftools mpileup -f referans.fasta hizalama_sirali.bam | bcftools call -mv -Ob -o varyantlar.bcf
bcftools view varyantlar.bcf -Ov -o ../results/sars_cov2_variants.vcf
bcftools stats varyantlar.bcf > ../results/variant_stats.txt

echo "=== 10. Adım: TSV Formatında Varyant Tablosu Oluşturma ==="
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%INFO/DP\n' varyantlar.bcf > ../results/variants.tsv

echo "🎉 Tebrikler! SRR17855325 verisine ait tüm pipeline uçtan uca tamamlandı."
echo "🎉 Pipeline tamamlandı! Sonuçlar 'results' klasöründe hazır."
