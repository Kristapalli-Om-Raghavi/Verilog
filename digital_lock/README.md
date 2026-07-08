# Digital Lock System

## Overview

This project implements a password-based Digital Lock System using Verilog HDL. The system verifies the entered password and controls the lock status. To enhance security, it allows a maximum of three incorrect password attempts. If the correct password is entered, the system unlocks. After three consecutive incorrect attempts, the system enters a lockout state until it is reset. The functionality is verified using a Verilog testbench and simulated in ModelSim/QuestaSim.

## Features

* Password Verification
* Lock and Unlock Logic
* Reset Functionality
* Verilog Testbench
* ModelSim  Simulation

## Tools Used
* Verilog HDL
* ModelSim

## Applications
* Electronic Door Locks
* Access Control Systems
* Security Systems
* Smart Home Automation
* Digital Security Devices

## Project Files
* `digital_lock.v` – Digital Lock Module
* `digital_lock_tb.v` – Testbench
* `digital_lock_Waveforms/` – Simulation waveform screenshots/files
* `digital_lock simulation Results/` – Simulation output files

## Result

Successfully verified the digital lock functionality by testing both valid and invalid password inputs. The simulation confirmed correct lock and unlock operation based on password verification.

