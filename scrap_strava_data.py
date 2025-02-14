import requests
import pandas as pd
import mysql.connector
from datetime import datetime
from stravalib import Client
import time

#Connect to the MySQL DataBase
conn = mysql.connector.connect(
    host="localhost",     
    user="root",    
    password="hopt1234",  
    database="strava" 
)
cursor = conn.cursor()

#Generate the acess token
# Step 1: Set up Strava client
client = Client()

# Step 2: Authenticate with Strava
client_id = "YOUR CLIENT_ID"
client_secret = "YOUR SECRET CLIENT KEY"
redirect_uri = "http://localhost"  # Must match the callback domain in your Strava app

# Generate the authorization URL
auth_url = client.authorization_url(
    client_id=client_id,
    redirect_uri=redirect_uri,
    scope="activity:read_all"  # Request read access to all activities
)

print(f"Go to this URL to authorize: {auth_url}")

# Step 3: Get the authorization code
# After authorizing, Strava will redirect you to the callback URL with a code.
# Copy the code from the URL and paste it here.
code = input("Enter the authorization code from the URL: ")

# Step 4: Exchange the code for an access token
token = client.exchange_code_for_token(
    client_id=client_id,
    client_secret=client_secret,
    code=code
)

#Collecting athlete data from strava API
TOKEN = token["access_token"]
athlete_url = "https://www.strava.com/api/v3/athlete?access_token=" + TOKEN
response_athlete = requests.get(athlete_url)
athlete_data = response_athlete.json()

#Get the athlete data
athlete_name = athlete_data["firstname"] + " " + athlete_data["lastname"]
gender = athlete_data["sex"]
age = athlete_data["age"] if "age" in athlete_data else None  # Check if the account have the age information or no

# Verifying if the athlete is already in the database nad insert new athletes
cursor.execute("SELECT id FROM athletes WHERE athlete_name = %s", (athlete_name,))
athlete = cursor.fetchone()

if athlete is None:
    cursor.execute("INSERT INTO athletes (athlete_name, gender, age) VALUES (%s, %s, %s)", 
                   (athlete_name, gender, age))
    conn.commit()
    athlete_id = cursor.lastrowid  # gets the new athlete id
else:
    athlete_id = athlete[0]  # use the existent id

#Collecting activities data from strava
activities_url = "https://www.strava.com/api/v3/athlete/activities?access_token=" + TOKEN
activities = []
page = 1
per_page = 150 #number of activities per page

while True:
    #Request to get activities with pagination
    paginated_url = f"{activities_url}&page={page}&per_page={per_page}"
    response_activities = requests.get(paginated_url)
    data = response_activities.json()

    if not data:
        break #If the data is null, stop the loop

    activities.extend(data) #Add recovered activities to the list
    page += 1 #next page

    time.sleep(1) #To avoid the request limit


#Transforming the data from json to dataframe
df = pd.DataFrame(activities)


df = df[['id', 'name', 'start_date', 'type', 'distance', 'moving_time', 
         'total_elevation_gain', 'max_speed', 'average_speed']]  # Select the columns that interest to the database values

# Converting some measures to better visualization
df["distance"] = df["distance"] / 1000  # Convert distance from meters to kilometers
df["moving_time"] = df["moving_time"] / 60  # Convert moving_time from seconds to minutes
df["max_speed"] = df["max_speed"] * 3.6  # Convert max_speed from m/s to km/h
df["average_speed"] = df["average_speed"] * 3.6  # Convert max_speed from m/s to km/h

#Convert start_date to the datatime format of MySQL
def convert_to_mysql_datetime(start_date):
    # Remove the sufix z and convert the format
    start_date = start_date.rstrip('Z')
    return datetime.strptime(start_date, '%Y-%m-%dT%H:%M:%S')

df["start_date"] = df["start_date"].apply(convert_to_mysql_datetime)

#Insert the activities data in the MySQL database, with duplicate verification
for _, row in df.iterrows():
    #Verify if the activity is already register in the database (check the id)
    cursor.execute("SELECT id from activities WHERE activity_id = %s", (row["id"],))
    existing_activity = cursor.fetchone()

    #If the activity não existir, insert in the database
    if existing_activity is None:
        cursor.execute("""
            INSERT INTO activities (athlete_id, activity_name, start_date, activity_type, distance, duration, elevation, 
                                    max_speed, avg_speed, activity_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (athlete_id, row["name"], row["start_date"], row["type"], row["distance"], row["moving_time"], 
            row["total_elevation_gain"], row["max_speed"], row["average_speed"], row["id"]))

conn.commit()  
cursor.close()
conn.close()
print("Athletes and activities inserts with sucess!")
