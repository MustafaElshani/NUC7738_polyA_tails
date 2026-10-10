#!/usr/bin/env bash
# IsoForge on the aligned samples of one run folder: the default run, with splice-site scores and small RNAs.
#   scripts/run_isoforge.sh data/runs/SKMEL28 SKMEL28
set -euo pipefail
RUN=$1
PREFIX=$2
THREADS=${THREADS:-32}
REF=${REF:-data/reference}
GTF=$REF/gencode.v49.primary_assembly.annotation.gtf
GENOME=$REF/GRCh38.primary_assembly.genome.fa
SPLICE_SCORES=$REF/human-GRCh38.v4.tsv.gz

CONFIG=$RUN/config_sample.csv
: > "$CONFIG"
for bam in "$RUN"/analysis/alignments/*_gnome_sorted.bam; do
    name=$(basename "$bam" _gnome_sorted.bam)
    echo "$name,$name,ONT,$bam" >> "$CONFIG"
done

isoforge index --gtf "$GTF" --genome hg38 --annot gencode_v49 --o "$REF/isoforge_index"

mkdir -p "$RUN/analysis/isoforge/results"
isoforge annotate \
    --db "$REF/isoforge_index" \
    --genome hg38 \
    --config "$CONFIG" \
    --genome_fasta "$GENOME" \
    --threads "$THREADS" \
    --all \
    --unfiltered \
    --keep-db \
    --read_annot_format both \
    --end_tracks \
    --splice_scores "$SPLICE_SCORES" \
    --small_rna \
    --o "$RUN/analysis/isoforge/results/$PREFIX"
