import pandas as pd

def check_price_station(data, fuel, station_id):
    """
    :param data: the dataset of the prices
    :param fuel: the type of fuel we want to compare
    :param station_id: the id of the station we want to compare
    :return: {bool} True if it is cheaper and False if it is not.
    {float} The percentage compares to the whole dataset
    E.G. If it returns {True, 0.1} it means the price of this station for
    this fuel is in the cheaper 10%.
    If it returns {False, 0.2} it means the price of this station for
    this fuel is in the more expensive 20%.
    """
    data = data[data[fuel].notna()]
    data2 = pd.DataFrame(list(zip(data['station_id'], data[fuel])), columns=['station_id', 'price'])
    data2 = data2.sort_values(by='price').reset_index(drop=True)
    # find index of the given station
    if len(data2.index[data2['station_id'] == station_id].tolist())==0:
        return None,None
    index = data2.index[data2['station_id'] == station_id].tolist()[0]
    l = len(data2)
    # since the Dataframe is sorted is the index is less than a percent of the total lenght
    # then it means that it is cheaper, else that it is more expensive.
    if index <= l * 0.1:
        return True, 0.1
    if index <= l * 0.2:
        return True, 0.2
    if index >= l * 0.9:
        return False, 0.1
    if index >= l * 0.8:
        return False, 0.2
    return None, None

data = pd.read_csv("tools/data_scripts/stations_fuel_prices.csv")
fuel = 'diesel'
station_id = 12511
cheap , perc = check_price_station(data, fuel, station_id)
if cheap == None:
    print("Normal Price")
else:
    cheap = 'cheap' if cheap==True else 'expensive'
    print("This station is more ",cheap," than the ",perc*100,"%")









