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

**Current stage:** Baseline power characterization completed for the 32-bit RCA, CLA, and CSLA architectures.

The baseline study now includes:

- Functional RTL verification
- RTL switching-activity generation
- Sky130 gate-level synthesis
- Area characterization
- Static timing analysis
- Gate-level VCD generation
- VCD-annotated OpenSTA power analysis
- Low, random, and high switching workloads
- Recorded baseline power results

The next stage is to analyze the measured power, timing, and area trade-offs before any architectural optimization.

---

## 12. Baseline Power Characterization

Baseline power was measured at the synthesized gate level using OpenSTA with simulation-generated VCD switching activity.

Measurement conditions:

- Technology: Sky130 HD
- Process: TT
- Temperature: 0.25°C
- Voltage: 1.80 V
- Adder width: 32 bits
- Power analysis: OpenSTA
- Activity source: gate-level VCD
- Measurement window: 100,000 ps to 1,110,000 ps
- Workloads: low, random, high switching activity

### 12.1 Measured Power

| Architecture | Workload | Internal Power (W) | Switching Power (W) | Leakage Power (W) | Total Power (W) |
|---|---|---:|---:|---:|---:|
| RCA | Low | 1.157e-07 | 3.246e-08 | 4.611e-10 | 1.486e-07 |
| RCA | Random | 6.932e-05 | 1.560e-05 | 5.537e-10 | 8.492e-05 |
| RCA | High | 1.356e-04 | 3.085e-05 | 5.542e-10 | 1.664e-04 |
| CLA | Low | 7.890e-08 | 3.764e-08 | 2.006e-10 | 1.167e-07 |
| CLA | Random | 5.944e-05 | 3.287e-05 | 2.430e-10 | 9.231e-05 |
| CLA | High | 7.790e-05 | 3.770e-05 | 2.416e-10 | 1.156e-04 |
| CSLA | Low | 9.405e-08 | 8.447e-08 | 1.002e-09 | 1.795e-07 |
| CSLA | Random | 1.319e-04 | 9.794e-05 | 8.051e-10 | 2.299e-04 |
| CSLA | High | 6.430e-05 | 3.139e-05 | 8.900e-10 | 9.569e-05 |

### 12.2 Initial Characterization

The measured results show workload-dependent power behavior rather than a single architecture being optimal under all conditions.

- Under low switching activity, CLA has the lowest total power.
- Under random switching activity, RCA has the lowest total power.
- Under high switching activity, CSLA has the lowest total power.
- Leakage power is negligible compared with dynamic power for all measured cases.
- CSLA shows the highest total power under the random workload.
- The measured power values are based on the common workload window and identical measurement methodology across architectures.

These observations are baseline characterization results. No architectural optimization has been performed.

The detailed machine-readable results are stored in:

```text
results/power/power_baseline.csv
```
---

## 13. Baseline PPA Comparison

The baseline area, timing, and power measurements were consolidated to compare the three 32-bit adder architectures under the same technology, synthesis, timing, and power-analysis conditions.

### 13.1 Area and Timing

| Architecture | Cell Count | Area | Maximum Delay (ns) | WNS (ns) |
|---|---:|---:|---:|---:|
| RCA | 64 | 1081.0368 | 12.197 | -2.197 |
| CLA | 116 | 920.8832 | 10.486 | -0.486 |
| CSLA | 321 | 2499.8976 | 4.644 | +5.356 |

CLA has the lowest synthesized area, while CSLA provides the shortest maximum delay and the largest positive worst negative slack margin. RCA has the smallest mapped cell count but a longer critical-path delay than both CLA and CSLA.

### 13.2 Normalized Baseline Comparison

The following ratios are normalized independently to the best measured value for each metric:

| Architecture | Area | Delay | Low Power | Random Power | High Power |
|---|---:|---:|---:|---:|---:|
| RCA | 1.17x | 2.63x | 1.27x | 1.00x | 1.74x |
| CLA | 1.00x | 2.26x | 1.00x | 1.09x | 1.21x |
| CSLA | 2.71x | 1.00x | 1.54x | 2.71x | 1.00x |

