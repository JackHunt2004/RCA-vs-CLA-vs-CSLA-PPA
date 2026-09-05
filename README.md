# Power-Aware Adder Architecture Study

A standalone ASIC study of **Ripple-Carry Adder (RCA)**, **Carry-Lookahead Adder (CLA)**, and **Carry-Select Adder (CSLA)** architectures, with a primary focus on **power-aware PPA characterization and optimization** using the Sky130 standard-cell library.

---

## 1. Project Goal

The primary goal of this project is to investigate how different adder architectures affect:

- Dynamic power
- Leakage power
- Total power
- Timing
- Area

The study will use a common RTL interface, identical verification methodology, common synthesis constraints, and controlled switching activity to enable a fair architectural comparison.

The initial target is a **32-bit adder**.

---

## 2. Architectures

### 2.1 Ripple-Carry Adder (RCA)

A conventional ripple-carry architecture in which the carry propagates sequentially from the least-significant bit to the most-significant bit.

**Expected characteristics:**
- Low hardware complexity
- Low area
- Long carry-propagation path
- Baseline for power/timing comparison

### 2.2 Conventional Carry-Lookahead Adder (CLA)

A carry-lookahead architecture using generate/propagate logic to calculate carries in parallel.

**Expected characteristics:**
- Reduced carry-propagation delay
- Increased logic compared with RCA
- Potentially higher switching activity and area

The implementation will use a structured/hierarchical organization rather than an unnecessarily large flat lookahead network.

### 2.3 Carry-Select Adder (CSLA)

A block-based carry-select architecture in which possible carry-in cases are calculated in parallel and the correct result is selected once the incoming carry is known.

Initial organization:

**32-bit CSLA using 8-bit blocks**

**Expected characteristics:**
- Reduced carry dependency
- Parallel speculative computation
- Increased hardware compared with RCA
- Interesting power/timing trade-off

---

## 3. Experimental Flow

The intended measurement flow is:

```text
             Adder RTL
                 │
                 ▼
        Functional Simulation
                 │
                 ▼
              VCD
                 │
                 ▼
          Yosys Synthesis
                 │
                 ▼
        Sky130 Gate Netlist
                 │
          ┌──────┴──────┐
          ▼             ▼
        OpenSTA       Power
          │             │
       Timing      VCD Activity
          │             │
          └──────┬──────┘
                 ▼
              Results
```

---

## 4. Power Analysis

Power will be investigated using simulation-generated switching activity.

Initial workloads:

1. **Low switching activity**
2. **Random switching activity**
3. **High switching activity**

The same workloads will be applied to every architecture.

The objective is to determine how internal architectural differences affect switching behavior and power consumption.

---

## 5. PPA Metrics

For every architecture, the following metrics will be collected where supported by the flow:

- Area
- Standard-cell count
- Critical-path delay
- Worst negative slack
- Dynamic power
- Leakage power
- Total power

Measured values will be added to this README as the project progresses.

---

## 6. Toolchain

### RTL Simulation

**Icarus Verilog**

```text
/usr/bin/iverilog
```

### Synthesis

**Yosys**

```text
/usr/bin/yosys
```

### Timing and Power Analysis

**OpenSTA 3.1.0**

```text
/home/jackhunt2004/projects/OpenSTA/build/sta
```

Confirmed capabilities:

- Static timing analysis
- VCD activity annotation
- Power analysis
- Power activity assignment

### Technology Library

**Sky130 HD standard-cell library**

```text
~/.volare/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

Technology condition:

```text
Process: TT
Temperature: 0.25°C
Voltage: 1.80 V
```

---

## 7. Planned Repository Structure

```text
RCA-vs-CLA-PPA-Study/
│
├── rtl/
│   ├── rca/
│   ├── cla/
│   ├── csla/
│   └── common/
│
├── tb/
│
├── synthesis/
│
├── sta/
│
├── results/
│   ├── power/
│   ├── timing/
│   └── area/
│
├── scripts/
│   ├── config.sh
│   ├── run_rtl_sim.sh
│   ├── run_synthesis.sh
│   ├── run_sta.sh
│   ├── run_power.sh
│   └── run_all.sh
│
├── docs/
│
└── README.md
```

---

## 8. Planned Scripts

The project will use scripts for all repeatable tool commands.

### `scripts/config.sh`

Central location for:

- Tool paths
- Technology-library paths
- Common configuration
- Project-wide variables

### `scripts/run_rtl_sim.sh`

Runs functional RTL simulation and generates VCD switching activity.

### `scripts/run_synthesis.sh`

Runs Yosys synthesis and Sky130 technology mapping.

### `scripts/run_sta.sh`

Runs OpenSTA timing analysis on the synthesized design.

### `scripts/run_power.sh`

Reads VCD switching activity and performs OpenSTA power analysis.

### `scripts/run_all.sh`

Runs the complete validated flow.

The exact commands used by each script will be documented and maintained as the project evolves.

---

## 9. Initial Execution Plan

The project will be developed incrementally:

```text
1. Repository setup
2. Document architecture
3. Establish common configuration
4. Build and verify simulation flow
5. Build and verify synthesis flow
6. Build and verify STA flow
7. Build and verify power flow
8. Implement RCA
9. Implement CLA
10. Implement CSLA
11. Verify all architectures
12. Characterize power
13. Characterize timing and area
14. Compare PPA trade-offs
15. Explore architectural optimizations
```

No optimization will be performed until the measurement flow is validated.

---

## 10. Future Exploration

After the initial 32-bit comparison is validated, the study may be extended to:

- Different operand widths
- Different CLA hierarchy structures
- Different CSLA block sizes
- Power versus switching activity
- Power-performance-area Pareto analysis
- Architecture-specific optimization
- Post-layout timing and power analysis

This section will be updated as the project develops.

---

## 11. Project Status

**Current stage:** Repository initialized — architecture and experimental flow definition.

Measured results and conclusions will be added progressively as experiments are completed.
