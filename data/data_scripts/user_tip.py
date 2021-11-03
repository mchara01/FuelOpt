import numpy as np
import datetime


# function so the user let us know that this station has a queue
def has_queue(df, station):
    df.loc[df['id'] == station, 'queue'] = True
    df.loc[df['id'] == station, 'queue_datetime'] = str(datetime.datetime.now())[:19]
    df.to_csv('data/stations_all_info.csv')


# function so the user let us know that the price of a fuel has changed
def new_price(df, station, fuel_type, price):
    pre_price = float(df.loc[df['id'] == station, fuel_type])
    percentage = np.abs((price - pre_price) / pre_price * 100)
    # we accept the new price only if the percentage of change is les than 2%
    if percentage < 3:
        df.loc[df['id'] == station, fuel_type] = price
    df.to_csv('data/stations_all_info.csv')
