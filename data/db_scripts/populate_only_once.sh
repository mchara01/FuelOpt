#!/bin/bash

bash /home/ec2-user/FuelOpt/data/data_scripts/get_stations.py
sleep 5
bash /home/ec2-user/FuelOpt/data/data_scripts/get_station_coordinates.py
sleep 5
bash /home/ec2-user/FuelOpt/data/data_scripts/get_station_prices.py
sleep 5
bash /home/ec2-user/FuelOpt/data/data_scripts/stations_to_database.py
sleep 5
bash /home/ec2-user/FuelOpt/data/data_scripts/fuel_prices_to_database.py

