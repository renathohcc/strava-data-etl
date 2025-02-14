# Strava Data ETL

## Overview
This project is an **ETL (Extract, Transform, Load) pipeline** for retrieving **Strava activities data** using the Strava API and storing it in a **MySQL database**. The script automates the authentication process, collects user activity data, processes it, and inserts it into a structured database.

---

## Objectives
- **Extract** activities and athlete data from the **Strava API**.
- **Transform** data (convert time, speed, distances and dates to readable formats).
- **Load** the cleaned data into a **MySQL database**.
- **Avoid duplicate entries** using activity ID and athlete ID validation.

---

## Prerequisites
Before running the script, make sure you have:
- **Python 3** installed.
- A **MySQL database** set up.
- A **Strava API account** with a registered app ([Strava API Setup](https://www.strava.com/settings/api)).
- The following Python libraries installed:
  ```bash
  pip install requests pandas mysql-connector-python stravalib
  ```

---

## 📜 Step-by-Step Guide

### 1️⃣ **MySQL connector**
The script requests **host**, **username**, **password** and **database name** from your MySQL Server

- It connects to your MySQL database.
- **Pay Atention:** Check the name of your tables and columns in the MySQL database and change the names in the scrip, if you need.

### 2️⃣ **Authentication with Strava API**
Fill the script with your **Client ID, Client Secret**.

- It generates an **authorization URL**, which the user must visit to approve access.
- After approval, Strava provides an **authorization code**, which is exchanged for an **Access Token**.

### 3️⃣ **Fetching Athlete Data**
Once authenticated, the script:
- Fetches **athlete details** (name, gender, and age if available).
- Checks if the athlete is already stored in the MySQL database.
- If not, inserts the athlete’s information into the database.

### 4️⃣ **Extracting Strava Activity Data**
The script:
- Retrieves **all user activities** using **pagination** (fetching multiple pages if needed). The pagination was used because Strava limit the request to 30 activities.
- Converts JSON response data into a **Pandas DataFrame**.

### 5️⃣ **Data Transformation**
- **Converts** distance from meters to **kilometers**.
- **Converts** moving time from seconds to **minutes**.
- **Converts** speed from meters/second to **km/h**.
- **Parses** start date into **MySQL DATETIME format**.

### 6️⃣ **Loading Data into MySQL**
- The script **checks for duplicate activities** (based on `activity_id`).
- If an activity does not exist, it is **inserted into the database**.
- A success message is displayed once all data is stored.

---

## How to Run the Script
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/strava-data-etl.git
   cd strava-data-etl
   ```
2. Run the script:
   ```bash
   python scrap_strava_data.py
   ```
3. Follow the authentication steps (enter **Client ID, Secret**, and **Authorization Code**).
4. The script will automatically **extract, transform, and load** data into your **MySQL database**.

---

## Database Schema
**`athletes` Table:**
| id | athlete_name | gender | age |
|----|-------------|--------|-----|
| 1  | John Doe    | M      | 29  |

**`activities` Table:**
| id | athlete_id | activity_name | start_date | activity_type | distance_km | duration_min | elevation_m | max_speed_kmh | avg_speed_kmh | activity_id |
|----|------------|---------------|------------|---------------|-------------|--------------|-------------|---------------|---------------|-------------|
| 1  | 1          | Morning Ride  | 2024-01-01 | Ride          | 25.3        | 90           | 200         | 45.0          | 30.5          | 123456789   |

---

## 🚀 Future Improvements
- Create a **Power BI dashboard** to visualize activity statistics.

---

## 🤝 Contributing
Feel free to fork this repository and submit pull requests if you’d like to improve the project!

---

## 📜 License
This project is open-source and available under the MIT License.

---

### 🎯 Author
Developed by **Renatho Campos**  
📧 Contact: renathohcc@hotmail.com
