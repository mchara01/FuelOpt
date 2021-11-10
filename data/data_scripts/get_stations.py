from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException
from selenium.common.exceptions import NoSuchElementException

from time import time
import pandas as pd

from dotenv import load_dotenv
import os 
load_dotenv()

start = time()
# options to run the chrome browser headless
# so no window is showing
options = Options()
options.add_argument("--headless")

# signing in
data = {
    "email": os.getenv("PETROL_USERNAME"),
    "password": os.getenv("PETROL_PASSWORD"),
    "url": "https://app.petrolprices.com/login"
}
# initialise browser and go to sign in url
browser = webdriver.Chrome(ChromeDriverManager().install(), options=options)

# try to reload page
# it it is still loading after 10 seconds
browser.set_page_load_timeout(10)
while True:
    try:
        print("Loading signin Page")
        browser.get(data['url'])
        print("Signin Page Loaded")
        break
    except TimeoutException:
        print("Page took too long to load. Reloading")


# fill the account info and click sign in
browser.find_element(By.NAME, "email").send_keys(data['email'])
browser.find_element(By.NAME, "password").send_keys(data['password'])

# again try to reload page
# it it is still loading after 10 seconds
while True:
    try:
        print("Logging In")
        browser.find_element(By.ID, 'account-submit').click()
        print("Succesfuly Logged In")
        break
    except TimeoutException:
        print("Page took too long to load. Reloading")

# go through each result and put it on a list
stationDF = []
station_names_set = set()

# get all prices by making a new tab for each station
# then going to each petrol station
browser.switch_to.new_window('tab')
browser.switch_to.window(browser.window_handles[0])

counter = 0

for latitude in [51.3, 51.3, 51.4, 51.5, 51.6, 51.7]:
    for longitude in [-0.4, -0.3, -0.2, -0.1, 0.0, 0.1, 0.2]:

        
# for latitude in [51.3]:
#     for longitude in [-0.4]:

        # arguments to put in the url
        # distance is in miles
        # should change the lat (latitude) and lng (longitude) to get the desired results
        arguments = {
            "fuelType": "2",
            "sortType": "distance",
            "distance": "10",
            "latitude": str(latitude),
            "longitude": str(longitude)
        }
        browser.get('https://app.petrolprices.com/map?' +
                    arguments['fuelType']+'=2&brandType=0&resultLimit=0&offset=0&sortType=' +
                    arguments['sortType']+'&lat=' +
                    arguments['latitude']+'&lng=' +
                    arguments['longitude']+'&z=11&d=' +
                    arguments['distance']
                    )

        results = browser.find_element(By.ID, 'map-api-status')

        # wait for results to come
        while results.get_attribute("style") != "display: none;":
            results = browser.find_element(By.ID, 'map-api-status')

        # get to the results
        stations_results = browser.find_element(
            By.ID, 'result-output').find_elements(By.CLASS_NAME, 'stationDiv')

        # browser.find_element(By.ID, 'continue-button').click()

        print("For location with latitude:",arguments["latitude"], "longitude:",arguments["longitude"])

        for station in stations_results:
            print(counter, end=" ")
            # station_price_date = station.find_elements(By.TAG_NAME, "h5")[
            #     2].text
            # get the name of the station from the stations page
            # so if the station is already looked up there is no need to check its prices
            station_name = station.find_element(
                By.CLASS_NAME, "station-name").text.split(". ")[1]
            print(station_name, end=" ")
            if station_name in station_names_set:
                print("--------------------skip--------------------")
                continue
            else:
                print()
                station_names_set.add(station_name)
            # get petrol station id
            station_id = station.get_attribute("data-id")
            # switch driver focus to new tab
            browser.switch_to.window(browser.window_handles[1])
            # go the station to get price information
            browser.get(
                f'https://app.petrolprices.com/petrolstation/{station_id}')

            # get location of the station
            station_location = browser.find_element(
                By.XPATH, '/html/body/div/main/div/div[2]/div/div/div[2]/p').text[9:]

            # dictionary to store the information to be added
            station_information = {"name": station_name, "station_id": station_id, "station_location": station_location}
            try:
                station_facilities = browser.find_element(
                    By.XPATH, '/html/body/div/main/div/section[2]/div/div/div[1]/div[1]/section[1]/ul').text.split("\n")
                for facility in station_facilities:
                    station_information[facility] = True
            # if there are no facilities
            except NoSuchElementException:
                pass
            
            # add the station information to the to be dataframe
            stationDF.append(station_information)

            # switch focus back to main window
            browser.switch_to.window(browser.window_handles[0])
            counter += 1


# convert the list to a pandas dataframe
stationDF = pd.DataFrame(stationDF)

print(stationDF)

# save the results to the csv file stations.csv
stationDF.to_csv("stations.csv")
# ...dev
# makes it so the window is not closed

print("Run in ",time()-start,"seconds.")

# if not in headless mode
# don't close the window after running everything
if '--headless' not in options.arguments:
    while True:
        pass
