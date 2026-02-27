import json
from pprint import pprint
from geopy import distance
import folium
import yan

apikey = "672d1e6e-a28f-4488-840a-c0b4715251d6"

with open("coffee.json", "r", encoding="cp1251") as my_file:
    coffees = json.load(my_file)
point = input("Где вы находитесь? ")
coord = yan.fetch_coordinates(apikey, point)

user_lat, user_long = coord
coffee_with_distances = []
for coffee in coffees:
    lon = (coffee["Latitude_WGS84"])
    lat = (coffee["Longitude_WGS84"])

    dist = distance.distance((user_lat, user_long), (lat, lon)).km

    coffee_with_distances.append({
        "title": coffee["Name"],
        "distance": dist,
        "latitude": lon,
        "longitude": lat,
      })
def get_distance(coffee):
    return coffee["distance"]
nearest_coffee = sorted(coffee_with_distances, key=get_distance)[:5]
pprint(nearest_coffee)

coffee_map = folium.Map(location=[user_lat, user_long], zoom_start=12)

folium.Marker(
    [user_lat, user_long],
    popup=coffee["Name"],
).add_to(coffee_map)

for coffee in nearest_coffee:
    folium.Marker(
        [coffee["latitude"], coffee["longitude"]],
        popup=f'{coffee["title"]} ({coffee["distance"]:.2f} км)',
        tooltip=coffee["title"]
    ).add_to(coffee_map)

coffee_map.save("coffee_map.html")
