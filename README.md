# Multi-Scale Metaheuristic and Exact Optimization Framework for the TMLPA Problem

This repository hosts an advanced optimization suite designed to solve the **Two-Level Temporary Microhub Location and Pedestrian Assignment (TMLPA)** problem. The framework implements and benchmarks two prominent swarm intelligence metaheuristics—**Binary Particle Swarm Optimization (BPSO)** and a custom-engineered **Binary Walrus Optimizer (BWO)**—against an exact mathematical reference model compiled via **MiniZinc**.

---

## 📋 Architectural Overview

The TMLPA is an NP-hard combinatorial optimization challenge tailored for green last-mile urban logistics. It simultaneously governs two tightly coupled discrete decision profiles:
1. **Facility Location Layer ($y_j \in \{0,1\}$):** Selecting which temporary city-center microhubs to open given tight structural infrastructure boundaries ($[P_{min}, P]$) and fixed opening costs.
2. **Pedestrian Assignment Layer ($x_{ij} \in \{0,1\}$):** Mapping discrete demand clients to open facilities without violating hard courier maximum walking thresholds ($d_{max}$) or volumetric facility capacities ($L_j$).

### 🚀 Key Technical Enhancements (Custom Developments)

To extend the baseline paradigm provided by the curriculum and achieve an *Excelente* ranking under formal validation guidelines, the following core frameworks were developed from scratch below the professor's baseline sections:

* **Intelligent Greedy Routing Repair Module:** Canonical swarm adjustments randomly flip assignment vectors, causing severe constraint decay. This component implements a deterministic mapping mechanism that sorts hubs by ascending walking distances and maps demand footprints sequentially against real-time residual capacities, guaranteeing solution feasibility without altering structural population diversity.
* **Continuous-to-Binary Sigmoidal Walrus Migration:** Transforms continuous velocity walks derived from the newly formulated Walrus Optimizer into stable discrete exploration schedules using custom sigmoidal probabilities ($S(v) = \frac{1}{1 + \exp(-v)}$).
* **Automated Multi-Scale Benchmark Suite:** Replaces hardcoded operational instances with object-oriented scaling loops capable of reading, executing, and monitoring Small (Instance 0), Medium, and Large-scale operational matrices seamlessly.

---

## 📂 Repository Structure

```text
├── TMLPA_PSO_JQ(1)(2).ipynb      # Core workspace containing problem definitions & Swarms
├── minizinc/                     # Exact validation layer directory
│   ├── tmlpa_model.mzn           # Formal MiniZinc constraint optimization model
│   ├── instance_small.dzn        # Data file mapping exactly to python Instance 0
│   ├── instance_medium.dzn       # Escalated problem matrix (10 Hubs, 25 Clients)
│   └── instance_large.dzn        # Stress-test problem matrix (20 Hubs, 50 Clients)
├── main.tex                      # Production-grade Elsevier LaTeX manuscript draft
└── README.md                     # Technical project documentation (This file)