# Running Data from Strava

## Overview
This project focuses on analyzing personal workout data collected from Strava, aiming to uncover insights about training performance and trends. The workflow involves data extraction, transformation, and loading (ETL), SQL queries for data analysis, and data visualization through an interactive dashboard.

---

## Objectives
The primary goals of this project are:
- 1️⃣ How has my running pace evolved over time, and what is the predicted pace by December 2025?
- 2️⃣ How has the distance I run evolved, and what is the forecasted distance by December 2025?
- 3️⃣ What is the relationship between the time of day I run and both my pace and distance?

---

## Workflow
Before running the script, make sure you have:
- The first step was the ETL pipeline in python, to extract, transform and load the data from strava API to the MySQL database. You can check the code [here](https://github.com/renathohcc/strava-data-analysis/blob/main/scrap_strava_data.py)
- Second step was create SQL Queries to make the data analysis. You can check the queries [here](https://github.com/renathohcc/strava-data-analysis/blob/main/Queries_analysis.sql)
- Third step was the forecast analysis, where I used excel to build the logarithmics functions and make the previsions. You can check the pace progression file [here](https://github.com/renathohcc/strava-data-analysis/blob/main/prevision_pace_progression.xlsx) and the distance progression file [here](https://github.com/renathohcc/strava-data-analysis/blob/main/prevision_distance_progression.xlsx)
- Fourth step was design the dashboard background on Figma, to have the best visualization
- Finally, I built the dashboard in PowerBI, to visulization the insights
  
---

## Dashboard

![Pace progression analysis](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*V4mXQNtNm1cew3zTQJbNgw.png)

![Distance progression analysis](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*mn_1tZ8LNeOZFadu55zLiQ.png)

![Relationship between hour x distance x pace](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*r0s2LEGH-j7Fa7SwpWCLqA.png)

---

## Insights
- The average pace at the start of my training was 9.41 min/km. Currently, my average pace is 7.63 min/km, showing an improvement of 18.92%
- At the beginning of my training, the average distance of my runs was 2.44 km. As of now, it has increased to 5.15 km — an impressive 111% growth
- Morning runs showed the best pace and longest distances
- Evening runs were associated with shorter distances and slower paces

---

## Conclusions
- To achieve better results, I should prioritize morning runs
- I need to push myself harder in upcoming training sessions to realign with my projected progress
- The use of logarithmic models proved effective, as they reflect the reality that improvements become increasingly incremental over time

---

## Contribuition
Feel free to contribute with this repository and use the codes to your own studies and projects!

---

## 📜 License
This project is open-source and available under the MIT License.

---

### 🎯 Author
Developed by **Renatho Campos**  
📧 Contact: renathohcc@hotmail.com
