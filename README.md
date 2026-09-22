# Verilog HDL Projects

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#verilog-hdl-projects)

## Overview

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#overview)

This repository contains a collection of digital design projects implemented using Verilog HDL. Each project demonstrates fundamental RTL design concepts, functional verification using testbenches, and simulation in ModelSim/QuestaSim. The repository includes complete source code, testbenches, simulation waveforms, and result files for each project.

## Projects Included

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#projects-included)

### 1. UART (Universal Asynchronous Receiver Transmitter)

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#1-uart-universal-asynchronous-receiver-transmitter)

A UART communication system consisting of a transmitter, receiver, baud rate generator, and top module for asynchronous serial communication.

**Key Features**

* UART Transmitter (TX)
* UART Receiver (RX)
* Baud Rate Generator
* Loopback Testing
* Verilog Testbench

### 2. FIFO (First In, First Out) Design

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#2-fifo-first-in-first-out-design)

A synchronous FIFO implemented using Verilog HDL to store and retrieve data in the order it is received.

**Key Features**

* Read and Write Operations
* Full Flag Detection
* Empty Flag Detection
* Simultaneous Read and Write Support
* Verilog Testbench

### 3. Digital Lock System

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#3-digital-lock-system)

A password-based digital lock system that unlocks only for the correct password. The design includes a security feature that locks the system after **three consecutive incorrect password attempts** until it is reset.

**Key Features**

* Password Verification
* Three-Attempt Security Lockout
* Lock and Unlock Logic
* Reset Functionality
* Verilog Testbench

### 4. Enhanced UART Design and Verification

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#4-enhanced-uart-design-and-verification)

An enhanced UART communication system implemented using Verilog HDL. The design integrates a configurable baud-rate generator, UART transmitter, UART receiver, TX/RX FIFOs, and a UART controller. It also includes configurable data bits, parity, stop bits, error detection, and a **three-retry retransmission mechanism**.

**Key Features**

* UART Transmitter (TX)
* UART Receiver (RX)
* Configurable Baud Rate Selection
* Configurable Data Bits (5, 6, 7, and 8 bits)
* Configurable Parity (None, Even, and Odd)
* Configurable Stop Bits (1 and 2)
* TX and RX FIFOs
* 16-Depth TX and RX FIFOs
* Parity Error Detection
* Framing Error Detection
* Three-Retry Retransmission Mechanism
* Verilog Testbench
* ModelSim Simulation

## Tools Used

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#tools-used)

* Verilog HDL
* ModelSim
* Vivado

## Repository Structure

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#repository-structure)

```text
Verilog/
├── UART/
│   ├── Source_Code/
│   ├── Testbench/
│   ├── Waveforms/
│   ├── Results/
│   └── README.md
│
├── FIFO/
│   ├── Source_Code/
│   ├── Testbench/
│   ├── Waveforms/
│   ├── Results/
│   └── README.md
│
├── Digital_Lock/
│   ├── Source_Code/
│   ├── Testbench/
│   ├── Waveforms/
│   ├── Results/
│   └── README.md
│
├── Enhanced_UART/
│   ├── Source_Code/
│   ├── Testbench/
│   ├── Waveforms/
│   ├── Results/
│   └── README.md
│
└── README.md
```

**svg**

## Learning Outcomes

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#learning-outcomes)

* RTL Design using Verilog HDL
* Testbench Development
* Functional Verification
* Finite State Machine (FSM) Design
* UART Communication Protocol
* FIFO Design Concepts
* Password-Based Digital Lock Design
* Configurable UART Design
* Error Detection and Retransmission
* Waveform Analysis
* Simulation using ModelSim / QuestaSim
* Version Control using Git and GitHub

## Future Enhancements

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#future-enhancements)

* Develop SystemVerilog-based testbenches
* Add assertion-based verification
* Implement constrained-random verification
* Extend the designs for FPGA implementation
* Integrate automated simulation workflows
* Add coverage-driven verification
* Develop reusable verification environments

## Author

[svg](https://github.com/Kristapalli-Om-Raghavi/Verilog/tree/main#author)

**K. Om Raghavi**
ECE Student | Aspiring VLSI Design Verification Engineer

