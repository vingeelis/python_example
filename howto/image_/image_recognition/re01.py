
from PIL import Image
import numpy as np



i = Image.open('./images/dot.png')
iar = np.asanyarray(i)
print(iar)

jsonString = "";