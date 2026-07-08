# UART (Universal Asynchronous Receiver Transmitter)

## Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) using Verilog HDL. The design consists of a UART Transmitter, UART Receiver, Baud Rate Generator, and a Top Module. It enables asynchronous serial communication by transmitting and receiving 8-bit data. The functionality is verified using a Verilog testbench and simulated in ModelSim.

## Features
* UART Transmitter (TX)
* UART Receiver (RX)
* Baud Rate Generator
* Top Module Integration
* Loopback Testing
* Verilog Testbench
* ModelSim Simulation
  
## Tools Used
* Verilog HDL
* ModelSim
  
## Applications
* Microcontroller Communication
* FPGA-Based Systems
* Embedded Systems
* Serial Data Communication
* UART-Based Peripheral Interfaces
  
## Project Files
* `uart_tx.v` – UART Transmitter Module
* `uart_rx.v` – UART Receiver Module
* `baud_gen.v` – Baud Rate Generator
* `uart_top.v` – Top Module
* `uart_tb.v` – Testbench
* `uart_Waveform/` – Simulation waveform screenshots/files
* `uart simulation Results/` – Simulation output file
  
## Result
Successfully transmitted and received 8-bit serial data with correct timing. The design was functionally verified using a Verilog testbench, and the simulation results confirmed proper UART communication.

