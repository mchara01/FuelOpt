import pandas as pd

df = pd.read_csv("tools/reviews/reviews_to_approved.csv")
df2 = pd.read_csv("tools/reviews/approved_reviews.csv")

# the function to let the user add a review with a score to a station
# the reviews are saved in file awaited to be approved by an admin
def add_review(df, station, review_text, score=None):
    df = df.append({'review_id': len(df), 'station':station, 'review_txt':review_text, 'score':score}, ignore_index=True)
    df.to_csv("tools/reviews/reviews_to_approved.csv",index=False)

# the function to let an admin approve of a specific review,
# this review get
def approve_review(df,df2, review_id):
    # get the station id of the review
    station_id = df.loc[df['review_id'] == review_id, 'station'][0]
    # add row for this review
    df2 = df2.append({'station_id': station_id, 'review_id': review_id}, ignore_index=True)
    # save chabges
    df2.to_csv("tools/reviews/approved_reviews.csv", index=False)


