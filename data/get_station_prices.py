from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
from time import time
import pandas as pd

from dotenv import load_dotenv
import os 
load_dotenv()

start = time()
# options to run the chrome browser headless
# so no window is showing
options = Options()
# options.add_argument("--headless")

# signing in
data = {
    "email": os.getenv("PETROL_USERNAME"),
    "password": os.getenv("PETROL_PASSWORD"),
    "url_login": "https://app.petrolprices.com/login",
    "url_station": "https://app.petrolprices.com/petrolstation"
}

# initialise browser and go to sign in url
browser = webdriver.Chrome(ChromeDriverManager().install(), options=options)
browser.get(data['url_login'])

# fill the account info and click sign in
browser.find_element(By.NAME, "email").send_keys(data['email'])
browser.find_element(By.NAME, "password").send_keys(data['password'])
browser.find_element(By.ID, 'account-submit').click()

station_info = pd.read_csv("stations_with_coordinates.csv", usecols=[
                           'name', 'station_id', 'station_location', 'lat', 'lng'])

# lists to store all the information
# to be stored to the dataframe
# on the corresponding column
station_unleaded = []
station_super_unleaded = []
station_diesel = []
station_premium_diesel = []
station_unleaded_date = []
station_super_unleaded_date = []
station_diesel_date = []
station_premium_diesel_date = []

# go through each station's "stationid"
for row_index in range(len(station_info)):
    # go to the page of the corresponding petrol station
    browser.get(data['url_station']+"/" +
                str(station_info.loc[row_index]['station_id']))

    # get price for each type of fuel
    station_unleaded.append(browser.find_element(
        By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[1]/div/figure').text[:-1])
    station_super_unleaded.append(browser.find_element(
        By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[2]/div/figure').text[:-1])
    station_diesel.append(browser.find_element(
        By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[3]/div/figure').text[:-1])
    station_premium_diesel.append(browser.find_element(
        By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[4]/div/figure').text[:-1])

    # if there is no price
    # put "None" for the date
    if station_unleaded[-1] != "---.-":
        station_unleaded_date.append(browser.find_element(
            By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[1]/div/p').text.split(" ")[2][0:-3])
    else:
        station_unleaded_date.append("")

    if station_super_unleaded[-1] != "---.-":
        station_super_unleaded_date.append(browser.find_element(
            By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[2]/div/p').text.split(" ")[2][0:-3])
    else:
        station_super_unleaded_date.append("")
    
    if station_diesel[-1] != "---.-":
        station_diesel_date.append(browser.find_element(
            By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[3]/div/p').text.split(" ")[2][0:-3])
    else:
        station_diesel_date.append("")
    
    if station_premium_diesel[-1] != "---.-":
        station_premium_diesel_date.append(browser.find_element(
            By.XPATH, '/html/body/div/main/div/section[1]/div/div/div/div[4]/div/p').text.split(" ")[2][0:-3])
    else:
        station_premium_diesel_date.append("")

# put all the new information to the dataframe
station_info["unleaded"] = station_unleaded
station_info["super unleaded"] = station_super_unleaded
station_info["diesel"] = station_diesel
station_info["premium_diesel"] = station_premium_diesel
station_info["station_unleaded_date"] = station_unleaded_date
station_info["station_super_unleaded_date"] = station_super_unleaded_date 
station_info["station_diesel_date"] = station_diesel_date
station_info["station_premium_diesel_date"] = station_premium_diesel_date

station_info = station_info.replace("---.-","")
print(station_info)
station_info.to_csv("stations_all_info.csv")