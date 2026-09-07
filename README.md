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

---

## 15. Controlled Optimization

After completing and validating the baseline characterization, controlled optimization was performed on the CSLA architecture. The optimization objective was to reduce power and area while preserving the primary timing requirement:

- Maximum delay must remain ≤ 10 ns.
- The 32-bit interface must remain unchanged.
- The fundamental CSLA carry-select architecture must be preserved.
- The same switching workloads and measurement methodology must be used.
- Optimization decisions must be based on measured PPA results.

Two controlled CSLA variants were evaluated.

### 15.1 OPT1 — 8 × 4-bit CSLA Partition

The first optimization divided the 32-bit CSLA into eight 4-bit carry-select blocks instead of the baseline four 8-bit blocks.

The carry-select principle was preserved: the first block used the actual input carry, while subsequent blocks evaluated both possible carry-in values and selected the appropriate result.

The hypothesis was that smaller speculative arithmetic blocks could reduce the cost of duplicated arithmetic.

Measured results:

| Metric | Baseline CSLA | OPT1 | Change |
|---|---:|---:|---:|
| Cell count | 321 | 380 | +18.4% |
| Area | 2499.8976 | 2657.5488 | +6.3% |
| Maximum delay | 4.644 ns | 4.450 ns | -4.2% |
| WNS @ 10 ns | +5.356 ns | +5.550 ns | +0.194 ns |
| Low power | 0.1795 µW | 0.1682 µW | -6.3% |
| Random power | 229.9 µW | 250.1 µW | +8.8% |
| High power | 95.69 µW | 94.34 µW | -1.4% |

Although OPT1 improved timing slightly, it increased area and random-workload power.

The finer partition also increased the number of carry-selection boundaries from three to seven, increasing selection overhead. Therefore, OPT1 was rejected as a PPA optimization.

### 15.2 OPT2 — Shared Arithmetic CSLA

The second optimization retained the original four 8-bit CSLA partition and targeted the duplicated arithmetic itself.

For each speculative block, the carry-in=0 result was computed as:

`A + B`

The carry-in=1 result was then derived by incrementing that result:

`(A + B) + 1`

This preserves the original carry-select structure and the three selection boundaries while avoiding independent computation of both arithmetic results.

The synthesized design retained the same 27 carry-selection mux cells as the baseline CSLA.

Measured results:

| Metric | Baseline CSLA | OPT2 | Change |
|---|---:|---:|---:|
| Cell count | 321 | 206 | -35.8% |
| Area | 2499.8976 | 1595.2800 | -36.2% |
| Maximum delay | 4.644 ns | 4.857 ns | +4.6% |
| WNS @ 10 ns | +5.356 ns | +5.143 ns | -0.213 ns |
| Low power | 0.1795 µW | 0.1792 µW | -0.2% |
| Random power | 229.9 µW | 153.9 µW | -33.1% |
| High power | 95.69 µW | 95.69 µW | ~0% |

OPT2 continues to satisfy the 10 ns timing requirement with 5.143 ns of positive slack.

The principal improvement is observed under random switching, where total power decreases by approximately 33.1%. Area also decreases by approximately 36.2%, while the maximum delay increases by only 4.6%.

### 15.3 Optimization Comparison

The two optimization experiments demonstrate that reducing block size alone is not sufficient to improve CSLA PPA.

OPT1 increased the number of selection boundaries and consequently increased selection overhead. In contrast, OPT2 preserved the four-block structure and directly reduced duplicated arithmetic.

| Variant | Area | Random Power | Delay | Timing Constraint | Decision |
|---|---:|---:|---:|---:|---|
| Baseline CSLA | 2499.8976 | 229.9 µW | 4.644 ns | PASS | Reference |
| OPT1 | 2657.5488 | 250.1 µW | 4.450 ns | PASS | Rejected |
| OPT2 | 1595.2800 | 153.9 µW | 4.857 ns | PASS | **Selected** |

OPT2 provides the best overall measured improvement among the evaluated CSLA implementations.

### 15.4 Selected Optimization

OPT2 is selected as the final optimized CSLA implementation for this study.

Relative to the baseline CSLA, the selected optimization achieves:

- **36.2% lower area**
- **35.8% fewer synthesized cells**
- **33.1% lower random-workload total power**
- Approximately unchanged low-workload power
- Approximately unchanged high-workload power
- **4.6% increase in maximum delay**
- Timing target remains satisfied with **+5.143 ns WNS**

