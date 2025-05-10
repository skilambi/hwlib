import logging
import shutil, sys
import argparse
from vunit import VUnit

from hwlibrepo.hwlibrepo import hwrepo # singleton object that contains all the files needed for compilation
from hwutils.decorators import singleton

# Configure logging
logging.basicConfig(
    level=logging.WARNING,  # Set the logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    format="%(asctime)s - %(levelname)s - %(message)s",  # Log message format
    datefmt="%Y-%m-%d %H:%M:%S"  # Date format
)
logger = logging.getLogger(__name__)
 
# Step 1: Parse custom --simulator argument
parser = argparse.ArgumentParser()
parser.add_argument("--simulator", type=str, help="Specify simulator (questa, ghdl, etc.)")
args, remaining_argv = parser.parse_known_args()

# Step 2: Set environment variable for VUnit to pick up
if args.simulator:
    import os
    os.environ["VUNIT_SIMULATOR"] = args.simulator

# Check to see that questa is installed correctly
# Check if 'vsim' is available in PATH
if args.simulator == "questa":
    if shutil.which("vsim") is None:
        print("Error: QuestaSim ('vsim') not found in PATH.")
        print("Please add the QuestaSim bin directory to your system PATH.")
        sys.exit(1)

# Create Vunit Instance
vu = VUnit.from_argv(argv=remaining_argv)

# Print which simulator is being used
print(f"Using simulator: {vu._simulator_class.__name__}")

vu.add_vhdl_builtins()
vu.add_verilog_builtins()

# Add all the files from the hwlibrepo singleton object
lib = vu.add_library("lib")
for file in hwrepo.sv_rtl_files:
    lib.add_source_file(file)
for file in hwrepo.vhdl_rtl_files:
    lib.add_source_file(file)
for file in hwrepo.sv_tb_files:
    lib.add_source_file(file)
for file in hwrepo.vhdl_tb_files:
    lib.add_source_file(file)
    
 
# Run the vunit function
vu.main()