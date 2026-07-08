# FIFO (First In, First Out) Design Verification

## Overview

This project implements a **Synchronous FIFO (First In, First Out)** using Verilog HDL. The FIFO stores data in the order it is received and retrieves it in the same order. The design supports read and write operations while monitoring the **Full** and **Empty** status flags. The functionality is verified using a Verilog testbench and simulated in ModelSim.

## Features
* Synchronous FIFO Design
* Read Operation
* Write Operation
* Full Flag Detection
* Empty Flag Detection
* Simultaneous Read and Write Support
* Verilog Testbench
* ModelSim Simulation

## Tools Used
* Verilog HDL
* ModelSim 

## Applications
* Data Buffering
* Processor-to-Processor Communication
* UART and SPI Communication
* Digital Signal Processing (DSP)
* FPGA and Embedded Systems

## Project Files
* `fifo.v` – FIFO Design Module
* `fifo_tb.v` – Testbench
* `FIFO_DESIGN_WAVEFORMS/` – Simulation waveform screenshots/files
* `FIFO_DESIGN_SIMULATION_RESULT/` – Simulation output screenshots/logs

## Result
Successfully verified FIFO functionality by performing read and write operations under different conditions. The simulation confirmed correct data ordering (First In, First Out), proper generation of Full and Empty flags, and reliable FIFO operation.

