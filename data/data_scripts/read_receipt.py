import sys
import cv2
import pytesseract
import re
from user_information import new_price
from datetime import datetime

# image of receipt of user

def read_receipt(filepath):
    # image of receipt of user
    receipt = cv2.imread(filepath)
    text = pytesseract.image_to_string(receipt)
    text = text.splitlines()

    elements = []
    for line in text:
        # find line that mentions price
        if 'PRICE' in line:
            elements = line.split()

    # search for float value in price line
    price = -1
    for e in elements:
        try:
            # remove currency icon and replace coma with dot
            e = re.sub('£', '', e)
            e = re.sub('\$', '', e)
            e = re.sub(',', '.', e)
            price = float(str(e))
        except ValueError:
            continue

    # if no price is found exit as this receipt cannot be used
    if price == -1:
        print("No price provided in receipt")
        sys.exit()

    # find line that mentions product
    type = ''
    elements = []
    for line in text:
        if 'PRODUCT' in line:
            elements = line.split()

    # the word after product is the type of fuel
    if len(elements) > 1:
        type = elements[1]

    # if no type of fuel is found exit as this receipt cannot be used
    if type == '':
        print("No type of fuel provided in receipt")
        sys.exit()

    # change capital letters and shorted words to normal wording
    if type == 'UNLEADED' or type == 'UNLD':
        type = 'unleaded'

    if type == 'DIESEL' or type == 'DSL':
        type = 'diesel'

    if type == 'SUPER UNLEADED' or type == 'SUNLD':
        type = 'super_unleaded'

    if type == 'PREMIUM UNLEADED' or type == 'PDSL':
        type = 'premium_diesel'

    # TODO get station id based on location
    station_id = 0

    date = ''
    for t in text:
        try:
            date = datetime.strptime(t, '%Y/%m/%d')
        except ValueError:
            continue

    # update station data using receipt
    new_price(station_id, type, price)
