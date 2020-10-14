import random

import cv2
import numpy


def get_bytes_from_file(filename):
    with open(filename, "r") as f:
        return f.read()


filename = "imagen_desencriptada.txt"
width = 640
height = 480
data = get_bytes_from_file(filename).rstrip('\x00').rstrip()

data = data.split(' ')

datatmp = []
for i in range(len(data)):
    if data[i] != '':
        datatmp.append(data[i])
    else:
        datatmp.append(str(random.randrange(1, 255)))
data = datatmp

data = list(map(int, data))

data = numpy.array(data)

uwuImage = data.reshape(width, height)
cv2.imwrite('racso_uwu.png', uwuImage)
