# Two-Echelon Microhub Location-Allocation Problem (TMLPA) Benchmark Engine

This repository contains a fully reproducible academic evaluation suite designed to optimize the location and pedestrian allocation of temporary microhubs for last-mile logistics. The project benches an advanced **Binary Walrus Optimizer (BWO)** against a traditional **Binary Particle Swarm Optimization (BPSO)** baseline. Both metaheuristic solvers are evaluated against certified exact mathematical global bounds solved via the **HiGHS MILP Solver Engine** in MiniZinc.

---

## Repository Directory Structure

```text
.
├── README.md                                 # Operational manual and replication guide
├── TMLPA_Optimization.ipynb                  # Primary Jupyter Notebook containing solvers & engine
├── results_summary.txt                       # Central consolidated data registry (Descriptive & Inferences)
├── execution_results/                        # Raw runtime logs and publication-quality figures
│   ├── instance_small.txt                    # Metaheuristic run summaries (3x5 scale)
│   ├── instance_medium.txt                   # Metaheuristic run summaries (10x25 scale)
│   ├── instance_large.txt                    # Metaheuristic run summaries (20x50 scale)
│   ├── minizinc_small.txt                    # HiGHS solver verification log (Global Opt: 84.20)
│   ├── minizinc_medium.txt                   # HiGHS solver verification log (Global Opt: 452.00)
│   ├── minizinc_large.txt                    # HiGHS solver verification log (Global Opt: 915.20)
│   ├── convergence_analysis_instance_*.png   # Execution trajectory plots for LaTex format
│   └── cost_metric_dispersion_instance_*.png # Non-parametric distribution boxplots
├── minizinc/                                 # Mathematical modeling artifacts
│   ├── tmlpa_model.mzn                       # Definitive constraint formulation model
│   ├── tmlpa_integer.mzn                     # Bounds-enforced integer processing script
│   ├── instance_small.dzn                    # Scale parameter data: 3 Hubs x 5 Clients
│   ├── instance_medium.dzn                   # Scale parameter data: 10 Hubs x 25 Clients
│   └── instance_large.dzn                    # Scale parameter data: 20 Hubs x 50 Clients
└── report/                                   # Academic publishing manuscripts
    ├── main.tex                              # Primary LaTeX source code document
    ├── refs.bib                              # Structural BibTeX bibliographic entries
    ├── elsarticle.cls                        # Elsevier Journal template formatting layout
    ├── elsarticle-num.bst                    # Numerical citation bibliography style
    ├── report.PDF                            # Compiled evaluation document artifact
    └── img/
        └── fig1.png                          # Conceptual methodology diagram

```

---

## Dependencies & Environment Setup

The benchmark environment requires Python 3.8+ combined with a native MiniZinc installation configured with the HiGHS solver backend.

### 1. Python Dependencies

Install the standard numerical science, data engineering, and visualization libraries:

```bash
pip install numpy pandas scipy matplotlib jupyter

```

### 2. MiniZinc CLI Core Engine

Ensure the `minizinc` executable is exposed to your system path.

* **Ubuntu/Debian:** `sudo apt-get install minizinc`
* **macOS (Homebrew):** `brew install minizinc`
* **Windows:** Install via official installer and add binary to system environment path variables.

Verify the command-line bindings via your shell:

```bash
minizinc --version

```

---

## Execution & Replication Guide

### Running the Metaheuristic Experiment

Open the main Jupyter notebook environment and execute all cells sequentially:

```bash
jupyter notebook TMLPA_Optimization.ipynb

```

The primary loop inside `execute_benchmark_experiment("instance_name.dzn")` will automatically:

1. Stream problem specifications directly from the `.dzn` allocation file.
2. Launch independent stochastic sweeps using isolated, offset random seed profiles.
3. Compute an Interquartile Range (IQR) pass at iteration boundaries to isolate, drop, and transparently swap statistical outliers to preserve sample size integrity ($N=30$).
4. Compute non-parametric Mann-Whitney-Wilcoxon statistical inferences.
5. Save publication-proportioned EPS/PNG plot matrices directly into `execution_results/`.

### Verifying Exact Mathematical Ground Truths

To independently compile the exact global baseline bounds using the branch-and-cut optimization routines of the HiGHS engine, run the following commands via your CLI terminal:

```bash
# Small Instance
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_small.dzn -p 4

# Medium Instance
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_medium.dzn -p 4

# Large Instance
minizinc --solver HiGHS minizinc/tmlpa_integer.mzn minizinc/instance_large.dzn -p 4

```

---

## Core Performance Summary

The verified empirical outcome from the multi-scale sweeps maps out as follows:

1. **`instance_small.dzn`**: Both metaheuristics successfully evaluate down to the absolute mathematical global optimum profile (**`84.2000`**) with $100\%$ tracking success (`SRate = 1.0000`).
2. **`instance_medium.dzn`**: Exact solution bounded by HiGHS at **`452.0000`**. BPSO locks instantly onto a multi-modal local minimum sink at `461.0000` ($1.99\%$ gap), while the Walrus Optimizer exhibits exploratory distributions down to a best profile of `464.8000` ($2.83\%$ gap).
3. **`instance_large.dzn`**: Exact global constraint bound resolved at **`915.2000`**. BPSO bounds close with an expert layout cost of `920.3000` ($0.56\%$ gap), while the Walrus Optimizer maintains solution space variance converging at `933.1000` ($1.96\%$ gap).

*Full distributional statistics, LaTeX code matrices, and calculated hub structural layout vectors ($y$) are logged automatically inside `results_summary.txt`.*

```

***

### Summary of Source-to-Tree Data Audit
To ensure absolute integrity, here is the confirmation trace proving where the information in this `README.md` originated from your structural file landscape:
1. **File Path Matrix:** Derived completely from your raw `$ tree` command, ensuring that files like `tmlpa_integer.mzn` and paths like `execution_results/` align perfectly without an single artifact out of place.
2. **Exact Global Costs (`84.2000`, `452.0000`, `915.2000`):** Pulled from `minizinc_small.txt`, `minizinc_medium.txt`, and `minizinc_large.txt`.
3. **Metaheuristic Performance Metrics:** Extracted from the validated summaries recorded inside your `instance_small.txt`, `instance_medium.txt`, and `instance_large.txt` execution logs.
