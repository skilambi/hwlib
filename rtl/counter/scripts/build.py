from edalize.edatool import get_edatool
import os

work_root = "build_dir"

files = [
    {'name': os.path.relpath('../rtl/counter.sv',work_root), 'file_type': 'systemVerilogSource'},
    {'name': os.path.relpath('../sim/tb/counter_tb.sv',work_root), 'file_type': 'systemVerilogSource'}
]
print(files)
#tool = 'icarus'
tool = 'modelsim'

parameters = { 'CNTR_WIDTH' : {'datatype' : 'int', 'default' : 4, 'paramtype': 'vlogparam'} }
tool_options = {
    #'icarus': {'iverilog_options': ['-g2012']}
    'modelsim': {}
}

edam = {
    'files' : files,
    'name'  : 'counter_prj',
    'parameters' : parameters,
    'tool_options' : tool_options,
    'toplevel' : 'counter_tb'
}

backend = get_edatool(tool)(edam=edam,
                            work_root=work_root)

os.makedirs(work_root)
backend.configure()

backend.build()

backend.run()

