#!/usr/bin/env bash
# oarfish quantification of one sample against the GENCODE v49 transcriptome.
#   scripts/run_oarfish.sh data/runs/SKMEL28 SKMEL28_Ctrl_Bio1_LR
set -euo pipefail
RUN=$1
SAMPLE=$2
THREADS=${THREADS:-16}
REF=${REF:-data/reference}
INDEX=$REF/gencode.v49.oarfish.mmi

if [[ ! -s $INDEX ]]; then
    oarfish --only-index --annotated "$REF/gencode.v49.transcripts.fa" --seq-tech ont-cdna --index-out "$INDEX" \
        -j "$THREADS" -o "$REF/oarfish_index"
fi

mkdir -p "$RUN/analysis/counts/oarfish"
oarfish \
    --reads "$RUN/fastq/${SAMPLE}_full_length.fastq.gz" \
    --index "$INDEX" \
    --seq-tech ont-cdna \
    --model-coverage \
    --filter-group no-filters \
    --best-n 100 \
    --num-bootstraps 100 \
    -j "$THREADS" \
    -o "$RUN/analysis/counts/oarfish/$SAMPLE"
