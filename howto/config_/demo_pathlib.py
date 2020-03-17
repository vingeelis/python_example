import os
import sys
from pathlib import Path

# root_path = Path(__file__).parent.parent / '../howto'
root_path = os.path.dirname(os.path.dirname(os.path.realpath(__file__))) + "/../howto"
print(root_path)
