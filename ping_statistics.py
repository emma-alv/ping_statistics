import os
import pandas as pd
import matplotlib.pyplot as plt


def _clean_data_(current_list):

    clean_data = []
    time = []

    for i in current_list:
        if "time=" in i:
            clean_data.append(i.split())

    for i in clean_data:
        time.append(float(i[6].replace("time=", "")))

    return time


def _extend_data_(list_extend):

    while len(list_extend) < 100:
        list_extend.append(0)

    return list_extend


listFiles = [i for i in os.listdir('.') if "google" in i]
d = {}

for i in listFiles:
    with open(i) as data:
        vars()["uc_"+i] = data.readlines()

for i in listFiles:
    vars()[i] = _clean_data_(vars()["uc_"+i])

for i in listFiles:
    vars()[i] = _extend_data_(vars()[i])

for i in listFiles:
    d.update({i : vars()[i]})

df = pd.DataFrame(d)

df_means = pd.DataFrame(df.mean(axis=0))
df_results = df_means.transpose()
df_results = df_results.append(df.std(axis=0), ignore_index=True)
df_results = df_results.append(df.var(axis=0), ignore_index=True)
df_results.rename({0: 'Average', 1: 'Standard deviation', 2: 'Variance'}, inplace=True)

print(df_results)

for i in listFiles:
    df_plt = df[i].plot(kind='hist', x=i)
    plt.savefig(i + '.png')

