import time
import pymysql
import pandas as pd
import numpy as np

from dotenv import load_dotenv
load_dotenv()
from os import getenv

# Connect to MariaDB database
connection = pymysql.connect(
    user=getenv("DB_USERNAME"),
    password=getenv("DB_PASSWORD"),
    host="127.0.0.1",
    port=3333,
    database="db_fuelopt"
)

cursor = connection.cursor()

# function to reverse the date
# and to be used to change all the dates
def reverse_date(input_date):
    if not input_date:
        return None
    date_parts = input_date.split(".")
    return f"{date_parts[2]}-{date_parts[1]}-{date_parts[0]}"

# get the station information from the csv
data = pd.read_csv('stations_fuel_prices.csv')
data_id = data["station_id"]
data_prices = data[["unleaded","super_unleaded","diesel","premium_diesel"]].replace({np.nan:None})
data_dates = data[["station_unleaded_date","station_super_unleaded_date","station_diesel_date","station_premium_diesel_date"]].replace({np.nan:None}).applymap(reverse_date)

# exit()
# insert the station information to the database
print("Inserting station information to database:")
for index, row in data.iterrows():
    print("\t",index, "/ 777")
    cursor.execute("""INSERT INTO db_fuelopt.stations_fuelprice
(unleaded_price, diesel_price, super_unleaded_price, premium_diesel_price, unleaded_date, diesel_date, super_unleaded_date, premium_diesel_date, station_id)
VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s);""",(data_prices["unleaded"][index],data_prices["diesel"][index],data_prices["super_unleaded"][index],data_prices["premium_diesel"][index],
data_dates["station_unleaded_date"][index],data_dates["station_diesel_date"][index],data_dates["station_super_unleaded_date"][index], data_dates["station_premium_diesel_date"][index],int(data_id[index])))
    # add a second delay to not overwhelm the database
    connection.commit()
    if (index % 150 == 0):
        time.sleep(1)
        # commit the changes to the database

print("Done inserting station information to database.")
