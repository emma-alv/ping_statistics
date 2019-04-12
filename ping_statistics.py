import os
import pandas as pd

listFiles = [i for i in os.listdir('.') if "google" in i]

for i in listFiles:
    with open (i) as data:
        vars()[i] = data.readlines()

