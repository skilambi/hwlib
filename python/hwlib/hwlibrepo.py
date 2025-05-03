""" hwlibrepo.py
The purpose of this class is to traverse all the directories under hwlib/rtl and hwlib/dv/vunit and read
the lib_def.py file in every folder and generate a list of files that are needed for compilation. It should
take all the dependencies into consideration. 
"""

# Imports
import os
import logging
import importlib.util

# Configure logging
logging.basicConfig(
    level=logging.INFO,  # Set the logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
    format="%(asctime)s - %(levelname)s - %(message)s",  # Log message format
    datefmt="%Y-%m-%d %H:%M:%S"  # Date format
)
logger = logging.getLogger(__name__)


class HwLibRepo:
    # Class Attributes
    
    # Constructor
    def __init__(self):
       # All the RTL files - SV and VHDL
       self.sv_rtl_files = []
       self.vhdl_rtl_files = []
       
       # All the TB files - SV and VHDL
       self.sv_tb_files = []
       self.vhdl_tb_files = []
       
       # Yaml Files
       self.yaml_files = []
       
       
    def collect_files(self):
        """This function traverses all the directories under
        hwlib/rtl and hwlib/dv/vunit 
        """
        base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        rtl_dir = os.path.join(base_dir, "rtl")
        dv_dir = os.path.join(base_dir, "dv", "vunit")
        logger.info(f"Collecting files RTL files from {rtl_dir}") 
        logger.info(f"Collecting files DV files from {dv_dir}")
        
        for root, dirs, files in os.walk(rtl_dir):
            if "lib_def.py" in files:
                lib_def_path = os.path.join(root, "lib_def.py")
                logger.info(f"Found lib_def.py at {lib_def_path}")
                self._process_lib_def(lib_def_path)
                
    def _process_lib_def(self, lib_def_path):
        """ Loads the dictionary in the lib_def.py file and then creates a list
        of files that are needed for compilation. It also checks the source type
        and categorizes the files into systemVerilog and VHDL.
        This function assumes that the lib_def.py file contains a variable named
        `rtl_files` which is a list of dictionaries, each containing 'loc' and 'sourceType'.
        It also checks if the file exists and is absolute. If not, it logs a warning.

        Args:
            lib_def_path (string): The location of the lib_def.py file to process.
        """
        spec = importlib.util.spec_from_file_location("lib_def", lib_def_path)
        lib_def = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(lib_def)
        
        if hasattr(lib_def, 'rtl_files'):
            rtl_files = lib_def.rtl_files
            for file in rtl_files:
                loc = file.get('loc')
                
                if not loc:
                    logger.warning(f"File location not specified in {lib_def_path}")
                    continue
                loc = os.path.join(os.path.dirname(lib_def_path), loc)
                
                if not os.path.isabs(loc):
                    loc = os.path.abspath(loc)
                if not os.path.exists(loc):
                    logger.warning(f"File {loc} does not exist, skipping.")
                    continue
                
                # Check the source type and categorize the files
                source_type = file.get('sourceType', 'unknown')
                if source_type == 'systemVerilog':
                    self.sv_rtl_files.append(loc)
                    logger.info(f"Added SV RTL file: {loc}")
                elif source_type == 'vhdl':
                    self.vhdl_rtl_files.append(loc)
                    logger.info(f"Added VHDL RTL file: {loc}")
                else:
                    logger.warning(f"Unknown source type {source_type} for file {loc}")

if __name__ == "__main__":
    hwlib_repo = HwLibRepo()
    hwlib_repo.collect_files()
    # The next step would be to process the lib_def.py files and collect the files
    # For now, we are just printing the directories and files found. 