# Enhanced UART Design and Verification

## Overview

This project implements an **Enhanced Universal Asynchronous Receiver Transmitter (UART)** using Verilog HDL. The design integrates a configurable baud-rate generator, UART transmitter, UART receiver, TX/RX FIFOs, and a UART controller. It supports configurable data bits, parity, stop bits, and includes a **three-retry retransmission mechanism** for reliable data transmission. The functionality is verified using a Verilog testbench and simulated in ModelSim.

## Features

* UART Transmitter and Receiver
* Configurable Baud Rate Selection
* Configurable Data Bits (5, 6, 7, and 8 bits)
* Configurable Parity (None, Even, and Odd)
* Configurable Stop Bits (1 and 2)
* TX FIFO and RX FIFO
* 16-Depth TX and RX FIFOs
* Parity Error Detection
* Framing Error Detection
* TX and RX Status Signals
* Three-Retry Retransmission Mechanism
* Verilog Testbench
* ModelSim Simulation

## Tools Used

* Verilog HDL
* ModelSim

## Applications

* Serial Communication
* Data Transmission and Reception
* Embedded Systems
* FPGA-Based Communication
* Digital Communication Interfaces
* Reliable Data Transfer Systems

## Project Files

* `uart_top.v` – Top-Level UART Module
* `baud_gen.v` – Baud Rate Generator
* `uart_tx.v` – UART Transmitter Module
* `uart_rx.v` – UART Receiver Module
* `tx_fifo.v` – Transmit FIFO Module
* `rx_fifo.v` – Receive FIFO Module
* `uart_controller.v` – UART Controller Module
* `uart_tb.v` – Testbench
* `UART_WAVEFORMS/` – Simulation waveform screenshots/files
* `UART_SIMULATION_RESULT/` – Simulation output screenshots/logs

## Result

Successfully verified the Enhanced UART functionality using ModelSim. The simulation confirmed correct data transmission and reception, FIFO operation, configurable baud-rate selection, different data-bit, parity and stop-bit configurations, error detection, and the three-retry retransmission mechanism.

