import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
import numpy as np

data = pd.read_csv("data/data_scripts/uk_prices_2021.csv")

def predict_prices(data, fuel='ULSP'):
    data = list(data[fuel])
    y = list(range(len(data)))
    # take 35 weeks into account
    X = np.array(data[35:]).reshape(-1, 1)  # values converts it into a numpy array
    Y = np.array(y[35:]).reshape(-1, 1)  # -1 means that calculate the dimension of rows, but have 1 column
    linear_regressor = LinearRegression()  # create object for the class
    linear_regressor.fit(Y, X)  # perform linear regression
    predict_len = 6
    weeks = list(range(len(y) + predict_len))
    Y2 = np.array(weeks).reshape(-1, 1)
    predictions = linear_regressor.predict(Y2)  # make predictions
    predictions = predictions[-predict_len:]
    return predictions


def predict_perc(predictions,current):
    """
    :param predictions: list of predictions
    :param current: current price
    :return: percentage diff of current price with the predicted one
    """
    prediction = predictions[-1]
    perc = float((abs(prediction - current) / current) * 100.0)
    return perc


#fuel = 'Unleaded' if fuel == 'ULSP' else 'Diesel'
#print("Warning! ",fuel," prices are going to rise {:.2f}% in the next {:.0f} weeks".format(perc,predict_len))

predictions = predict_prices(data)
print(predictions)

current = data['ULSP'].tolist()[-1]

print(predict_perc(predictions,current))

"""
weeks = list(range(len(data) + len(predictions)))
weeks = weeks[-len(predictions):]

plt.plot(data, linewidth=3)
plt.plot(weeks, predictions, linewidth=3, color='red')
plt.xlabel("Week of 2021")
plt.ylabel("Price in Pounds")
plt.fill_between(y, data,alpha=0.30)
#plt.fill_between(y2, X_pred2,alpha=0.30)
plt.show()
"""












