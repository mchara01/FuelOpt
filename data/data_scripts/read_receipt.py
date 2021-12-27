import sys
import cv2
import pytesseract
import re
from user_information import new_price
from datetime import datetime

def read_receipt(filepath):
    """
    :param filepath: path of receipt file
    :return: tuple of price, fuel type and datetime found in the receipt, if some of these information
    is not visible it will return None
    """
    # image of receipt of user
    text = pytesseract.image_to_string(filepath)
    text = text.splitlines()

    price = None

    elements = []
    for line in text:
        # find line that mentions @
        if '@' in line:
            elements = line.split()

    for i in range(len(elements)):
        if elements[i] == '@':
            try:
                price = elements[i+1]
            except Exception:
                pass
    elements = []
    for line in text:
        # find line that mentions price
        if 'PRICE' in line:
            elements = line.split()

    # search for float value in price line
    for e in elements:
        try:
            # remove currency icon and replace coma with dot
            e = re.sub('£', '',e)
            e = re.sub('\$', '',e)
            e = re.sub('€', '', e)
            e = re.sub(',', '.', e)
            price = float(str(e))
        except ValueError:
            continue

    # find line that mentions product
    type_of_fuel = None
    elements = []
    for line in text:
        if 'PRODUCT' in line:
            elements = line.split()

    # the word after product is the type of fuel
    if len(elements) > 1:
        type_of_fuel = elements[1]

    # change capital letters and shorted words to normal wording
    if type_of_fuel == 'UNLEADED' or type_of_fuel == 'UNLD':
        type_of_fuel = 'unleaded'

    if type_of_fuel == 'DIESEL' or type_of_fuel == 'DSL' or type_of_fuel == 'Regular Diesel'\
            or type_of_fuel == 'REGULAR DIESEL':
        type_of_fuel = 'diesel'

    if type_of_fuel == 'SUPER UNLEADED' or type_of_fuel == 'SUNLD':
        type_of_fuel = 'super_unleaded'

    if type_of_fuel == 'PREMIUM UNLEADED' or type_of_fuel == 'PDSL':
        type_of_fuel = 'premium_diesel'

    date = None
    for t in text:
            text2 = t.split(' ')
            for i in range(len(text2)):
                try:
                    date = datetime.strptime(text2[i], '%d/%m/%Y')
                except ValueError:
                    pass
                try:
                    date = datetime.strptime(text2[i], '%d/%m/%y')
                except ValueError:
                    pass
                try:
                    date = datetime.strptime(text2[i], '%Y/%m/%d')
                except ValueError:
                    pass

    return price, type_of_fuel, date