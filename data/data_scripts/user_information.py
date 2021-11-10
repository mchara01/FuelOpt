import numpy as np
from datetime import datetime, timedelta
import pandas as pd

# this file contains function of the information that the users provides to the App
# the user can update the price and inform if there is a queue

df = pd.read_csv("data/stations_all_info.csv")

# function so the user let us know that this station has a queue
def has_queue(station, duration = -1):
    # queue status became True
    df.loc[df['id'] == station, 'queue'] = True
    # we save the datetime this information was given
    df.loc[df['id'] == station, 'queue_datetime'] = str(datetime.now())[:19]
    # we save the estimated duration the user gived in minutes
    # if it is provided
    if duration>0:
        df.loc[df['id'] == station, 'queue_duration'] = duration
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

# function to check if string is time format
# with hours and minutes
def isTimeFormat(str):
    try:
        datetime.strptime(str, '%H:%M')
        return True
    except ValueError:
        return False

# function to inform about the opening hour of station
def add_opening_hour(station, opening):
    if isTimeFormat(opening):
        df.loc[df['id'] == station, 'opening_hour'] = opening
        df.to_csv('data/stations_all_info.csv', index=False)

# function to inform about the closing hour of station
def add_closing_hour(station, closing):
    if isTimeFormat(closing):
        df.loc[df['id'] == station, 'closing_hour'] = closing
        df.to_csv('data/stations_all_info.csv', index=False)