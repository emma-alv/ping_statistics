import os
import pandas as pd

listFiles = [i for i in os.listdir('.') if "google" in i]

for i in listFiles:
    with open(i) as data:
        vars()["uc_"+i] = data.readlines()

for i in listFiles:
    vars()[i] = _clean_data(vars()["uc_"+i])

for i in listFiles:
    vars()[i] = _extend_data(vars()[i])


def _clean_data(current_list):

    clean_data = []
    time = []

    for i in current_list:
        if "time=" in i:
            clean_data.append(i.split())

    for i in clean_data:
        time.append(float(i[6].replace("time=", "")))

    return time


def _extend_data(list_extend):

    while len(list_extend) < 100:
        list_extend.append(0)

    return list_extend

