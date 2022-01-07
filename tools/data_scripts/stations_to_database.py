import time
import pymysql
import pandas as pd
import numpy as np


# Connect to MariaDB database
connection = pymysql.connect(
    user="fuelopt_main",
    password="N;vZu!93Gh",
    host="127.0.0.1",
    port=3306,
    database="db_fuelopt"
)

cursor = connection.cursor()

# get the station information from the csv
data = pd.read_csv('stations_with_coordinates.csv')

postcodes = []
streets = []

for full_address in data["station_location"]:
    street, postcode = full_address.split(", ")
    postcodes.append(postcode)
    streets.append(street)

data["street"] = streets
data["postcode"] = postcodes
data = data.drop("station_location", axis=1)
data = data.drop("Unnamed: 0", axis=1)
data = data.replace({np.nan:False})

print(data.columns)
# exit()

# insert the station information to the database
print("Inserting station information to database:")
for index, row in data.iterrows():
    print("\t", index, "/ 777")
#     cursor.execute("""INSERT INTO db_fuelopt.stations_station
#     (station_id, street, postcode, lat, lng, name, "CAR WASH", "AIR & WATER", "CAR VACUUM", "24/7 OPENING HOURS", "TOILET", "CONVENIENCE STORE", "ATM", "PARKING FACILITIES", "DISABLED TOILET/BABY CHANGE", "ALCOHOL", "WI-FI", "HGV/PSV FUELING", "FUELSERVICE", "PAYPHONE", "RESTAURANT", "ELECTRIC CAR CHARGING", "REPAIR GARAGE", "SHOWER FACILITIES")
# VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""", 
    cursor.execute("""INSERT INTO db_fuelopt.stations_station
        (station_id, street, postcode, lat, lng, name, car_wash, air_and_water, car_vacuum, 24_7_opening_hours, toilet, convenience_store, atm, parking_facilities, disabled_toilet_baby_change, alcohol, wi_fi, hgv_psv_fueling, fuelservice, payphone, restaurant, electric_car_charging, repair_garage, shower_facilities)
    VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""", 
    (row["station_id"], 
    row["street"].strip(),
    row["postcode"].strip(), 
    row["lat"], 
    row["lng"], 
    row["name"].strip(),
    row["CAR WASH"],
    row["AIR & WATER"],
    row["CAR VACUUM"],
    row["24/7 OPENING HOURS"],
    row["TOILET"],
    row["CONVENIENCE STORE"],
    row["ATM"],
    row["PARKING FACILITIES"],
    row["DISABLED TOILET/BABY CHANGE"],
    row["ALCOHOL"],
    row["WI-FI"],
    row["HGV/PSV FUELING"],
    row["FUELSERVICE"],
    row["PAYPHONE"],
    row["RESTAURANT"],
    row["ELECTRIC CAR CHARGING"],
    row["REPAIR GARAGE"],
    row["SHOWER FACILITIES"]
    ))
    # add a second delay to not overwhelm the database
    if (index % 200 == 0):
        time.sleep(1)

print("Done inserting station information to database.")
# commit the changes to the database
connection.commit()
