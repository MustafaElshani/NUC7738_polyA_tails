#!/usr/bin/env bash
# SQANTI3 classification of the IsoForge transcript models of one run folder (IsoForge_Sqanti3).
#   scripts/run_sqanti3.sh data/runs/SKMEL28
set -euo pipefail
RUN=$1
THREADS=${THREADS:-16}
REF=${REF:-data/reference}

mkdir -p "$RUN/analysis/isoforge/SQANTI3"
for gtf in "$RUN"/analysis/isoforge/results/*_isoforge.gtf; do
    sample=$(basename "$gtf" _isoforge.gtf)
    isoforge-characterize \
        --gtf "$gtf" \
        --ref_gtf "$REF/gencode.v49.primary_assembly.annotation.gtf" \
        --ref_fasta "$REF/GRCh38.primary_assembly.genome.fa" \
        --polya_motifs "$REF/polyA_motifs.txt" \
        --threads "$THREADS" \
        --o "$RUN/analysis/isoforge/SQANTI3/$sample"
done
