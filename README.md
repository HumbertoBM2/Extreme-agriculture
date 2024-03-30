<div align="center">


# Extreme-agriculture
<img src=logodeere.png style="width:25%; height:25%;">

##### Godot game intricately fused with FPGA technology programmed in VHDL. Developed in collaboration with John Deere.

![Static Badge](https://img.shields.io/badge/c%23-green?style=for-the-badge&logo=c%23)
![Static Badge](https://img.shields.io/badge/VHDL-black?style=for-the-badge)
![Static Badge](https://img.shields.io/badge/Intel%20FPGA-blue?style=for-the-badge&logo=intel)
![Static Badge](https://img.shields.io/badge/Godot-478CBF?style=for-the-badge&logo=GodotEngine&logoColor=white)



</div>

## Overview

Extreme Agriculture is an arcade-style game developed in Godot that can be played using an FPGA (Intel DE10-Lite module) as a controller. The game is designed for John Deere enthusiasts and features a tractor navigating through a flying farm, collecting crops, and defeating enemy tractors from other brands.

In Extreme Agriculture, players control a John Deere tractor, maneuvering it around a dynamic environment filled with obstacles and opponents. The goal is to collect crops and achieve the highest score possible while avoiding collisions and enemy attacks. The game offers an immersive experience that combines classic arcade gameplay with modern technology.

## Rules

- Players have 5 lives.
- The game features an autodestruction timer that must be reset by collecting crops.
- The player loses when all lives are lost or when the autodestruction timer reaches zero.
- The objective of the game is to score as many points as possible by harvesting crops.

## Controls

The game controls are implemented using the features of the FPGA:

- Throttle and brake: Integrated buttons on the FPGA.
- Gear shifting: Switches on the FPGA.
- Steering: Accelerometer on the FPGA.
- Shooting and collecting items: Additional buttons connected via GPIO ports using a hat on the FPGA.

## Repository contents 

The repository includes the following files:

- Godot game files.
- VHDL codes used to program the FPGA.

## Usage 

To play Extreme Agriculture, follow these steps:

1. Clone the repository.
2. Upload the VHDL codes to the DE10-Lite FPGA using Intel Quartus.
3. Run the game in Godot.
4. Connect the FPGA to your computer and start playing.

### Prerequisites

Before running the game, ensure you have the following:

- [Git](https://git-scm.com/)
- DE10-Lite FPGA module.
- [Intel Quartus for programming the FPGA.](https://www.intel.com/content/www/us/en/software-kit/660907/intel-quartus-prime-lite-edition-design-software-version-20-1-1-for-windows.html).
- [Godot Engine for running the game.](https://godotengine.org/)

### Installation

To install Extreme Agriculture, simply clone the repository to your local machine:

    ```bash
    git clone https://github.com/HumbertoBM2/Extreme-agriculture.git
    ```

Then, follow the usage instructions mentioned above.

