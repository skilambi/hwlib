# hwlib - Hardware Library

Hardware Library i.e. hwlib contains multiple RTL modules that can be part of a system. Each RTL block will have its associated documentation in the form of an MD file.
HWLIB should be instantatiated as a subrepo in a *project* so that these blocks are available for building systems.

Under this repo there are three directories
- rtl
- dv
- python

RTL directory contains all the different modules - Mainly systemverilog files.
DV further has vunit and cocotb. Under these subdirectories, the module directories are similar to what you would find under *rtl*. So this forms a one-to-one mapping between RTL and their associated verification.

The python directory defines a hwlib package that can be imported as part of build systems. 