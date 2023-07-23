from setuptools import setup
from uois import __version__
import os

# here = os.path.abspath(os.path.dirname(__file__))
# requires_list = []
# with open(os.path.join(here, 'requirements.txt'), encoding='utf-8') as f:
#     for line in f:
#         requires_list.append(str(line))

setup(
    name="uois",
    version=__version__,
    author="Chris Xie",
    packages=["uois"],
    # package_dir={"": ""},
    python_requires=">=3.8.0, <3.10",
    # install_requires=requires_list,
)
