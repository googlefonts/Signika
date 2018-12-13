from Glyphs import *
import sys
import os
import objc

relPath = sys.argv[-1]
# font = GSFont(filename)
directory = os.getcwd()
fullPath = str(directory + "/" + relPath)
document = Glyphs.open((fullPath), False)
font = document.font()

# lightValue = value of lightest active Instance
# boldValue = value of heaviest active instance

# make masters from instance interpolations of:
    # light
    # bold
    # light negative
    # bold negative

# set custom param "Axes"
    # Weight, wght
    # Negative, NEGA

# set weight value in each master
    # if "light" in name, weight = light instance (50)
    # if "bold"

# set negative value in each master
    # if "Negative" in name, Negative = -1
    # else Negative = 0

# set weight value in each instance
    # if "light" in name, weight = light instance (50)
    # if "bold"

# set negative value in each instance
    # if "Negative" in name, Negative = -1
    # else Negative = 0