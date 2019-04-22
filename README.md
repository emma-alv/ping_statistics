# Ping Statistics - 411-MTP
Simple App to compute statistics using ping command and pandas dataframes in python.

## Introduction
The main target of this project is to create a simple codification which can compute simple statistics as "Time Average", "Standard Deviation" and "Variance". 

To do this we are going to use "Bash scripting" and "Pandas data frames". First, we should obtain information from the ping command (bash script). After that, we have to filter all unnecessary data to have a data frame only with the useful information for our main purpose (python data frames).

##  Bash script

To start with our project, first of all, we should obtain the information necessary to work with it.

We created a simple bash script where we defined the ping command, the ip address to test, how many pings we want to send and the time interval between each ping. The information of each ping command will be save in a simple file.

````
#! /bin/bash

ping -c 100 -i 3 google.com > google_usa
ping -c 100 -i 3 google.ie > google_ie
ping -c 100 -i 3 google.in > google_in
ping -c 100 -i 3 google.mx > google_mx
ping -c 100 -i 3 google.co.uk > google_uk
`````

## Python Pandas Data frames

After having obtained all files with the result of ping commands, we can star to with Pandas Data frames in Python to compute all the statistics needed.

Before start, we are going to use some Python libraries to develop our python script, these libraries are:
* OS: We need it to ask for some information about the files created before.
* Pandas: Library needed to work with Pandas Data frames
* Matplotlib: To a better understand of our results, we can plot them using this library.

### Open and Filter data

Before start with the analysis of the information, we should filter it. 

Our first step is to create a list with the name of the files created before, this list can help us to handle all the information in the steps ahead. To do this, we use the function listdir from the library os to read all the file names in our current directory, with a simple if statement we can filter all files names to save in our list only the files names of the files needed

````
listFiles = [i for i in os.listdir('.') if "google" in i]
`````
Once we have the files name saved in a list, we can use this list to call back the information of the files.

For now, we only have information about files names but we need to open them and extract all data inside. To open files we are going to use the function open which allows us to read the file and save all data in lists to work with them after.

`````
for i in listFiles:
    with open(i) as data:
        vars()["uc_"+i] = data.readlines()
 `````
 
As I mentioned before, we have unnecessary information inside these files, which now are in different lists named as the file name adding a prefix "uc" (unclean). So, we should filter all the information to have the same type of list but now only with the time per ping reply.

To filter all the information we are going to use two for loops. The first loop will filter all the elements in each list and will keep only the elements in the which have the string "time=". After this, the second filter will delete all the strings "time=" to remain only numeric values of times.

To better handling of our data and an easier way to work with it, we create a new function in python called "clean_data". So, we should only call the function and send the list which we are working to filter the information as we said before.

```` 
# Function clean data
def _clean_data_(current_list):

    clean_data = []
    time = []

    for i in current_list:
        if "time=" in i:
            clean_data.append(i.split())

    for i in clean_data:
        time.append(float(i[6].replace("time=", "")))

    return time
  
# Cleaning our data using the function clean_data
for i in listFiles:
  vars()[i] = _clean_data_(vars()["uc_"+i])
 ``````

At this point, we have values of time from each ping reply. But, as we know if there were timeout pings replies we will miss this information from our created data. As we set in the ping command we are asking for 100 pings per IP, so is important to be sure that each list of ping values has 100 elements, if they don't have, we should fill the missing information with 0s. Doing this action we will have a more accurate result when we compute our statistics.

``````
def _extend_data_(list_extend):

    while len(list_extend) < 100:
        list_extend.append(0)

    return list_extend

for i in listFiles:
    vars()[i] = _extend_data_(vars()[i])
````````

After this last extension of data finally, we have a series of lists which have only useful information and the length fixed for our calculation purpose.

### Pandas Data frames

Once we have all our data filtered, we can create this information in a Padas Data frame.

One way to do this is to create a new dictionary where we are going to merge all the lists using the names of the files as key and the contents of the lists as data per key. After that, we can create a new Data frame from this dictionary.

````
d = {}

for i in listFiles:
    d.update({i : vars()[i]})

df = pd.DataFrame(d)
`````

Now our data is in a Data frame, we can work with it using functions from Pandas.

Let's create a new data frame with the results of our computations, to do this with can append the result of each operation to the data frame "results"

``````
df_means = pd.DataFrame(df.mean(axis=0))
df_results = df_means.transpose()
df_results = df_results.append(df.std(axis=0), ignore_index=True)
df_results = df_results.append(df.var(axis=0), ignore_index=True)
df_results.rename({0:'Average',1:'Standard deviation',2:'Variance'}, inplace=True)
````````

For a better understanding of the data, we can plot in histograms all the information per website

`````
for i in listFiles:
  df_plt = df[i].plot.hist(x = i)
  plt.show()
```````
