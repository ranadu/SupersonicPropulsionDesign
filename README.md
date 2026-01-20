# Supersonic Propulsion System Design & Trade Study (Mach 3.2)

A preliminary propulsion system design study for sustained Mach 3.2 cruise.  
This project combines **supersonic inlet optimization** using the Oswatitsch equal-strength shock principle with a **one-dimensional parametric turbojet cycle analysis**, culminating in a trade study against an off-the-shelf supersonic engine.

> **Focus:** Mission-driven propulsion design, feasibility analysis, and engineering trade-offs at high Mach number.

---

## Project Overview

The goal of this project is to evaluate propulsion system requirements for a hypothetical commercial aircraft capable of sustained Mach 3.2 cruise. Rather than extrapolating existing engines beyond their intended operating envelopes, a **fictional mission-optimized turbojet** is designed and compared against a real-world benchmark engine.

The project is structured in two major parts:

1. **Supersonic Inlet Design**
2. **Parametric Engine Cycle Analysis & Trade Study**

---

## Part I — Supersonic Inlet Design

A three-ramp external-compression inlet was designed to decelerate freestream flow from Mach 3.2 to subsonic conditions prior to the engine face.

### Key Features
- Three oblique shocks followed by a terminal normal shock
- Designed using the **Oswatitsch equal-strength shock principle**
- Maximizes total pressure recovery across the inlet
- Numerically solved using compressible flow relations

### Results
- Optimized ramp deflection angles
- Total inlet pressure recovery:  
  **πₙ ≈ 0.793**
- Geometry suitable for integration with a high-speed turbojet

---

## Part II — Parametric Cycle Analysis

A one-dimensional turbojet cycle model was developed to explore the design space for sustained Mach 3.2 cruise.

### Parameters Studied
- Compressor pressure ratio (π₍c₎)
- Turbine inlet temperature (Tₜ₄)
- Specific thrust
- Thrust-specific fuel consumption (TSFC)

Negative or non-physical operating points were automatically excluded to ensure meaningful results.

### Fictional Engine Design Point
A feasible design point was selected using a minimum specific thrust constraint:

| Parameter | Value |
|---------|------|
| Mach number | 3.2 |
| Compressor pressure ratio | 10.26 |
| Turbine inlet temperature | 2000 K |
| Specific thrust | ~390 N/(kg/s) |
| TSFC | ~4.0×10⁻⁵ kg/(N·s) |

This configuration highlights the need for **high turbine inlet temperature** and **moderate compressor pressure ratio** to overcome ram drag at extreme supersonic speeds.

---

## Off-the-Shelf Engine Comparison

The **Rolls-Royce/Snecma Olympus 593** (Concorde) was selected as a benchmark engine.

### Findings
- Designed for efficient cruise near **Mach 2**
- Lower turbine inlet temperature (~1355 K)
- Higher compressor pressure ratio (~15.5)

When evaluated at Mach 3.2 using the same cycle framework, the Olympus 593 **did not produce positive net thrust**, indicating that it is not suitable for sustained Mach 3.2 cruise without significant cycle modification.

This result reinforces a key engineering conclusion:

> **Propulsion systems optimized for Mach 2 cannot be directly extrapolated to Mach 3+ operation without substantial redesign.**

---

## Key Engineering Takeaways

- Supersonic inlet performance is critical at high Mach number
- High turbine inlet temperature is essential to overcome ram drag at Mach 3+
- Moderate compressor pressure ratios are preferable at extreme inlet temperatures
- Mission-specific propulsion design is required beyond Mach 2 cruise
- Existing supersonic engines demonstrate clear feasibility limits

---

## Tools & Methods

- **MATLAB**
  - Supersonic inlet solver
  - Parametric turbojet cycle analysis
- **LaTeX**
  - Technical report preparation
- **Compressible Flow Theory**
- **Thermodynamics of Propulsion**

---

## Report

The complete technical report (PDF) includes:
- Governing equations and assumptions
- Inlet geometry and shock analysis
- Parametric cycle maps
- Trade study results
- Final design conclusions

📄 **[Report PDF available in the `docs/report` directory]**

---

## Author

**Robert Anadu**  
Aerospace Engineering (B.Eng)  
Focus areas: Propulsion, Controls, Simulation, Systems Design

---

## Disclaimer

This project is a **preliminary design study** intended for educational and portfolio demonstration purposes. Numerical results are based on simplified one-dimensional models and publicly available reference data.