The result demonstrates that a substantial reduction in duplicated arithmetic can improve both area and workload-dependent dynamic power without sacrificing the primary timing requirement.

The optimization therefore supports the architectural conclusion that, for this implementation and methodology, reducing redundant arithmetic within the CSLA structure is more effective than simply increasing the number of smaller carry-select blocks.

---

## 16. Final Study Status

The study has completed baseline characterization and controlled optimization of the three 32-bit adder architectures.

Current status:

- RTL architecture and functional verification: **Complete**
- RTL switching-activity characterization: **Complete**
- Synthesis flow validation: **Complete**
- Area characterization: **Complete**
- Static timing analysis: **Complete**
- Power analysis infrastructure: **Complete**
- Baseline power characterization: **Complete**
- Baseline PPA comparison: **Complete**
- Architectural analysis: **Complete**
- Controlled optimization: **Complete**
- Final study and documentation: **In progress**

The final comparison and conclusions will use the measured RCA, CLA, baseline CSLA, and selected OPT2 results under the defined Sky130 HD TT 0.25°C, 1.80 V methodology.

---

## 17. Final PPA Comparison

The final study compares the three baseline architectures together with the two controlled CSLA optimization variants. All measurements use the same 32-bit interface, synthesis flow, timing constraint, switching workloads, and Sky130 HD TT 0.25°C, 1.80 V technology conditions.

### 17.1 Final Measured Results

| Architecture | Cell Count |      Area | Max Delay (ns) | WNS (ns) | Low Power (µW) | Random Power (µW) | High Power (µW) | 10 ns Timing |
| ------------ | ---------: | --------: | -------------: | -------: | -------------: | ----------------: | --------------: | ------------ |
| RCA          |         64 | 1081.0368 |         12.197 |   -2.197 |         0.1486 |             84.92 |           166.4 | FAIL         |
| CLA          |        116 |  920.8832 |         10.486 |   -0.486 |         0.1167 |             92.31 |           115.6 | FAIL         |
| CSLA         |        321 | 2499.8976 |          4.644 |   +5.356 |         0.1795 |             229.9 |           95.69 | PASS         |
| CSLA OPT1    |        380 | 2657.5488 |          4.450 |   +5.550 |         0.1682 |             250.1 |           94.34 | PASS         |
| CSLA OPT2    |        206 | 1595.2800 |          4.857 |   +5.143 |         0.1792 |             153.9 |           95.69 | PASS         |

The machine-readable final comparison is stored in:

```text
results/ppa_final.csv
```

### 17.2 Area and Timing

CLA has the lowest measured area at 920.8832, followed by RCA at 1081.0368. The baseline CSLA has the largest area at 2499.8976.

CSLA OPT2 reduces the baseline CSLA area to 1595.2800, corresponding to a 36.2% reduction. It also reduces the synthesized cell count from 321 to 206.

RCA and CLA do not satisfy the 10 ns timing requirement. Their measured maximum delays are 12.197 ns and 10.486 ns respectively.

All three CSLA implementations satisfy the timing requirement. OPT1 provides the shortest measured delay at 4.450 ns, while OPT2 measures 4.857 ns and retains 5.143 ns of positive slack.

Thus, OPT2 accepts a modest timing penalty relative to the baseline CSLA while retaining substantial timing margin.

### 17.3 Workload-Dependent Power

The final power measurements confirm that the power ranking depends on switching activity.

Under low switching activity, CLA has the lowest measured total power at 0.1167 µW. OPT2 measures 0.1792 µW, essentially unchanged from the baseline CSLA value of 0.1795 µW.

Under random switching activity, RCA has the lowest measured total power at 84.92 µW. OPT2 reduces the baseline CSLA random-workload power from 229.9 µW to 153.9 µW, corresponding to a 33.1% reduction.

Under high switching activity, OPT1 has the lowest measured total power at 94.34 µW. The baseline CSLA and OPT2 both measure 95.69 µW.

The results therefore do not identify one architecture as the lowest-power design under every workload.

### 17.4 Normalized Final Comparison

The following values are normalized independently to the best measured value for each metric:

| Architecture |  Area | Delay | Low Power | Random Power | High Power |
| ------------ | ----: | ----: | --------: | -----------: | ---------: |
| RCA          | 1.17x | 2.74x |     1.27x |        1.00x |      1.76x |
| CLA          | 1.00x | 2.36x |     1.00x |        1.09x |      1.23x |
| CSLA         | 2.71x | 1.04x |     1.54x |        2.71x |      1.01x |
| CSLA OPT1    | 2.89x | 1.00x |     1.44x |        2.95x |      1.00x |
| CSLA OPT2    | 1.73x | 1.09x |     1.54x |        1.81x |      1.01x |

