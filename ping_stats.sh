#! /bin/bash

ping -c 100 -i 3 google.com > google_usa
ping -c 100 -i 3 google.ie > google_ie
ping -c 100 -i 3 google.in > google_in
ping -c 100 -i 3 google.mx > google_mx
ping -c 100 -i 3 google.co.uk > google_uk

python3 -mpip install matplotlib
python3 ping_statistics.py