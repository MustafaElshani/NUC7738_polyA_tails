# NUC-7738 poly(A) tails

Code for the paper "NUC-7738, a prodrug of cordycepin triphosphate, reveals context-dependent poly(A) tail responses
in cancer cells, immune cells and patient tumors".

This repository holds the processing of the long reads: alignment, IsoForge, oarfish and IsoEnds. The analysis code
and the notebooks that reproduce the figures and tables of the paper will be added on publication.

## Data

| Data | Where |
|---|---|
| Reads of the 22 cancer cell lines, DMSO and NUC-7738, full-length cDNA reads (FASTQ) | ENA study [PRJEB128047](https://www.ebi.ac.uk/ena/browser/view/PRJEB128047) |
| PBMC donors and NuTide:701 biopsies | from the lead contact on request |

## Software

| Tool | Version | Used for |
|---|---|---|
| [minimap2](https://github.com/lh3/minimap2), [samtools](https://github.com/samtools/samtools) | 2.31, 1.21 | genome alignment |
| [IsoForge](https://github.com/MustafaElshani/IsoForge) | 1.0.0 | transcript models, read assignment, poly(A) tail per read |
| [IsoForge_Sqanti3](https://github.com/MustafaElshani/IsoForge_Sqanti3) with [SQANTI3](https://github.com/ConesaLab/SQANTI3) | 6.0.2 | classification and coding regions of the models |
| [oarfish](https://github.com/COMBINE-lab/oarfish) | 0.9.3 | transcript quantification |
| [IsoEnds](https://github.com/MustafaElshani/IsoEnds) | 1.0.0 | poly(A) tails and polyadenylation sites from IsoForge output, tested within and across the cell lines |
| [IsoTracks](https://github.com/MustafaElshani/IsoTracks) | 1.0.0 | read-level views of a locus |

## Environment

```bash
conda env create -f environment.yml
conda activate nuc7738
```

IsoForge and IsoForge_Sqanti3 are installed from their repositories.

## Run

Each sequencing run has one folder, `data/runs/<run>`, named in `config/cell_lines.csv`. The samples are listed in
`config/samples.tsv`.

**1. Reads.** Download the FASTQ files of a run into `data/runs/<run>/fastq/` and align each sample:

```bash
scripts/run_alignment.sh data/runs/SKMEL28 SKMEL28_Ctrl_Bio1_LR
```

**2. IsoForge.** One default run per run folder, then SQANTI3 on its transcript models:

```bash
scripts/run_isoforge.sh data/runs/SKMEL28 SKMEL28
scripts/run_sqanti3.sh data/runs/SKMEL28
```

**3. oarfish.** Each sample:

```bash
scripts/run_oarfish.sh data/runs/SKMEL28 SKMEL28_Ctrl_Bio1_LR
```

**4. IsoEnds.** Poly(A) tails and polyadenylation sites of the 22 cell lines, tested within each cell line and across
them, with the default parameters. It writes `results/isoends`:

```bash
isoends all -c config/isoends.yaml -j 4
```

## Layout

```
config/    cell lines, samples, the IsoEnds run
scripts/   the tool runs
```

`data/` holds the inputs and is not part of the repository:

```
data/runs/<run>/fastq/                        reads
data/runs/<run>/analysis/alignments/          genome alignments
data/runs/<run>/analysis/isoforge/results/    IsoForge output
data/runs/<run>/analysis/isoforge/SQANTI3/    SQANTI3 output
data/runs/<run>/analysis/counts/oarfish/      oarfish output
data/reference/                               GENCODE v49 annotation and transcripts, GRCh38 primary assembly,
                                              minisplice scores (human-GRCh38.v4.tsv.gz), polyA_motifs.txt
```