The normalized comparison reinforces the architectural trade-offs observed throughout the study. CLA remains the smallest design, RCA remains the lowest-power design under random switching, and the CSLA variants provide the strongest timing performance.

OPT2 improves the CSLA design point substantially without attempting to make it universally superior to RCA or CLA.

---

## 18. Final Conclusions

This study evaluated 32-bit Ripple-Carry Adder, Carry-Lookahead Adder, and Carry-Select Adder architectures using a common ASIC characterization flow based on Sky130 HD standard cells.

The baseline results demonstrate that the three architectures occupy distinct points in the area, timing, and power design space.

**RCA** provides a relatively compact implementation and the lowest measured random-workload power. However, its sequential carry propagation results in the longest measured delay of 12.197 ns, causing it to fail the 10 ns timing requirement.

**CLA** provides the lowest measured area and lowest low-switching power. Its lookahead structure improves timing relative to RCA, but the measured delay of 10.486 ns still exceeds the 10 ns target by 0.486 ns.

**CSLA** provides a substantially shorter critical-path delay. The baseline CSLA achieves 4.644 ns maximum delay and +5.356 ns WNS, making it the only baseline architecture that satisfies the 10 ns timing requirement. This timing advantage comes with significantly higher area and workload-dependent power.

The controlled optimization experiments show that changing architectural structure does not automatically produce a better PPA trade-off.

OPT1 changed the CSLA partition from four 8-bit blocks to eight 4-bit blocks. Although this reduced maximum delay by 4.2%, it increased area by 6.3% and random-workload power by 8.8%. The increased number of carry-selection boundaries introduced additional selection overhead, so OPT1 was rejected.

OPT2 retained the four 8-bit CSLA organization and instead targeted duplicated arithmetic. The carry-in=0 result was computed as `A + B`, while the carry-in=1 result was derived by incrementing that result.

This optimization reduced synthesized cell count by 35.8% and area by 36.2% relative to the baseline CSLA. Random-workload power was reduced by 33.1%. Maximum delay increased by 4.6%, from 4.644 ns to 4.857 ns, but the timing requirement remained comfortably satisfied with +5.143 ns WNS.

Therefore, **CSLA OPT2 is selected as the final optimized CSLA implementation**.

The selection of OPT2 does not imply that it is the universal PPA winner across all five measured designs. Instead, it represents the most successful controlled optimization of the CSLA architecture within the defined constraints.

The overall architectural conclusions are:

* **CLA** is the best measured baseline design for minimum area.
* **CLA** is also the best measured baseline design for low switching activity.
* **RCA** provides the lowest measured random-workload power, but fails the 10 ns timing requirement.
* **CSLA** provides the strongest baseline timing performance and is the only baseline architecture that satisfies the 10 ns target.
* **CSLA OPT2** substantially improves the baseline CSLA area and random-workload power while retaining its timing advantage.
* Power rankings change with switching activity, demonstrating the importance of workload-aware power characterization.
* Structural optimization must be evaluated through measured PPA rather than assumed from RTL structure alone.

The study therefore demonstrates that there is no universal winner across area, timing, and workload-dependent power. The appropriate architecture depends on the primary design constraint and expected operating behavior.

These conclusions are specific to the studied 32-bit implementations, Sky130 HD TT 0.25°C, 1.80 V conditions, 10 ns timing reference, synthesis methodology, and defined switching workloads. They should not be generalized to other technologies, widths, libraries, physical-design conditions, or workloads without additional characterization.

The study is complete for the defined experimental scope.

---

## 19. Project Completion Status

All planned stages within the defined study scope are complete:

* RTL architecture and functional verification: **Complete**
* RTL switching-activity characterization: **Complete**
* Synthesis flow validation: **Complete**
* Area characterization: **Complete**
* Static timing analysis: **Complete**
* Power analysis infrastructure: **Complete**
* Baseline power characterization: **Complete**
* Baseline PPA comparison: **Complete**
* Architectural analysis: **Complete**
* Controlled optimization: **Complete**
* Final PPA comparison: **Complete**
* Final conclusions and documentation: **Complete**

The final optimized CSLA implementation is **CSLA OPT2**.

The complete machine-readable PPA dataset is stored in:

```text
results/ppa_final.csv
```

The project remains intentionally scoped to the validated 32-bit study and does not claim universal architectural optimality beyond the defined measurement methodology.
