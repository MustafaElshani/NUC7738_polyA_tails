#!/usr/bin/env bash
# Align the full-length reads of one sample to the genome.
#   scripts/run_alignment.sh data/runs/SKMEL28 SKMEL28_Ctrl_Bio1_LR
set -euo pipefail
RUN=$1
SAMPLE=$2
THREADS=${THREADS:-16}
REF=${REF:-data/reference}
GTF=$REF/gencode.v49.primary_assembly.annotation.gtf
GENOME=$REF/GRCh38.primary_assembly.genome.fa
JUNCTIONS=$REF/gencode.v49.junctions.bed

mkdir -p "$RUN/analysis/alignments"
[[ -s $JUNCTIONS ]] || paftools.js gff2bed "$GTF" > "$JUNCTIONS"

minimap2 -ax splice -uf -t "$THREADS" --MD -y --junc-bed "$JUNCTIONS" "$GENOME" "$RUN/fastq/${SAMPLE}_full_length.fastq.gz" \
    | samtools sort -@ "$THREADS" -o "$RUN/analysis/alignments/${SAMPLE}_gnome_sorted.bam"
samtools index -@ "$THREADS" "$RUN/analysis/alignments/${SAMPLE}_gnome_sorted.bam"
