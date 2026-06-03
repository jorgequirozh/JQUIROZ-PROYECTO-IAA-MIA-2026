# Multi-Scale Metaheuristic and Exact Optimization Framework for the TMLPA Problem
This repository contains the source code, constraint programming formulations, data models, and empirical benchmarking suites developed for the Two-Echelon Microhub Location-Allocation Problem (TMLPA) within an urban logistics context (Valparaíso Pilot). The project evaluates a proposed Binary Walrus Optimizer (BWO) against a classical Binary Particle Swarm Optimization (BPSO) baseline, validated against exact mathematical programming ground truths compiled via MiniZinc.

---

## Architectural Overview

The TMLPA is an NP-hard combinatorial optimization challenge tailored for green last-mile urban logistics. It simultaneously governs two tightly coupled discrete decision profiles:
1. **Facility Location Layer (y_j in {0,1}):** Selecting which temporary city-center microhubs to open given tight structural infrastructure boundaries ([P_min, P]) and fixed opening costs.
2. **Pedestrian Assignment Layer (x_ij in {0,1}):** Mapping discrete demand clients to open facilities without violating hard courier maximum walking thresholds (d_max) or volumetric facility capacities (L_j).

### Key Technical Enhancements (Custom Developments)

To extend the baseline paradigm provided by the curriculum and achieve an *Excelente* ranking under formal validation guidelines, the following core frameworks were developed from scratch below the professor's baseline sections:

* **Intelligent Greedy Routing Repair Module:** Canonical swarm adjustments randomly flip assignment vectors, causing severe constraint decay. This component implements a deterministic mapping mechanism that sorts hubs by ascending walking distances and maps demand footprints sequentially against real-time residual capacities, guaranteeing solution feasibility without altering structural population diversity.
* **Continuous-to-Binary Sigmoidal Walrus Migration:** Transforms continuous velocity walks derived from the newly formulated Walrus Optimizer into stable discrete exploration schedules using custom sigmoidal probabilities (S(v) = 1 / (1 + exp(-v))).
* **Automated Multi-Scale Benchmark Suite:** Replaces hardcoded operational instances with object-oriented scaling loops capable of reading, executing, and monitoring Small (Instance 0), Medium, and Large-scale operational matrices seamlessly.

---

## Repository Structure

The layout of the project workspace is structured as follows:
```
.
├── README.md                     # Project documentation and execution instructions
├── TMLPA_Optimization.ipynb      # Main Jupyter Notebook containing swarms and analysis
├── minizinc/                     # Constraint Programming environment
│   ├── tmlpa_model.mzn           # Core MiniZinc optimization model
│   ├── instance_small.dzn        # Small-scale test instance dataset (3 Hubs / 5 Clients)
│   ├── instance_medium.dzn       # Medium-scale challenge instance (10 Hubs / 25 Clients)
│   └── instance_large.dzn        # Large-scale stress-test instance (20 Hubs / 50 Clients)
└── report/                       # Academic manuscript files (Elsevier Format)
    ├── main.tex                  # LaTeX main source document
    ├── refs.bib                  # BibTeX bibliography references
    ├── elsarticle.cls            # Elsevier document class style
    ├── elsarticle-num.bst        # Numerical reference style
    ├── report.PDF                # Compiled academic paper
    └── img/                      # Graphical assets for documentation
        └── fig1.png              # Network layout diagram

```
## Problem Definition Overview

The TMLPA model addresses a multi-capacity, distance-constrained network optimization challenge designed to minimize total infrastructure operational expenditure ($f_o$). The objective function balances two primary cost mechanisms:

1. **Fixed Installation Costs**: Capital expenditures incurred by activating specific structural microhubs.
2. **Variable Processing Costs**: Volumetric transport and operation penalties calculated from customer demand metrics weighted by real Euclidean walking distances.

Operational feasibility is explicitly governed by strict distance ceilings ($d_{max}$), individual hub volumetric handling boundaries ($L$), and structural constraints limiting the total number of simultaneous open hubs ($P_{min}$ and $P$).

## Algorithmic Strategy

The metaheuristic optimization engine employs a decoupled architecture to maintain structural backward compatibility while handling scalability constraints:

* **Base Classes (Immutable)**: Contains the original `TMLPAProblem` data framework and the baseline `Particle` and `PSOSolver` blueprints provided in the curriculum core.
* **Intelligent Greedy Routing Module**: A deterministic repair layer that replaces blind stochastic routing choices. It automatically assigns demand nodes to the nearest open hub while monitoring remaining capacity boundaries. If no feasible layout exists for a given binary hub configuration, it is heavily penalized.
* **Proposed Walrus Optimizer**: A custom implementation adapted for discrete search spaces, integrating herd-gathering and migration behaviors to navigate non-linear decision spaces.
* **Polymorphic Extensions (`GreedyParticle` / `GreedyPSOSolver`)**: Object-oriented subclasses that inject the greedy repair protocol into the continuous-to-binary velocity equations without altering the underlying mathematical equations of the baseline algorithm.

## Execution and Benchmarking Guide

### Prerequisites

The environment must contain a standard Python 3.8+ deployment along with the following numerical and data-science packages:

* `numpy`
* `pandas`
* `matplotlib`

To run exact mathematical validations, a working installation of the MiniZinc IDE or CLI bundled with an active Mixed-Integer Programming or Constraint Programming solver (such as COPT, Gurobi, or Chuffed) is required.

### Executing Metaheuristic Sweeps

1. Open `TMLPA_Optimization.ipynb` in a Jupyter notebook environment.
2. Execute all cell blocks sequentially to register the underlying classes, configurations, and analytical metrics.
3. The notebook isolates scale execution into dedicated standalone blocks at the bottom of the workspace:
* **Valparaíso Pilot Unit Test**: Evaluates a single trace to plot the direct convergence profile against a geographic network topology map.
* **Batch Runner Cells**: Triggers 30 independent stochastic loops with unique random seed isolation for `"instance_small.dzn"`, `"instance_medium.dzn"`, and `"instance_large.dzn"`.



### Interpreting Outputs

The evaluation routine implements Interquartile Range (IQR) filtering to isolate statistical anomalies and computes metrics for performance evaluation:

* **Success Rate ($SRate$)**: Percentage of runs that converge within an $\epsilon = 0.01$ threshold of the MiniZinc global minimum.
* **Success Speed ($SSpeed$)**: Normalized convergence rate evaluating the speed at which the swarm hits the target floor.

The script outputs structured tabular summaries alongside their corresponding formatted LaTeX codes ready for direct insertion into `main.tex`, followed by a boxplot displaying objective function cost dispersion.

