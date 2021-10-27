from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from time import time
import pandas as pd

start = time()
# options to run the chrome browser headless
# so no window is showing
options = Options()
# options.add_argument("--headless")

# signing in
data = {
    "email": "johnbravie7@gmail.com",
    "password": "CaFfft6asnq.5j3",
    "url": "https://app.petrolprices.com/login"
}
# initialise browser and go to sign in url
browser = webdriver.Chrome(ChromeDriverManager().install(), options=options)
browser.get(data['url'])
# fill the account info and click sign in
browser.find_element(By.NAME, "email").send_keys(data['email'])
browser.find_element(By.NAME, "password").send_keys(data['password'])
browser.find_element(By.ID, 'account-submit').click()


latitude = 51.3

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
        print(
            f'For location with latitude:{arguments["latitude"]}, longitude:{arguments["longitude"]}')

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

        browser.find_element(By.ID, 'continue-button').click()

        for station in stations_results:
            station_price_date = station.find_elements(By.TAG_NAME, "h5")[
                2].text
            # get the name of the station from the stations page
            # so if the station is already looked up there is no need to check its prices
            station_name = station.find_element(
                By.CLASS_NAME, "station-name").text.split(". ")[1]
            print(station_name, end=" ")
            if station_name in station_names_set:
                print("--------------------skip--------------------")
                continue
            else:
                station_names_set.add(station_name)
            # get petrol station id
            station_id = station.get_attribute("data-id")
            # switch driver focus to new tab
            browser.switch_to.window(browser.window_handles[1])
            # go the station to get price information
            browser.get(
                f'https://app.petrolprices.com/petrolstation/{station_id}')

            # get price for each type of fuel
            station_unleaded = browser.find_element(
                By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[1]/div/figure').text
            station_super_unleaded = browser.find_element(
                By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[2]/div/figure').text
            station_diesel = browser.find_element(
                By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[3]/div/figure').text
            station_premium_diesel = browser.find_element(
                By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[4]/div/figure').text

            # get location of the station
            station_location = browser.find_element(
                By.XPATH, '/html/body/div/main/div/div[2]/div/div/div[2]/p').text[9:]

            # if there is a price
            # get the price and the date the price was recorded
            if station_unleaded != "---.-p":
                station_unleaded_date = browser.find_element(
                    By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[1]/div/p').text.split(" ")[2][0:-3]
            else:
                station_unleaded = None
                station_unleaded_date = None

            if station_super_unleaded != "---.-p":
                station_super_unleaded_date = browser.find_element(
                    By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[2]/div/p').text.split(" ")[2][0:-3]
            else:
                station_super_unleaded = None
                station_super_unleaded_date = None

            if station_diesel != "---.-p":
                station_diesel_date = browser.find_element(
                    By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[3]/div/p').text.split(" ")[2][0:-3]
            else:
                station_diesel = None
                station_diesel_date = None

            if station_premium_diesel != "---.-p":
                station_premium_diesel_date = browser.find_element(
                    By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[4]/div/p').text.split(" ")[2][0:-3]
            else:
                station_premium_diesel = None
                station_premium_diesel_date = None

            # add the station information to the to be dataframe
            stationDF.append({"name": station_name, "unleaded": station_unleaded, "super unleaded": station_super_unleaded,
                              "diesel": station_diesel, "premium diesel": station_premium_diesel, "price date": station_price_date, 
                              "station_unleaded_date": station_unleaded_date, "station_super_unleaded_date": station_super_unleaded_date, 
                              "station_diesel_date": station_diesel_date, "station_premium_diesel_date": station_premium_diesel_date,
                              "station_location":station_location})

            # switch focus back to main window
            browser.switch_to.window(browser.window_handles[0])
            counter += 1
            print(counter)
            # if counter == 5:
            #     break


# convert the list to a pandas dataframe
stationDF = pd.DataFrame(stationDF)


print(stationDF)

# save the results to the csv file stations.csv
stationDF.to_csv("stations.csv")
# ...dev
# makes it so the window is not closed

print(time()-start)

# if not in headless mode
# don't close the window after running everything
if '--headless' not in options.arguments:
    while True:
        pass