import getpass
from setuptools import setup, find_packages
from setuptools.command.install import install

class GetVersionCommand(install):
    description = "Get the version of this build"

    def run(self):
        print(find_version())


def find_version():
    build_base = "0" 
    build_num = f"0.dev0+{getpass.getuser()}"

    return build_base + f".{build_num}"

setup(
    name="hwlib",
    version=find_version(),
    packages=find_packages(),
    package_data={},
    license="",
    author="Sai Mohan Kilambi",
    author_email="skilambi@gmail.com",
    description="Hardware Library Python Tools",
    long_description="Set of python tools for HWLIB",
    keywords="hwlib",
    python_requires=">=3.12",
    install_requires=[
        "dataclasses",
        "docopt",
        "junitparser",
        "pyyaml",
        "tabulate",
        "termcolor",
        "teamcity-messages",
        "edalize",
        "vunit_hdl",
        "dohq_teamcity",
        "pydantic",
        "networkx",
        "cocotb",
        "cocotbext-axi",
        "cocotb-test",
    ],
    #tests_require=["pytest"],
    #entry_points={
    #    "console_scripts": []
    #},
    cmdclass={"get_version": GetVersionCommand},
)
