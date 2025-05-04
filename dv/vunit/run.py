import logging
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

# Create Vunit Instance 
vu = VUnit.from_argv()

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