The normalized results show that no single architecture is best across all measured dimensions.

### 13.3 Baseline Trade-off Summary

- **RCA:** lowest random-workload power, with moderate area but the longest maximum delay.
- **CLA:** lowest area and lowest low-workload power, while providing better timing than RCA.
- **CSLA:** substantially lower delay and positive timing margin, but with significantly higher area and workload-dependent power.
- Power ranking changes with switching workload, demonstrating that workload must be considered when comparing architecture-level power.
- The baseline results do not identify a universal PPA-optimal architecture.

These results represent the measured baseline implementations. Architectural optimization has not yet been performed.

---

## 14. Architectural Analysis

The baseline measurements demonstrate that RCA, CLA, and CSLA make different architectural trade-offs between area, timing, and power. No architecture is dominant across all measured metrics and switching workloads.

### 14.1 Ripple-Carry Adder

The RCA consists of 32 full-adder stages connected through a sequential carry chain. Each stage depends on the carry generated by the preceding stage.

This structure results in the longest measured maximum delay:

- Maximum delay: 12.197 ns
- WNS: -2.197 ns
- Area: 1081.0368
- Cell count: 64

The RCA therefore fails the 10 ns timing reference. However, it has the lowest measured random-workload power at 84.920 µW.

The relatively compact implementation and absence of duplicated arithmetic paths contribute to its low hardware cost compared with CSLA.

### 14.2 Carry-Lookahead Adder

The CLA uses four 8-bit lookahead blocks. Within each block, explicit generate and propagate equations calculate the internal carries without requiring a full sequential ripple through all eight bits.

The four 8-bit blocks are themselves connected through block-level carries.

Measured results:

- Maximum delay: 10.486 ns
- WNS: -0.486 ns
- Area: 920.8832
- Cell count: 116

CLA has the lowest measured area and improves maximum delay by 14.0% relative to RCA. It nevertheless misses the 10 ns timing reference by 0.486 ns.

CLA also has the lowest measured low-switching power at 0.117 µW.

### 14.3 Carry-Select Adder

The CSLA uses four 8-bit blocks. The first block uses the actual input carry, while each subsequent block evaluates both possible carry-in values in parallel. Multiplexing then selects the result corresponding to the actual incoming carry.

This parallel precomputation substantially reduces the critical-path delay:

- Maximum delay: 4.644 ns
- WNS: +5.356 ns
- Area: 2499.8976
- Cell count: 321

CSLA is the only baseline architecture that meets the 10 ns timing reference. Its maximum delay is 61.9% lower than RCA and 55.7% lower than CLA.

The timing improvement comes with a substantial area cost. CSLA uses 131.2% more area than RCA and 171.5% more area than CLA.

### 14.4 Workload-Dependent Power Behavior

The power measurements demonstrate that architecture-level power ranking depends strongly on switching workload.

| Workload | Best Architecture | Best Total Power |
|---|---|---:|
| Low | CLA | 0.117 µW |
| Random | RCA | 84.920 µW |
| High | CSLA | 95.690 µW |

Under random switching, CSLA consumes 170.7% more total power than RCA. Under high switching activity, however, CSLA has the lowest measured total power.

This reversal indicates that a single representative switching condition is insufficient to characterize the power behavior of these architectures.

Leakage power remains negligible compared with dynamic power for all measured workloads, so the observed differences are primarily associated with dynamic power.

### 14.5 Overall Baseline Trade-off

The measured baseline implementations establish three distinct design points:

- **RCA:** compact hardware and lowest random-workload power, but fails the timing target.
- **CLA:** lowest area and lowest low-switching power, with improved timing relative to RCA but still slightly missing the timing target.
- **CSLA:** strongest timing performance and the only architecture meeting the 10 ns reference, at the cost of substantially greater area and strongly workload-dependent power.

Therefore, the baseline measurements do not identify a universal winner. Architecture selection depends on the relative importance of timing, area, and expected switching activity.

These conclusions apply to the measured 32-bit implementations under the defined Sky130 HD, TT, 0.25°C, 1.80 V methodology. They should not be generalized beyond the studied implementation and measurement conditions without further experiments.
