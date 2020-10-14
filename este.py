import cv2
import numpy


def get_bytes_from_file(filename):
    with open(filename, "r") as f:
        return f.read()
    # return bytearray(open(filename, "rb").read())


filename = "imagen_desencriptada.txt"
width = 640
height = 480
data = get_bytes_from_file(filename)

data = data.split(' ')
data = list(map(int, data))

data = numpy.array(data)

uwuImage = data.reshape(width, height)
cv2.imwrite('uwu.png', uwuImage)
