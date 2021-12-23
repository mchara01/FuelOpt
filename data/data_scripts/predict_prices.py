import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import numpy as np


def predict_prices(fuel='ULSP', predict_len=5):
    """
        :param fuel : {String} type of fuel
        :param predict_len : {Integer} number of weeks we want to predict
        :return predictions : {Array: Float} predictions of price for each predicted week
    """
    data = pd.read_csv("uk_prices_2021.csv")

    #data = pd.read_csv("data/data_scripts/uk_prices_2021.csv")
    data = list(data[fuel])
    y = list(range(len(data)))
    # take 35 weeks into account
    weeks = 35
    X = np.array(data[weeks:]).reshape(-1, 1)  # values converts it into a numpy array
    Y = np.array(y[weeks:]).reshape(-1, 1)  # -1 means that calculate the dimension of rows, but have 1 column
    linear_regressor = LinearRegression()  # create object for the class
    linear_regressor.fit(Y, X)  # perform linear regression
    weeks = list(range(len(y) + predict_len))
    Y2 = np.array(weeks).reshape(-1, 1)
    predictions = linear_regressor.predict(Y2)  # make predictions
    return predictions[-predict_len:]

def predict_perc(predictions, current):
    """
    :param predictions: list of predictions
    :param current : {Float} current price
    :return : {Float} percentage diff of current price with the predicted one
    """
    prediction = predictions[-1]
    perc = float(((prediction - current) / current) * 100.0)
    perc = '{:.2f}'.format(perc)

    return perc

data = pd.read_csv("uk_prices_2021.csv")
#data = pd.read_csv("data/data_scripts/uk_prices_2021.csv")
fuel = "ULSP"
#fuel = "ULSD"
predictions = predict_prices(fuel, predict_len=5)

current = data[fuel].tolist()[-1]
perc = predict_perc(predictions, current)
print(perc)

with open('../../assets/trends_stats.txt', 'w') as f:
    f.write(str(perc))

weeks = list(range(len(data) + len(predictions)))
weeks = weeks[-len(predictions):]

data = list(data[fuel])
plt.plot(data, linewidth=3)
plt.plot(weeks, predictions, linewidth=3, color='red')
plt.title("Fuel Price Predictions")
plt.xlabel("Week of 2021")
plt.ylabel("Price in British Pounds")
plt.legend(["Actual Prices", "Predicted Prices"])
plt.savefig('../../assets/trends.png')
plt.show()








