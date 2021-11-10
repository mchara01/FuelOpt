import numpy as np
import pandas as pd
from datetime import datetime, timedelta

# this file contains function of the information that the users provides to the App
# the user can update the price and inform if there is a queue

df = pd.read_csv("data/db_scripts/stations_all_info.csv")

# function so the user let us know that this station has a queue
def has_queue(station):
    df.loc[df['id'] == station, 'queue'] = True
    # add the datetime the queue was updated
    df.loc[df['id'] == station, 'queue_datetime'] = str(datetime.now())[:19]
    df.to_csv('data/stations_all_info.csv', index=False)


# function so the user let us know that the price of a fuel has changed
def new_price(station, fuel_type, price):
    pre_price = float(df.loc[df['id'] == station, fuel_type])
    percentage = np.abs((price - pre_price) / pre_price * 100)
    # we accept the new price only if the percentage of change is les than 5%
    if percentage < 5:
        df.loc[df['id'] == station, fuel_type] = price
    df.to_csv('data/stations_all_info.csv',index=False)

# function to restore queue status after 3 hours have passed without someone updating it
def renew_queue():
    for index, row in df.iterrows():
        if row['queue']:
            diff = datetime.now() - datetime.strptime(row['queue_datetime'],'%Y-%m-%d %H:%M:%S')
            if diff > timedelta(hours=3):
                df.loc[df['id'] == index, 'queue'] = False
                df.loc[df['id'] == index, 'queue_datetime'] = None
    df.to_csv('data/stations_all_info.csv',index=False)