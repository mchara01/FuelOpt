import time
import mariadb
import pandas as pd


# Connect to MariaDB database
connection = mariadb.connect(
    user="user",
    password="password",
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

# insert the station information to the database
print("Inserting station information to database:")
for index, row in data.iterrows():
    print("\t",index, "/ 777")
    cursor.execute("""INSERT INTO db_fuelopt.stations
    (station_id, street, postcode, lat, lng, name)
    VALUES(?, ?, ?, ?, ?, ?);""", (row["station_id"], row["street"].strip(), row["postcode"].strip(), row["lat"], row["lng"], row["name"].strip(),))
    # add a second delay to not overwhelm the database
    if (index % 200 == 0):
        time.sleep(1)

print("Done inserting station information to database.")
# commit the changes to the database
connection.commit()