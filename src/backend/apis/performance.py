import time
import urllib.request

time_taken = []
for distance in range(0,30,5):
    time.sleep(10)
    start = time.time()
    routeUrl = 'http://127.0.0.1:8000/apis/search/?user_preference=&location=Imperial%20College%20London&fuel_type=&distance=' + str(distance) + '&amenities='
    request = urllib.request.Request(routeUrl)
    response = urllib.request.urlopen(request)
    end = time.time()
    time_taken.append(end-start)
    print (response.getcode())

print(time_taken)