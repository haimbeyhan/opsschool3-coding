from urllib import parse
import requests
import json

def get_temperature(req_city):
    # returns a list including temperature and country
    url = 'https://api.apixu.com/v1/current.json?key=' + \
        api_key + '&q=' + parse.quote(req_city)
    weather_info = requests.get(url).text
    weather_dict = json.loads(weather_info)
    return list((weather_dict['current']['temp_c'], weather_dict['location']['country']))

# Getting from the website below our external ip and current city
url='https://ipinfo.io/'
ipinfo = requests.get(url).text
ipinfo_dict = json.loads(ipinfo)
ip = ipinfo_dict['ip']
city = ipinfo_dict['city']

api_key='777294ecb2164428a2d222227192002'

current_weather = get_temperature(city)[0]

f=open("weather.txt","w")
degree_sign = '\u00b0' # degree sign unicode
weather_string = f"Current weather in {city}: {current_weather}{degree_sign}"
f.write(weather_string)
f.close()

cities = ['Paris', 'London', 'Frankfurt', 'Athens', 'Amsterdam', 'Vienna', 'Munich', 'Zurich', 'Stockholm', 'Kiev']
for city in cities:
    city_detail = get_temperature(city)
    print(f"The weather in {city}, {city_detail[1]} is {city_detail[0]} degrees.")